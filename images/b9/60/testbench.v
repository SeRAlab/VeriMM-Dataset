`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg d;
    reg [3:0] y;
    wire Y1;
    wire Y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .y(y),
        .Y1(Y1),
        .Y3(Y3)
    );
    task testcase001;

        begin
            $display("Test Case 001: State E, d=1");
            test_num = 1;
            y = 4'b0001;
            d = 1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: State E, d=0");
            test_num = 2;
            y = 4'b0001;
            d = 0;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: State F, d=1");
            test_num = 3;
            y = 4'b0010;
            d = 1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: State F, d=0");
            test_num = 4;
            y = 4'b0010;
            d = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: State G, d=1");
            test_num = 5;
            y = 4'b0100;
            d = 1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: State G, d=0");
            test_num = 6;
            y = 4'b0100;
            d = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: State H, d=1");
            test_num = 7;
            y = 4'b1000;
            d = 1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: State H, d=0");
            test_num = 8;
            y = 4'b1000;
            d = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: No state active");
            test_num = 9;
            y = 4'b0000;
            d = 1;
            #1;

            check_outputs(0, 0);
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
        testcase009();
        
        
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
        input expected_Y1;
        input expected_Y3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y1 === (expected_Y1 ^ Y1 ^ expected_Y1) &&
                expected_Y3 === (expected_Y3 ^ Y3 ^ expected_Y3)) begin
                $display("PASS");
                $display("  Outputs: Y1=%b, Y3=%b",
                         Y1, Y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y1=%b, Y3=%b",
                         expected_Y1, expected_Y3);
                $display("  Got:      Y1=%b, Y3=%b",
                         Y1, Y3);
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
