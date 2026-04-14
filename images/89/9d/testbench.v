`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk_i;
    reg Reset_n_i;
    reg [7:0] SPI_Data_i;
    reg SPI_FSM_Start;
    reg SPI_Transmission_i;
    wire [7:0] Byte0;
    wire [7:0] Byte1;
    wire MAX6682CS_n_o;
    wire SPI_FSM_Done;
    wire SPI_ReadNext_o;
    wire SPI_Write_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk_i(Clk_i),
        .Reset_n_i(Reset_n_i),
        .SPI_Data_i(SPI_Data_i),
        .SPI_FSM_Start(SPI_FSM_Start),
        .SPI_Transmission_i(SPI_Transmission_i),
        .Byte0(Byte0),
        .Byte1(Byte1),
        .MAX6682CS_n_o(MAX6682CS_n_o),
        .SPI_FSM_Done(SPI_FSM_Done),
        .SPI_ReadNext_o(SPI_ReadNext_o),
        .SPI_Write_o(SPI_Write_o)
    );

    // Clock generation (10ns period)
    initial begin
        Clk_i = 0;
        forever #5 Clk_i = ~Clk_i;
    end

        task reset_dut;

        begin
            Reset_n_i = 0;
            SPI_FSM_Start = 0;
            SPI_Transmission_i = 0;
            SPI_Data_i = 8'h00;
            repeat(2) @(posedge Clk_i);
            #1 Reset_n_i = 1;
            @(posedge Clk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset and Idle Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00, 1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Normal Data Transfer (0x12, 0x34)", test_num);
            reset_dut();


            SPI_FSM_Start = 1;
            @(posedge Clk_i);
            SPI_FSM_Start = 0;


            wait(SPI_Write_o == 1'b1);
            @(posedge Clk_i);
            SPI_Transmission_i = 1;
            repeat(5) @(posedge Clk_i);
            SPI_Data_i = 8'h12;
            SPI_Transmission_i = 0;


            wait(SPI_ReadNext_o == 1'b1);
            @(posedge Clk_i);
            SPI_Transmission_i = 1;
            repeat(5) @(posedge Clk_i);
            SPI_Data_i = 8'h34;
            SPI_Transmission_i = 0;


            wait(SPI_FSM_Done == 1'b1);
            #1;


            #1;



            check_outputs(8'h12, 8'h34, 1'b1, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Successive Data Transfer (0xAA, 0x55)", test_num);
            reset_dut();


            SPI_FSM_Start = 1;
            @(posedge Clk_i);
            SPI_FSM_Start = 0;


            wait(SPI_Write_o == 1'b1);
            @(posedge Clk_i);
            SPI_Transmission_i = 1;
            repeat(2) @(posedge Clk_i);
            SPI_Data_i = 8'hAA;
            SPI_Transmission_i = 0;


            wait(SPI_ReadNext_o == 1'b1);
            @(posedge Clk_i);
            SPI_Transmission_i = 1;
            repeat(2) @(posedge Clk_i);
            SPI_Data_i = 8'h55;
            SPI_Transmission_i = 0;


            wait(SPI_FSM_Done == 1'b1);
            #1;

            #1;


            check_outputs(8'hAA, 8'h55, 1'b1, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Verify CS Active Low during transfer", test_num);
            reset_dut();

            SPI_FSM_Start = 1;
            @(posedge Clk_i);
            SPI_FSM_Start = 0;


            wait(SPI_Write_o == 1'b1);
            #1;
            if (MAX6682CS_n_o == 1'b0) begin

                SPI_Transmission_i = 1; @(posedge Clk_i); SPI_Data_i = 8'hFF; SPI_Transmission_i = 0;
                wait(SPI_ReadNext_o == 1'b1);
                @(posedge Clk_i);
                SPI_Transmission_i = 1; @(posedge Clk_i); SPI_Data_i = 8'hEE; SPI_Transmission_i = 0;
                wait(SPI_FSM_Done == 1'b1);
                #1;
                #1;

                check_outputs(8'hFF, 8'hEE, 1'b1, 1'b1, 1'b0, 1'b0);
            end else begin
                $display("FAIL: CS signal did not drop during transmission start");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [7:0] expected_Byte0;
        input [7:0] expected_Byte1;
        input expected_MAX6682CS_n_o;
        input expected_SPI_FSM_Done;
        input expected_SPI_ReadNext_o;
        input expected_SPI_Write_o;
        begin
            if (expected_Byte0 === (expected_Byte0 ^ Byte0 ^ expected_Byte0) &&
                expected_Byte1 === (expected_Byte1 ^ Byte1 ^ expected_Byte1) &&
                expected_MAX6682CS_n_o === (expected_MAX6682CS_n_o ^ MAX6682CS_n_o ^ expected_MAX6682CS_n_o) &&
                expected_SPI_FSM_Done === (expected_SPI_FSM_Done ^ SPI_FSM_Done ^ expected_SPI_FSM_Done) &&
                expected_SPI_ReadNext_o === (expected_SPI_ReadNext_o ^ SPI_ReadNext_o ^ expected_SPI_ReadNext_o) &&
                expected_SPI_Write_o === (expected_SPI_Write_o ^ SPI_Write_o ^ expected_SPI_Write_o)) begin
                $display("PASS");
                $display("  Outputs: Byte0=%h, Byte1=%h, MAX6682CS_n_o=%b, SPI_FSM_Done=%b, SPI_ReadNext_o=%b, SPI_Write_o=%b",
                         Byte0, Byte1, MAX6682CS_n_o, SPI_FSM_Done, SPI_ReadNext_o, SPI_Write_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Byte0=%h, Byte1=%h, MAX6682CS_n_o=%b, SPI_FSM_Done=%b, SPI_ReadNext_o=%b, SPI_Write_o=%b",
                         expected_Byte0, expected_Byte1, expected_MAX6682CS_n_o, expected_SPI_FSM_Done, expected_SPI_ReadNext_o, expected_SPI_Write_o);
                $display("  Got:      Byte0=%h, Byte1=%h, MAX6682CS_n_o=%b, SPI_FSM_Done=%b, SPI_ReadNext_o=%b, SPI_Write_o=%b",
                         Byte0, Byte1, MAX6682CS_n_o, SPI_FSM_Done, SPI_ReadNext_o, SPI_Write_o);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,Clk_i, Reset_n_i, SPI_Data_i, SPI_FSM_Start, SPI_Transmission_i, Byte0, Byte1, MAX6682CS_n_o, SPI_FSM_Done, SPI_ReadNext_o, SPI_Write_o);
    end

endmodule
