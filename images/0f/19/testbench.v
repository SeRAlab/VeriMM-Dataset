`timescale 1ns/1ps

module logistic_regression_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] feature1;
    reg [3:0] feature2;
    wire class_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    logistic_regression dut (
        .feature1(feature1),
        .feature2(feature2),
        .class_out(class_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Minimum Inputs (0, 0)");
            feature1 = 4'b0000;
            feature2 = 4'b0000;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Maximum Inputs (15, 15)");
            feature1 = 4'b1111;
            feature2 = 4'b1111;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Feature 1 Max, Feature 2 Min (15, 0)");
            feature1 = 4'b1111;
            feature2 = 4'b0000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Feature 1 Min, Feature 2 Max (0, 15)");
            feature1 = 4'b0000;
            feature2 = 4'b1111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Mid-range Values (8, 8)");
            feature1 = 4'd8;
            feature2 = 4'd8;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Small Values (1, 1)");
            feature1 = 4'd1;
            feature2 = 4'd1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Pattern 1010 and 0101");
            feature1 = 4'b1010;
            feature2 = 4'b0101;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Low boundary (2, 2)");
            feature1 = 4'd2;
            feature2 = 4'd2;
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
        $display("logistic_regression Testbench");
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
        input expected_class_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_class_out === (expected_class_out ^ class_out ^ expected_class_out)) begin
                $display("PASS");
                $display("  Outputs: class_out=%b",
                         class_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: class_out=%b",
                         expected_class_out);
                $display("  Got:      class_out=%b",
                         class_out);
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
