`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire Q0;
    wire Q1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .Q0(Q0),
        .Q1(Q1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            #2;
            rst = 0;
            #10;
            rst = 1;
            #2;

            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Checking Reset State", test_num);
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            #1;
            $display("Test %0d: After 1 Clock Cycle", test_num);
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: After 2 Clock Cycles", test_num);
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            repeat(3) @(posedge clk);
            #1;
            $display("Test %0d: After 3 Clock Cycles", test_num);
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            repeat(4) @(posedge clk);
            #1;
            $display("Test %0d: Rollover After 4 Clock Cycles", test_num);
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            $display("Test %0d: 5 Cycles (Rollover + 1)", test_num);
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            repeat(3) @(posedge clk);
            rst = 0; #10; rst = 1;
            #1;
            $display("Test %0d: Mid-count Reset", test_num);
            #1;

            check_outputs(0, 0);
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
        $dumpvars(0,clk, rst, Q0, Q1);
    end

endmodule
