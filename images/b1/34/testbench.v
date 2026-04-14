`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] i_Data;
    reg i_Done;
    reg i_Enable;
    reg i_Pclk;
    reg i_Reset;
    wire o_Busy;
    wire [7:0] o_Data;
    wire o_Ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_Data(i_Data),
        .i_Done(i_Done),
        .i_Enable(i_Enable),
        .i_Pclk(i_Pclk),
        .i_Reset(i_Reset),
        .o_Busy(o_Busy),
        .o_Data(o_Data),
        .o_Ready(o_Ready)
    );

    // Clock generation (10ns period)
    initial begin
        i_Pclk = 0;
        forever #5 i_Pclk = ~i_Pclk;
    end

        task reset_dut;

        begin
            i_Reset = 1;
            i_Enable = 0;
            i_Done = 0;
            i_Data = 0;
            repeat(2) @(posedge i_Pclk);
            i_Reset = 0;
            repeat(1) @(posedge i_Pclk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            @(posedge i_Pclk);
            i_Data = 8'h55;
            i_Enable = 1;
            @(posedge i_Pclk);
            i_Enable = 0;


            repeat(2) @(posedge i_Pclk);
            i_Done = 1;
            @(posedge i_Pclk);
            i_Done = 0;
            @(posedge i_Pclk);


            #1;



            check_outputs(1'b0, 8'h55, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            @(posedge i_Pclk);
            i_Data = 8'hAA;
            i_Enable = 1;
            @(posedge i_Pclk);
            i_Enable = 0;

            repeat(1) @(posedge i_Pclk);
            i_Done = 1;
            @(posedge i_Pclk);
            i_Done = 0;
            @(posedge i_Pclk);

            #1;


            check_outputs(1'b0, 8'hAA, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(posedge i_Pclk);
            i_Data = 8'hFF;
            i_Enable = 1;
            @(posedge i_Pclk);
            i_Enable = 0;


            repeat(1) @(posedge i_Pclk);


            #1;



            check_outputs(1'b1, 8'hFF, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(posedge i_Pclk);
            i_Data = 8'h12;
            i_Enable = 0;

            repeat(3) @(posedge i_Pclk);


            #1;



            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            @(posedge i_Pclk);
            i_Data = 8'hCC;
            i_Enable = 1;
            @(posedge i_Pclk);
            i_Enable = 0;

            repeat(1) @(posedge i_Pclk);

            i_Reset = 1;
            repeat(2) @(posedge i_Pclk);
            i_Reset = 0;
            @(posedge i_Pclk);


            #1;



            check_outputs(1'b0, 8'h00, 1'b0);
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
        testcase005();
        testcase006();
        
        
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
        input expected_o_Busy;
        input [7:0] expected_o_Data;
        input expected_o_Ready;
        begin
            if (expected_o_Busy === (expected_o_Busy ^ o_Busy ^ expected_o_Busy) &&
                expected_o_Data === (expected_o_Data ^ o_Data ^ expected_o_Data) &&
                expected_o_Ready === (expected_o_Ready ^ o_Ready ^ expected_o_Ready)) begin
                $display("PASS");
                $display("  Outputs: o_Busy=%b, o_Data=%h, o_Ready=%b",
                         o_Busy, o_Data, o_Ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_Busy=%b, o_Data=%h, o_Ready=%b",
                         expected_o_Busy, expected_o_Data, expected_o_Ready);
                $display("  Got:      o_Busy=%b, o_Data=%h, o_Ready=%b",
                         o_Busy, o_Data, o_Ready);
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
        $dumpvars(0,i_Data, i_Done, i_Enable, i_Pclk, i_Reset, o_Busy, o_Data, o_Ready);
    end

endmodule
