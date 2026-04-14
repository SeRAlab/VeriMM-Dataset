`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Net_53;
    reg Net_55;
    wire clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Net_53(Net_53),
        .Net_55(Net_55),
        .clk(clk)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Neither input active (Net_53=0, Net_55=0)", test_num);
            Net_53 = 1'b0;
            Net_55 = 1'b0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Net_53 active (Net_53=1, Net_55=0)", test_num);
            Net_53 = 1'b1;
            Net_55 = 1'b0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Net_55 active (Net_53=0, Net_55=1)", test_num);
            Net_53 = 1'b0;
            Net_55 = 1'b1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Both inputs active (Net_53=1, Net_55=1)", test_num);
            Net_53 = 1'b1;
            Net_55 = 1'b1;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Transition from Net_53 high to Net_55 high", test_num);
            Net_53 = 1'b1;
            Net_55 = 1'b0;
            #5;
            Net_53 = 1'b0;
            Net_55 = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Transition from Net_55 high back to neither active", test_num);
            Net_53 = 1'b0;
            Net_55 = 1'b1;
            #5;
            Net_55 = 1'b0;
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
