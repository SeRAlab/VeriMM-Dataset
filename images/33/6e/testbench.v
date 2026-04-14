`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] b;
    reg [7:0] x1;
    reg [7:0] x2;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_regression dut (
        .b(b),
        .x1(x1),
        .x2(x2),
        .y(y)
    );
    task run_test;

        input signed [7:0] in_x1;
        input signed [7:0] in_x2;
        input signed [7:0] in_b;
        reg signed [15:0] expected_y;
        begin
            x1 = in_x1;
            x2 = in_x2;
            b  = in_b;
            expected_y = (W1 * $signed(in_x1)) + (W2 * $signed(in_x2)) + $signed(in_b);
            #1;

            check_outputs(expected_y);
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: All Zeros");
            test_num = 1;
            run_test(8'sd0, 8'sd0, 8'sd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Small Positive Values");
            test_num = 2;
            run_test(8'sd10, 8'sd5, 8'sd2);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Small Negative Values");
            test_num = 3;
            run_test(-8'sd10, -8'sd5, -8'sd2);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Mixed Positive and Negative");
            test_num = 4;
            run_test(8'sd50, -8'sd20, 8'sd10);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Maximum Positive Inputs");
            test_num = 5;
            run_test(8'sd127, 8'sd127, 8'sd127);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Minimum Negative Inputs");
            test_num = 6;
            run_test(-8'sd128, -8'sd128, -8'sd128);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Single Feature Active (x1)");
            test_num = 7;
            run_test(8'sd64, 8'sd0, 8'sd0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Single Feature Active (x2)");
            test_num = 8;
            run_test(8'sd0, 8'sd64, 8'sd0);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Bias Only");
            test_num = 9;
            run_test(8'sd0, 8'sd0, -8'sd100);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Large Magnitude Mixed Signs");
            test_num = 10;
            run_test(-8'sd100, 8'sd80, -8'sd50);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linear_regression Testbench");
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
        testcase010();
        
        
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
        input [15:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
