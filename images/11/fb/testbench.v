`timescale 1ns/1ps

module KNN_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] input_point;
    reg [4:0] training_classes;
    reg [39:0] training_points;
    wire [1:0] predicted_class;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    KNN dut (
        .input_point(input_point),
        .training_classes(training_classes),
        .training_points(training_points),
        .predicted_class(predicted_class)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Exact match and close neighbors (Majority Class 1)", test_num);


            training_points = {8'd100, 8'd101, 8'd12, 8'd11, 8'd10};
            training_classes = 5'b00111;
            input_point = 8'd10;


            #1;



            check_outputs(2'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Points surrounding input (Majority Class 0)", test_num);


            training_points = {8'd100, 8'd60, 8'd55, 8'd45, 8'd10};
            training_classes = 5'b10001;
            input_point = 8'd50;


            #1;



            check_outputs(2'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed neighbors (Majority Class 1)", test_num);


            training_points = {8'd80, 8'd5, 8'd25, 8'd22, 8'd18};
            training_classes = 5'b10101;
            input_point = 8'd20;


            #1;



            check_outputs(2'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High value range (Majority Class 0)", test_num);


            training_points = {8'd190, 8'd210, 8'd205, 8'd10, 8'd20};
            training_classes = 5'b00111;
            input_point = 8'd200;


            #1;



            check_outputs(2'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Edge case near zero (Majority Class 0)", test_num);


            training_points = {8'd1, 8'd2, 8'd5, 8'd250, 8'd255};
            training_classes = 5'b00011;
            input_point = 8'd0;


            #1;



            check_outputs(2'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All same class (Majority Class 1)", test_num);
            training_points = {8'd200, 8'd150, 8'd100, 8'd50, 8'd10};
            training_classes = 5'b11111;
            input_point = 8'd120;


            #1;



            check_outputs(2'd1);
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
        input [1:0] expected_predicted_class;
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
