`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clkcnt_reset;
    wire div_500k;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clkcnt_reset(clkcnt_reset),
        .div_500k(div_500k)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clkcnt_reset = 0;
            repeat(2) @(posedge clk);
            #1 clkcnt_reset = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Checking initial state (Count 0) after reset", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk); #1;
            $display("Test %0d: Checking state at first half (Count 1)", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            repeat(2) @(posedge clk); #1;
            $display("Test %0d: Checking state at second half start (Count 2)", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            repeat(3) @(posedge clk); #1;
            $display("Test %0d: Checking state during second half (Count 3)", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            repeat(4) @(posedge clk); #1;
            $display("Test %0d: Checking wrap-around back to first half (Count 0/4)", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            repeat(2) @(posedge clk); #1;
            clkcnt_reset = 0;
            #10;
            $display("Test %0d: Verifying output resets to low when clkcnt_reset is asserted", test_num);
            #1;

            check_outputs(0);
            clkcnt_reset = 1;
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
        input expected_div_500k;
        begin
            if (expected_div_500k === (expected_div_500k ^ div_500k ^ expected_div_500k)) begin
                $display("PASS");
                $display("  Outputs: div_500k=%b",
                         div_500k);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: div_500k=%b",
                         expected_div_500k);
                $display("  Got:      div_500k=%b",
                         div_500k);
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
        $dumpvars(0,clk, clkcnt_reset, div_500k);
    end

endmodule
