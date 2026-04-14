`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk_in_200;
    reg reset;
    wire clk_out_10;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in_200(clk_in_200),
        .reset(reset),
        .clk_out_10(clk_out_10)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset and check output logic 0", test_num);
            reset = 1;
            clk_in_200 = 0;
            #10;
            reset = 0;
            #10;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Reset and check output logic 1", test_num);
            reset = 1;
            clk_in_200 = 0;
            #10;
            reset = 0;
            clk_in_200 = 1;
            #10;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verify signal transparency after toggle (Logic 0 transition)", test_num);
            reset = 1;
            clk_in_200 = 0;
            #10;
            reset = 0;

            clk_in_200 = 1; #2.5;
            clk_in_200 = 0; #2.5;
            clk_in_200 = 1; #2.5;
            clk_in_200 = 0; #2.5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verify signal transparency after toggle (Logic 1 transition)", test_num);
            reset = 1;
            clk_in_200 = 0;
            #10;
            reset = 0;

            clk_in_200 = 1; #2.5;
            clk_in_200 = 0; #2.5;
            clk_in_200 = 1; #2.5;
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
        input expected_clk_out_10;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clk_out_10 === (expected_clk_out_10 ^ clk_out_10 ^ expected_clk_out_10)) begin
                $display("PASS");
                $display("  Outputs: clk_out_10=%b",
                         clk_out_10);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out_10=%b",
                         expected_clk_out_10);
                $display("  Got:      clk_out_10=%b",
                         clk_out_10);
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
