`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg enable;
    wire clk_gated;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .clk_gated(clk_gated)
    );
    task testcase001;

        begin
            test_num = 1;

            clk = 0; enable = 1; #10;

            clk = 1; #5;
            #1;

            check_outputs(1);
            #5; clk = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;

            clk = 0; enable = 0; #10;

            clk = 1; #5;
            #1;

            check_outputs(0);
            #5; clk = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;

            clk = 0; enable = 0; #10;

            clk = 1; #5;

            enable = 1; #5;

            #1;


            check_outputs(0);
            #5; clk = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;

            clk = 0; enable = 1; #10;

            clk = 1; #5;

            enable = 0; #5;

            #1;


            check_outputs(1);
            #5; clk = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;

            clk = 0; enable = 1; #10;

            clk = 1; #10;

            clk = 0; #5;
            #1;

            check_outputs(0);
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
        input expected_clk_gated;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clk_gated === (expected_clk_gated ^ clk_gated ^ expected_clk_gated)) begin
                $display("PASS");
                $display("  Outputs: clk_gated=%b",
                         clk_gated);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_gated=%b",
                         expected_clk_gated);
                $display("  Got:      clk_gated=%b",
                         clk_gated);
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

endmodule
