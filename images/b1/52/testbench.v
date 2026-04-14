`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_50mhz;
    wire clk_1khz;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_50mhz(clk_50mhz),
        .clk_1khz(clk_1khz)
    );

    // Clock generation (10ns period)
    initial begin
        clk_50mhz = 0;
        forever #5 clk_50mhz = ~clk_50mhz;
    end

        task reset_dut;

        begin
            $display("--- Resetting/Initializing ---");


            repeat(10) @(posedge clk_50mhz);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking initial state", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking toggle after half-period (25,000 cycles)", test_num);
            reset_dut();


            repeat(25000) @(posedge clk_50mhz);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking toggle after full-period (50,000 cycles total)", test_num);
            reset_dut();

            repeat(25000) @(posedge clk_50mhz);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking third toggle point (75,000 cycles total)", test_num);
            reset_dut();


            repeat(25000) @(posedge clk_50mhz);
            #1;
            #1;

            check_outputs(1'b1);
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
        input expected_clk_1khz;
        begin
            if (expected_clk_1khz === (expected_clk_1khz ^ clk_1khz ^ expected_clk_1khz)) begin
                $display("PASS");
                $display("  Outputs: clk_1khz=%b",
                         clk_1khz);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_1khz=%b",
                         expected_clk_1khz);
                $display("  Got:      clk_1khz=%b",
                         clk_1khz);
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
        $dumpvars(0,clk_50mhz, clk_1khz);
    end

endmodule
