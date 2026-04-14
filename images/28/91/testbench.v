`timescale 1ns/1ps

module logistic_regression_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] feature1;
    reg [7:0] feature2;
    reg [7:0] weight1;
    reg [7:0] weight2;
    wire result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    logistic_regression dut (
        .feature1(feature1),
        .feature2(feature2),
        .weight1(weight1),
        .weight2(weight2),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: All inputs and weights are zero");
            feature1 = 8'd0;
            weight1  = 8'd0;
            feature2 = 8'd0;
            weight2  = 8'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Single feature and weight active");
            feature1 = 8'd10;
            weight1  = 8'd5;
            feature2 = 8'd0;
            weight2  = 8'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Both features and weights active");
            feature1 = 8'd2;
            weight1  = 8'd3;
            feature2 = 8'd4;
            weight2  = 8'd5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Maximum features but zero weights");
            feature1 = 8'hFF;
            weight1  = 8'd0;
            feature2 = 8'hFF;
            weight2  = 8'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Maximum features and weights");
            feature1 = 8'd255;
            weight1  = 8'd255;
            feature2 = 8'd255;
            weight2  = 8'd255;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Minimum non-zero inputs");
            feature1 = 8'd1;
            weight1  = 8'd1;
            feature2 = 8'd1;
            weight2  = 8'd1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Feature 2 only");
            feature1 = 8'd0;
            weight1  = 8'd10;
            feature2 = 8'd10;
            weight2  = 8'd2;
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
        $display("logistic_regression Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%b",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%b",
                         expected_result);
                $display("  Got:      result=%b",
                         result);
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
