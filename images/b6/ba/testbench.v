`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg LD;
    reg RST;
    reg UD;
    reg [3:0] load_value;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .LD(LD),
        .RST(RST),
        .UD(UD),
        .load_value(load_value),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RST = 1;
        LD = 0;
        UD = 0;
        load_value = 0;
        @(posedge CLK);
        #1 RST = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %03d: Basic Reset", test_num);
        reset_dut();
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %03d: Load 4'hA", test_num);
        reset_dut();
        @(negedge CLK);
        LD = 1;
        load_value = 4'hA;
        @(posedge CLK);
        #1 LD = 0;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %03d: Count up 5 times", test_num);
        reset_dut();
        @(negedge CLK);
        UD = 1;
        repeat(5) @(posedge CLK);
        #1 UD = 0;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %03d: Count down 1 time from 0", test_num);
        reset_dut();
        @(negedge CLK);
        UD = 0;
        @(posedge CLK);
        #1 #1;
 check_outputs(4'hF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %03d: Upward wrap-around", test_num);
        reset_dut();
        @(negedge CLK);
        LD = 1;
        load_value = 4'hE;
        @(posedge CLK);
        #1 LD = 0;
        UD = 1;
        repeat(3) @(posedge CLK);
        #1 #1;
 check_outputs(4'h1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %03d: Downward wrap-around", test_num);
        reset_dut();
        @(negedge CLK);
        LD = 1;
        load_value = 4'h2;
        @(posedge CLK);
        #1 LD = 0;
        UD = 0;
        repeat(3) @(posedge CLK);
        #1 #1;
 check_outputs(4'hF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %03d: Load priority over counting", test_num);
        reset_dut();
        @(negedge CLK);
        LD = 1;
        UD = 1;
        load_value = 4'h7;
        @(posedge CLK);
        #1 LD = 0;
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %03d: Reset priority over Load", test_num);
        reset_dut();
        @(negedge CLK);
        RST = 1;
        LD = 1;
        load_value = 4'hF;
        @(posedge CLK);
        #1 RST = 0;
        #1;

        check_outputs(4'h0);
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
        testcase007();
        testcase008();
        
        
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,CLK, LD, RST, UD, load_value, Q);
    end

endmodule
