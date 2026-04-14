`timescale 1ns/1ps

module KNN_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] feature_vector;
    reg [4:0] labels;
    reg [9:0] training_data;
    wire [3:0] predicted_class;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    KNN dut (
        .feature_vector(feature_vector),
        .labels(labels),
        .training_data(training_data),
        .predicted_class(predicted_class)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Exact matches for class 1", test_num);



            feature_vector = 2'd1;
            training_data = {2'd3, 2'd2, 2'd1, 2'd1, 2'd1};
            labels = 5'b00111;
            #10;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Majority vote for class 0 with distal outliers", test_num);



            feature_vector = 2'd3;
            training_data = {2'd0, 2'd0, 2'd3, 2'd3, 2'd3};
            labels = 5'b11000;
            #10;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed distances (K=3 logic check)", test_num);




            feature_vector = 2'd2;
            training_data = {2'd0, 2'd0, 2'd3, 2'd1, 2'd2};
            labels = 5'b11001;
            #10;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Uniform labels", test_num);

            feature_vector = 2'd0;
            training_data = {2'd3, 2'd3, 2'd2, 2'd1, 2'd0};
            labels = 5'b11111;
            #10;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Closest neighbors at maximum distance", test_num);



            feature_vector = 2'd3;
            training_data = {2'd1, 2'd1, 2'd0, 2'd0, 2'd0};
            labels = 5'b11000;
            #10;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Edge case with identical training data but different labels", test_num);



            feature_vector = 2'd2;
            training_data = {2'd2, 2'd2, 2'd2, 2'd2, 2'd2};
            labels = 5'b01010;
            #10;
            #1;

            check_outputs(4'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("KNN Testbench");
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
        input [3:0] expected_predicted_class;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_predicted_class === (expected_predicted_class ^ predicted_class ^ expected_predicted_class)) begin
                $display("PASS");
                $display("  Outputs: predicted_class=%h",
                         predicted_class);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: predicted_class=%h",
                         expected_predicted_class);
                $display("  Got:      predicted_class=%h",
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
