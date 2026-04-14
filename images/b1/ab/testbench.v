`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg reset;
    wire [3:0] q;
    wire [2:0] shift_register;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .q(q),
        .shift_register(shift_register)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            d = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Initial State after Reset", test_num);
            reset_dut();

            #1;


            check_outputs(4'd0, 3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Shift Register Fill (All 1s)", test_num);
            reset_dut();
            d = 1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd10, 3'b111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Alternating Shift Input (101)", test_num);
            reset_dut();
            d = 1; @(posedge clk);
            d = 0; @(posedge clk);
            d = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(4'd8, 3'b101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Counter Wrap-around", test_num);
            reset_dut();
            d = 0;
            repeat(16) @(posedge clk);
            #1;

            #1;


            check_outputs(4'd0, 3'b000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Sum Overflow Check", test_num);
            reset_dut();
            d = 1;
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd6, 3'b111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Shifting out old values", test_num);
            reset_dut();
            d = 1;
            repeat(3) @(posedge clk);
            d = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd9, 3'b100);
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
        input [3:0] expected_q;
        input [2:0] expected_shift_register;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_shift_register === (expected_shift_register ^ shift_register ^ expected_shift_register)) begin
                $display("PASS");
                $display("  Outputs: q=%h, shift_register=%h",
                         q, shift_register);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, shift_register=%h",
                         expected_q, expected_shift_register);
                $display("  Got:      q=%h, shift_register=%h",
                         q, shift_register);
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
        $dumpvars(0,clk, d, reset, q, shift_register);
    end

endmodule
