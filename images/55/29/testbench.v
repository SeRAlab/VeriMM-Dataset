`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Verify initial clock state");

            #0.1;



            #1;




            check_outputs(clk);
        end
        endtask

    task testcase002;

        reg last_val;
        begin
            test_num = 2;
            $display("Testcase 002: Verify first edge transition");
            last_val = clk;

            @(clk);

            #1;


            check_outputs(~last_val);
        end
        endtask

    task testcase003;

        reg last_val;
        begin
            test_num = 3;
            $display("Testcase 003: Verify second edge transition (Full half-cycle)");
            last_val = clk;

            @(clk);

            #1;


            check_outputs(~last_val);
        end
        endtask

    task testcase004;

        integer i;
        reg last_val;
        begin
            test_num = 4;
            $display("Testcase 004: Verify continuous oscillation (Multiple cycles)");
            for (i = 0; i < 4; i = i + 1) begin
                last_val = clk;
                @(clk);
            end

            #1;


            check_outputs(clk);
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
        input expected_clk;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clk === (expected_clk ^ clk ^ expected_clk)) begin
                $display("PASS");
                $display("  Outputs: clk=%b",
                         clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk=%b",
                         expected_clk);
                $display("  Got:      clk=%b",
                         clk);
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
