`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire clk;
    wire clk_bar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_bar(clk_bar)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking complementary property", test_num);
            #10;

            #1;


            check_outputs(clk, !clk);
        end
        endtask

    task testcase002;

        reg initial_state;
        begin
            test_num = 2;
            $display("Testcase %03d: Verifying oscillation (state toggle)", test_num);

            initial_state = clk;

            @(edge clk);
            #0.1;


            #1;



            check_outputs(!initial_state, initial_state);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Checking complementary property after multiple cycles", test_num);

            #100;


            #1;



            check_outputs(clk, !clk);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Spot check clk_bar logic", test_num);

            #25;

            if (clk ^ clk_bar === 1'b1) begin
                #1;

                check_outputs(clk, !clk);
            end else begin

                #1;


                check_outputs(clk, clk);
            end
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
        input expected_clk_bar;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clk === (expected_clk ^ clk ^ expected_clk) &&
                expected_clk_bar === (expected_clk_bar ^ clk_bar ^ expected_clk_bar)) begin
                $display("PASS");
                $display("  Outputs: clk=%b, clk_bar=%b",
                         clk, clk_bar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk=%b, clk_bar=%b",
                         expected_clk, expected_clk_bar);
                $display("  Got:      clk=%b, clk_bar=%b",
                         clk, clk_bar);
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
