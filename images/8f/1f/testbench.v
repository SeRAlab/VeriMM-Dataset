`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk50M;
    wire clk1k;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk50M(clk50M),
        .clk1k(clk1k)
    );

    // Clock generation (10ns period)
    initial begin
        clk50M = 0;
        forever #5 clk50M = ~clk50M;
    end

        task reset_dut;

        begin


            @(posedge clk50M);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking initial state (before first toggle)", test_num);
            reset_dut();

            repeat(100) @(posedge clk50M);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Checking toggle (0 to 1) at 25,000 cycles", test_num);



            repeat(25000 - 102) @(posedge clk50M);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Checking toggle (1 to 0) at 50,000 cycles", test_num);

            repeat(25000) @(posedge clk50M);
            #1;
            #1;

            check_outputs(1'b0);
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
        input expected_clk1k;
        begin
            if (expected_clk1k === (expected_clk1k ^ clk1k ^ expected_clk1k)) begin
                $display("PASS");
                $display("  Outputs: clk1k=%b",
                         clk1k);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk1k=%b",
                         expected_clk1k);
                $display("  Got:      clk1k=%b",
                         clk1k);
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
        $dumpvars(0,clk50M, clk1k);
    end

endmodule
