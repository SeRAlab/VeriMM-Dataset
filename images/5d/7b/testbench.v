`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [2:0] RD;
    reg Reg_Write;
    reg Reset;
    reg [7:0] Write_Data;
    wire [7:0] Read_Data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .RD(RD),
        .Reg_Write(Reg_Write),
        .Reset(Reset),
        .Write_Data(Write_Data),
        .Read_Data(Read_Data)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Reset = 1;
            RD = 0;
            Write_Data = 0;
            Reg_Write = 0;
            #5;
            Reset = 0;
            #10;
            Reset = 1;
            #5;
        end
        endtask
    task clock_pulse;

        begin
            @(posedge Clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying reset values (Reg[i] = i)", test_num);
            reset_dut();


            RD = 3'd0;
            #2 #1;
 check_outputs(8'h00);


            RD = 3'd4;
            #2 #1;
 check_outputs(8'h04);


            RD = 3'd7;
            #2 #1;
 check_outputs(8'h07);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Simple Write to Reg 2", test_num);
            reset_dut();

            @(negedge Clk);
            RD = 3'd2;
            Write_Data = 8'hAA;
            Reg_Write = 1;

            clock_pulse();

            Reg_Write = 0;
            RD = 3'd2;
            #2 #1;
 check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verify Write Enable signal", test_num);
            reset_dut();

            @(negedge Clk);
            RD = 3'd3;
            Write_Data = 8'hFF;
            Reg_Write = 0;

            clock_pulse();

            RD = 3'd3;
            #2 #1;
 check_outputs(8'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Overwrite register data", test_num);
            reset_dut();

            @(negedge Clk);
            RD = 3'd5;
            Write_Data = 8'h55;
            Reg_Write = 1;
            clock_pulse();

            Write_Data = 8'h66;
            clock_pulse();

            Reg_Write = 0;
            #2 #1;
 check_outputs(8'h66);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Continuous Read check", test_num);
            reset_dut();


            @(negedge Clk);
            RD = 3'd1;
            Write_Data = 8'hDE;
            Reg_Write = 1;
            clock_pulse();


            RD = 3'd6;
            Write_Data = 8'hAD;
            clock_pulse();

            Reg_Write = 0;


            RD = 3'd1;
            #1;
            if (Read_Data == 8'hDE) begin
                RD = 3'd6;
                #1;
                #1;

                check_outputs(8'hAD);
            end else begin
                #1;

                check_outputs(8'hDE);
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
        testcase005();
        
        
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
        input [7:0] expected_Read_Data;
        begin
            if (expected_Read_Data === (expected_Read_Data ^ Read_Data ^ expected_Read_Data)) begin
                $display("PASS");
                $display("  Outputs: Read_Data=%h",
                         Read_Data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Read_Data=%h",
                         expected_Read_Data);
                $display("  Got:      Read_Data=%h",
                         Read_Data);
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
        $dumpvars(0,Clk, RD, Reg_Write, Reset, Write_Data, Read_Data);
    end

endmodule
