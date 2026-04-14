`timescale 1ns/1ps

module logistic_regression_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] feature1;
    reg [7:0] feature2;
    wire predicted_class;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    logistic_regression dut (
        .feature1(feature1),
        .feature2(feature2),
        .predicted_class(predicted_class)
    );
    task testcase001;

    begin
        test_num = 1;
        feature1 = 8'd0;
        feature2 = 8'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        feature1 = 8'd255;
        feature2 = 8'd255;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        feature1 = 8'd127;
        feature2 = 8'd127;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        feature1 = 8'd128;
        feature2 = 8'd127;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        feature1 = 8'd255;
        feature2 = 8'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        feature1 = 8'd0;
        feature2 = 8'd254;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        feature1 = 8'd100;
        feature2 = 8'd154;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        feature1 = 8'd100;
        feature2 = 8'd155;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        feature1 = 8'd10;
        feature2 = 8'd10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        feature1 = 8'd200;
        feature2 = 8'd200;
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
