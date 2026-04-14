`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clken;
    wire gated_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clken(clken),
        .gated_clk(gated_clk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting circuit...");
            clken = 0;

            @(negedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Clock Enable Active");
            reset_dut();
            test_num = 1;

            clken = 1;

            @(negedge clk);

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Clock Enable Inactive");
            reset_dut();
            test_num = 2;

            clken = 0;
            @(negedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Glitch Protection (clken change during clk high)");
            reset_dut();
            test_num = 3;


            clken = 1;
            @(negedge clk);


            @(posedge clk);
            #2;


            clken = 0;
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Glitch Protection (clken change after negedge)");
            reset_dut();
            test_num = 4;

            clken = 0;
            @(negedge clk);
            #2;

            clken = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Continuous Active Clock");
            reset_dut();
            test_num = 5;

            clken = 1;
            @(negedge clk);

            repeat(3) @(posedge clk);
            #2;
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
        input expected_gated_clk;
        begin
            if (expected_gated_clk === (expected_gated_clk ^ gated_clk ^ expected_gated_clk)) begin
                $display("PASS");
                $display("  Outputs: gated_clk=%b",
                         gated_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gated_clk=%b",
                         expected_gated_clk);
                $display("  Got:      gated_clk=%b",
                         gated_clk);
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
        $dumpvars(0,clk, clken, gated_clk);
    end

endmodule
