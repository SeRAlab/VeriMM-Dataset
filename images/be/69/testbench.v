`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg txp;
    wire ref_clk;
    wire rxp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .txp(txp),
        .ref_clk(ref_clk),
        .rxp(rxp)
    );
    task testcase001;

        begin
            test_num = 1;

            txp = 1'b0;
            #1;


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            txp = 1'b1;

            #3;


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            txp = 1'b0;

            #3;


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            txp = 1'b1;

            #3;


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            txp = 1'b0;

            #3;


            #1;



            check_outputs(1'b0, 1'b0);
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
        input expected_ref_clk;
        input expected_rxp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ref_clk === (expected_ref_clk ^ ref_clk ^ expected_ref_clk) &&
                expected_rxp === (expected_rxp ^ rxp ^ expected_rxp)) begin
                $display("PASS");
                $display("  Outputs: ref_clk=%b, rxp=%b",
                         ref_clk, rxp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ref_clk=%b, rxp=%b",
                         expected_ref_clk, expected_rxp);
                $display("  Got:      ref_clk=%b, rxp=%b",
                         ref_clk, rxp);
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
