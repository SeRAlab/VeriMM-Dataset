`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg high;
    reg low;
    reg resetn;
    wire decrease;
    wire increase;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .high(high),
        .low(low),
        .resetn(resetn),
        .decrease(decrease),
        .increase(increase)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        resetn = 0;
        high = 0;
        low = 0;
        @(posedge clk);
        #1;
        resetn = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Reset State Verification", test_num);
        reset_dut();

        #1;


        check_outputs(0, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Assert 'high' input", test_num);
        reset_dut();
        high = 1;
        low = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Assert 'low' input", test_num);
        reset_dut();
        high = 0;
        low = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Hold state (Maintain Decrease)", test_num);
        reset_dut();

        high = 0;
        low = 1;
        @(posedge clk);
        #1;

        high = 0;
        low = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Simultaneous 'high' and 'low'", test_num);
        reset_dut();

        high = 1;
        low = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(0, 1);
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
        input expected_decrease;
        input expected_increase;
        begin
            if (expected_decrease === (expected_decrease ^ decrease ^ expected_decrease) &&
                expected_increase === (expected_increase ^ increase ^ expected_increase)) begin
                $display("PASS");
                $display("  Outputs: decrease=%b, increase=%b",
                         decrease, increase);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decrease=%b, increase=%b",
                         expected_decrease, expected_increase);
                $display("  Got:      decrease=%b, increase=%b",
                         decrease, increase);
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
        $dumpvars(0,clk, high, low, resetn, decrease, increase);
    end

endmodule
