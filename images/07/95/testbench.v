`timescale 1ns/1ps

module svm_classifier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] feature1;
    reg [7:0] feature2;
    wire class_label;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    svm_classifier dut (
        .feature1(feature1),
        .feature2(feature2),
        .class_label(class_label)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Minimal input (0,0)");
            feature1 = 8'd0;
            feature2 = 8'd0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Just below threshold (6,0)");
            feature1 = 8'd6;
            feature2 = 8'd0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Just below threshold (3,2)");
            feature1 = 8'd3;
            feature2 = 8'd2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Exactly at threshold (0,4)");
            feature1 = 8'd0;
            feature2 = 8'd4;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Exactly at threshold (5,1)");
            feature1 = 8'd5;
            feature2 = 8'd1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Just above threshold (7,0)");
            feature1 = 8'd7;
            feature2 = 8'd0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: Just above threshold (4,2)");
            feature1 = 8'd4;
            feature2 = 8'd2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case 008: Maximum inputs (255, 255)");
            feature1 = 8'd255;
            feature2 = 8'd255;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case 009: Moderate values (10, 0)");
            feature1 = 8'd10;
            feature2 = 8'd0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case 010: Boundary check (1, 3)");
            feature1 = 8'd1;
            feature2 = 8'd3;

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
        $display("svm_classifier Testbench");
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
        input expected_class_label;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_class_label === (expected_class_label ^ class_label ^ expected_class_label)) begin
                $display("PASS");
                $display("  Outputs: class_label=%b",
                         class_label);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: class_label=%b",
                         expected_class_label);
                $display("  Got:      class_label=%b",
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
