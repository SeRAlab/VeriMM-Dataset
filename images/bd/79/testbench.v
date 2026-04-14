`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg [31:0] DataIN;
    reg [5:0] RD;
    reg [5:0] RS;
    reg [5:0] RT;
    reg RegWrite;
    wire [31:0] rs_Reg;
    wire [31:0] rt_Reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clock(Clock),
        .DataIN(DataIN),
        .RD(RD),
        .RS(RS),
        .RT(RT),
        .RegWrite(RegWrite),
        .rs_Reg(rs_Reg),
        .rt_Reg(rt_Reg)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            RegWrite = 0;
            RS = 0;
            RT = 0;
            RD = 0;
            DataIN = 0;
            @(posedge Clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case 001: Basic Write and Read (RS)");


            RegWrite = 1;
            RD = 6'd5;
            DataIN = 32'hAAAABBBB;
            @(posedge Clock);
            #1;


            RegWrite = 0;
            RS = 6'd5;
            RT = 6'd0;
            #2;

            #1;


            check_outputs(32'hAAAABBBB, 32'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case 002: Dual Read (RS and RT)");


            RegWrite = 1; RD = 6'd10; DataIN = 32'h12345678;
            @(posedge Clock); #1;


            RegWrite = 1; RD = 6'd20; DataIN = 32'h87654321;
            @(posedge Clock); #1;


            RegWrite = 0;
            RS = 6'd10;
            RT = 6'd20;
            #2;

            #1;


            check_outputs(32'h12345678, 32'h87654321);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case 003: RegWrite Enable Check");


            RegWrite = 1; RD = 6'd15; DataIN = 32'h55555555;
            @(posedge Clock); #1;


            RegWrite = 0; RD = 6'd15; DataIN = 32'hFFFFFFFF;
            @(posedge Clock); #1;


            RS = 6'd15;
            RT = 6'd0;
            #2;

            #1;


            check_outputs(32'h55555555, 32'h0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case 004: Boundary Address (Reg 63)");

            RegWrite = 1; RD = 6'd63; DataIN = 32'hDEADBEEF;
            @(posedge Clock); #1;

            RS = 6'd0;
            RT = 6'd63;
            #2;

            #1;


            check_outputs(32'h0, 32'hDEADBEEF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case 005: Overwriting Register Data");


            RegWrite = 1; RD = 6'd7; DataIN = 32'h11111111;
            @(posedge Clock); #1;


            RegWrite = 1; RD = 6'd7; DataIN = 32'h22222222;
            @(posedge Clock); #1;

            RS = 6'd7; RT = 6'd7;
            #2;

            #1;


            check_outputs(32'h22222222, 32'h22222222);
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
        input [31:0] expected_rs_Reg;
        input [31:0] expected_rt_Reg;
        begin
            if (expected_rs_Reg === (expected_rs_Reg ^ rs_Reg ^ expected_rs_Reg) &&
                expected_rt_Reg === (expected_rt_Reg ^ rt_Reg ^ expected_rt_Reg)) begin
                $display("PASS");
                $display("  Outputs: rs_Reg=%h, rt_Reg=%h",
                         rs_Reg, rt_Reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rs_Reg=%h, rt_Reg=%h",
                         expected_rs_Reg, expected_rt_Reg);
                $display("  Got:      rs_Reg=%h, rt_Reg=%h",
                         rs_Reg, rt_Reg);
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
        $dumpvars(0,Clock, DataIN, RD, RS, RT, RegWrite, rs_Reg, rt_Reg);
    end

endmodule
