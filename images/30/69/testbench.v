`timescale 1ns/1ps

module logistic_regression_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] feature1;
    reg [3:0] feature2;
    reg [3:0] feature3;
    wire predicted_class;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    logistic_regression dut (
        .feature1(feature1),
        .feature2(feature2),
        .feature3(feature3),
        .predicted_class(predicted_class)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum inputs (All Zeros)", test_num);
            feature1 = 4'd0;
            feature2 = 4'd0;
            feature3 = 4'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum inputs (All Max)", test_num);
            feature1 = 4'd15;
            feature2 = 4'd15;
            feature3 = 4'd15;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Low activity features", test_num);
            feature1 = 4'd1;
            feature2 = 4'd2;
            feature3 = 4'd1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High activity features", test_num);
            feature1 = 4'd12;
            feature2 = 4'd14;
            feature3 = 4'd13;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single dominant feature", test_num);
            feature1 = 4'd15;
            feature2 = 4'd0;
            feature3 = 4'd0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range balance", test_num);
            feature1 = 4'd8;
            feature2 = 4'd7;
            feature3 = 4'd8;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Below threshold mixture", test_num);
            feature1 = 4'd4;
            feature2 = 4'd5;
            feature3 = 4'd3;
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
        input expected_predicted_class;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_predicted_class === (expected_predicted_class ^ predicted_class ^ expected_predicted_class)) begin
                $display("PASS");
                $display("  Outputs: predicted_class=%b",
                         predicted_class);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: predicted_class=%b",
                         expected_predicted_class);
                $display("  Got:      predicted_class=%b",
                         predicted_class);
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
