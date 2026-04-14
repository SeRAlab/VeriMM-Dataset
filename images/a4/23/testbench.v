`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg R;
    reg ce;
    reg sys_clk;
    wire CEO;
    wire [3:0] Q;
    wire TC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .R(R),
        .ce(ce),
        .sys_clk(sys_clk),
        .CEO(CEO),
        .Q(Q),
        .TC(TC)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

        task reset_dut;

        begin
            R = 1;
            ce = 0;
            @(negedge sys_clk);
            R = 0;
            @(negedge sys_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset verification", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0, 4'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Incrementing 5 times", test_num);
            reset_dut();
            ce = 1;
            repeat(5) @(negedge sys_clk);
            #1;

            check_outputs(1'b0, 4'h5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Terminal Count (TC=15)", test_num);
            reset_dut();
            ce = 1;
            repeat(15) @(negedge sys_clk);
            #1;

            check_outputs(1'b1, 4'hF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Disable ce during counting", test_num);
            reset_dut();
            ce = 1;
            repeat(3) @(negedge sys_clk);
            ce = 0;
            repeat(3) @(negedge sys_clk);
            #1;

            check_outputs(1'b0, 4'h3, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow/Wrap around (15 -> 0)", test_num);
            reset_dut();
            ce = 1;
            repeat(16) @(negedge sys_clk);
            #1;

            check_outputs(1'b0, 4'h0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: CEO behavior when ce=0 at TC=1", test_num);
            reset_dut();
            ce = 1;
            repeat(15) @(negedge sys_clk);
            ce = 0;
            @(negedge sys_clk);
            #1;

            check_outputs(1'b0, 4'hF, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous-like synchronous reset middle of count", test_num);
            reset_dut();
            ce = 1;
            repeat(8) @(negedge sys_clk);
            R = 1;
            @(negedge sys_clk);
            R = 0;
            #1;

            check_outputs(1'b0, 4'h0, 1'b0);
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
        input expected_CEO;
        input [3:0] expected_Q;
        input expected_TC;
        begin
            if (expected_CEO === (expected_CEO ^ CEO ^ expected_CEO) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_TC === (expected_TC ^ TC ^ expected_TC)) begin
                $display("PASS");
                $display("  Outputs: CEO=%b, Q=%h, TC=%b",
                         CEO, Q, TC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CEO=%b, Q=%h, TC=%b",
                         expected_CEO, expected_Q, expected_TC);
                $display("  Got:      CEO=%b, Q=%h, TC=%b",
                         CEO, Q, TC);
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
        $dumpvars(0,R, ce, sys_clk, CEO, Q, TC);
    end

endmodule
