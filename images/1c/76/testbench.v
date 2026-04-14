`timescale 1ns/1ps

module knn_classifier_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] K;
    reg [1:0] labelA;
    reg [1:0] labelB;
    reg [1:0] labelC;
    reg [3:0] pointA_x;
    reg [3:0] pointA_y;
    reg [3:0] pointB_x;
    reg [3:0] pointB_y;
    reg [3:0] pointC_x;
    reg [3:0] pointC_y;
    reg [3:0] test_x;
    reg [3:0] test_y;
    wire [1:0] class_label;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    knn_classifier dut (
        .K(K),
        .labelA(labelA),
        .labelB(labelB),
        .labelC(labelC),
        .pointA_x(pointA_x),
        .pointA_y(pointA_y),
        .pointB_x(pointB_x),
        .pointB_y(pointB_y),
        .pointC_x(pointC_x),
        .pointC_y(pointC_y),
        .test_x(test_x),
        .test_y(test_y),
        .class_label(class_label)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: K=1, Nearest Point is A", test_num);
            K = 2'd1;
            labelA = 2'd1; labelB = 2'd2; labelC = 2'd3;
            pointA_x = 4'd2; pointA_y = 4'd2;
            pointB_x = 4'd8; pointB_y = 4'd8;
            pointC_x = 4'd12; pointC_y = 4'd12;
            test_x = 4'd3; test_y = 4'd3;


            #1;



            check_outputs(2'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: K=1, Nearest Point is B", test_num);
            K = 2'd1;
            labelA = 2'd0; labelB = 2'd3; labelC = 2'd1;
            pointA_x = 4'd0; pointA_y = 4'd0;
            pointB_x = 4'd5; pointB_y = 4'd5;
            pointC_x = 4'd10; pointC_y = 4'd10;
            test_x = 4'd6; test_y = 4'd6;


            #1;



            check_outputs(2'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: K=1, Nearest Point is C", test_num);
            K = 2'd1;
            labelA = 2'd2; labelB = 2'd2; labelC = 2'd0;
            pointA_x = 4'd1; pointA_y = 4'd1;
            pointB_x = 4'd2; pointB_y = 4'd2;
            pointC_x = 4'd14; pointC_y = 4'd14;
            test_x = 4'd15; test_y = 4'd15;


            #1;



            check_outputs(2'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: K=3, Majority Vote (A=1, B=1, C=2)", test_num);
            K = 2'd3;
            labelA = 2'd1; labelB = 2'd1; labelC = 2'd2;
            pointA_x = 4'd1; pointA_y = 4'd1;
            pointB_x = 4'd2; pointB_y = 4'd2;
            pointC_x = 4'd3; pointC_y = 4'd3;
            test_x = 4'd2; test_y = 4'd2;


            #1;



            check_outputs(2'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: K=3, Majority Vote (A=0, B=3, C=3)", test_num);
            K = 2'd3;
            labelA = 2'd0; labelB = 2'd3; labelC = 2'd3;
            pointA_x = 4'd15; pointA_y = 4'd0;
            pointB_x = 4'd0; pointB_y = 4'd15;
            pointC_x = 4'd15; pointC_y = 4'd15;
            test_x = 4'd8; test_y = 4'd8;


            #1;



            check_outputs(2'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: K=3, Majority Vote (A=2, B=1, C=2)", test_num);
            K = 2'd3;
            labelA = 2'd2; labelB = 2'd1; labelC = 2'd2;
            pointA_x = 4'd4; pointA_y = 4'd4;
            pointB_x = 4'd5; pointB_y = 4'd5;
            pointC_x = 4'd6; pointC_y = 4'd6;
            test_x = 4'd5; test_y = 4'd5;


            #1;



            check_outputs(2'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Origin boundary check", test_num);
            K = 2'd1;
            labelA = 2'd3; labelB = 2'd0; labelC = 2'd0;
            pointA_x = 4'd0; pointA_y = 4'd0;
            pointB_x = 4'd15; pointB_y = 4'd15;
            pointC_x = 4'd15; pointC_y = 4'd0;
            test_x = 4'd0; test_y = 4'd1;


            #1;



            check_outputs(2'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("knn_classifier Testbench");
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
        input [1:0] expected_class_label;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_class_label === (expected_class_label ^ class_label ^ expected_class_label)) begin
                $display("PASS");
                $display("  Outputs: class_label=%h",
                         class_label);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: class_label=%h",
                         expected_class_label);
                $display("  Got:      class_label=%h",
                         class_label);
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
