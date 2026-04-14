`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg nIn;
    wire [27:0] ssOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .nIn(nIn),
        .ssOut(ssOut)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: nIn = 0", test_num);
            nIn = 1'b0;
            #10;


            #1;



            check_outputs(28'h3f3f3f3f);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: nIn = 1", test_num);
            nIn = 1'b1;
            #10;


            #1;



            check_outputs(28'h06060606);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: nIn = X (Undefined)", test_num);
            nIn = 1'bx;
            #10;


            #1;



            check_outputs(28'h0000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: nIn = Z (Undefined)", test_num);
            nIn = 1'bz;
            #10;
            #1;

            check_outputs(28'h0000000);
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
        input [27:0] expected_ssOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ssOut === (expected_ssOut ^ ssOut ^ expected_ssOut)) begin
                $display("PASS");
                $display("  Outputs: ssOut=%h",
                         ssOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ssOut=%h",
                         expected_ssOut);
                $display("  Got:      ssOut=%h",
                         ssOut);
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
