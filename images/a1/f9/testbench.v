`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg x1;
    reg x2;
    reg x3;
    wire y1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .y1(y1)
    );
    task testcase001;

        begin
            $display("\nTest Case 001: All zeros (x1=0, x2=0, x3=0)");
            x1 = 0; x2 = 0; x3 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTest Case 002: (x1=0, x2=0, x3=1)");
            x1 = 0; x2 = 0; x3 = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            $display("\nTest Case 003: (x1=0, x2=1, x3=0)");
            x1 = 0; x2 = 1; x3 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            $display("\nTest Case 004: (x1=0, x2=1, x3=1)");
            x1 = 0; x2 = 1; x3 = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            $display("\nTest Case 005: (x1=1, x2=0, x3=0)");
            x1 = 1; x2 = 0; x3 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            $display("\nTest Case 006: (x1=1, x2=0, x3=1)");
            x1 = 1; x2 = 0; x3 = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            $display("\nTest Case 007: (x1=1, x2=1, x3=0)");
            x1 = 1; x2 = 1; x3 = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            $display("\nTest Case 008: All ones (x1=1, x2=1, x3=1)");
            x1 = 1; x2 = 1; x3 = 1;
            #1;

            check_outputs(1);
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
        testcase007();
        testcase008();
        
        
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
        input expected_y1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y1 === (expected_y1 ^ y1 ^ expected_y1)) begin
                $display("PASS");
                $display("  Outputs: y1=%b",
                         y1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y1=%b",
                         expected_y1);
                $display("  Got:      y1=%b",
                         y1);
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
