`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RESET;
    wire Q0;
    wire Q1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RESET(RESET),
        .Q0(Q0),
        .Q1(Q1)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        @(negedge CLK);
        RESET = 1;
        @(negedge CLK);
        RESET = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Reset Check", test_num);
        reset_dut();

        @(posedge CLK);
        #1;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Increment to 01", test_num);
        reset_dut();
        @(negedge CLK);
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Increment to 10", test_num);
        reset_dut();
        repeat(2) @(negedge CLK);
        @(posedge CLK);
        #1;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Increment to 11", test_num);
        reset_dut();
        repeat(3) @(negedge CLK);
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Wrap-around Check (11 to 00)", test_num);
        reset_dut();
        repeat(4) @(negedge CLK);
        @(posedge CLK);
        #1;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Mid-count Synchronous Reset", test_num);
        reset_dut();
        repeat(2) @(negedge CLK);
        @(negedge CLK);
        RESET = 1;
        @(negedge CLK);
        RESET = 0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Long Cycle Check (9 cycles)", test_num);
        reset_dut();
        repeat(9) @(negedge CLK);
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1, 0);
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
        input expected_Q0;
        input expected_Q1;
        begin
            if (expected_Q0 === (expected_Q0 ^ Q0 ^ expected_Q0) &&
                expected_Q1 === (expected_Q1 ^ Q1 ^ expected_Q1)) begin
                $display("PASS");
                $display("  Outputs: Q0=%b, Q1=%b",
                         Q0, Q1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q0=%b, Q1=%b",
                         expected_Q0, expected_Q1);
                $display("  Got:      Q0=%b, Q1=%b",
                         Q0, Q1);
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
        $dumpvars(0,CLK, RESET, Q0, Q1);
    end

endmodule
