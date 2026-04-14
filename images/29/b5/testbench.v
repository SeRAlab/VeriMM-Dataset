`timescale 1ns/1ps

module svm_classifier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] feature1;
    reg [7:0] feature2;
    reg [7:0] feature3;
    reg [7:0] feature4;
    reg [7:0] feature5;
    wire class_label;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    svm_classifier dut (
        .feature1(feature1),
        .feature2(feature2),
        .feature3(feature3),
        .feature4(feature4),
        .feature5(feature5),
        .class_label(class_label)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All features zero (Origin Point)", test_num);
        feature1 = 8'd0;
        feature2 = 8'd0;
        feature3 = 8'd0;
        feature4 = 8'd0;
        feature5 = 8'd0;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All features maximum value (255)", test_num);
        feature1 = 8'hFF;
        feature2 = 8'hFF;
        feature3 = 8'hFF;
        feature4 = 8'hFF;
        feature5 = 8'hFF;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mid-range values (128)", test_num);
        feature1 = 8'd128;
        feature2 = 8'd128;
        feature3 = 8'd128;
        feature4 = 8'd128;
        feature5 = 8'd128;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sparse features - Only Feature 1 high", test_num);
        feature1 = 8'd200;
        feature2 = 8'd0;
        feature3 = 8'd0;
        feature4 = 8'd0;
        feature5 = 8'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sparse features - Only Feature 5 high", test_num);
        feature1 = 8'd0;
        feature2 = 8'd0;
        feature3 = 8'd0;
        feature4 = 8'd0;
        feature5 = 8'd250;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Increasing feature values", test_num);
        feature1 = 8'd10;
        feature2 = 8'd50;
        feature3 = 8'd100;
        feature4 = 8'd150;
        feature5 = 8'd200;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating High/Low values", test_num);
        feature1 = 8'hFF;
        feature2 = 8'h00;
        feature3 = 8'hFF;
        feature4 = 8'h00;
        feature5 = 8'hFF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Values near lower boundary", test_num);
        feature1 = 8'd5;
        feature2 = 8'd10;
        feature3 = 8'd5;
        feature4 = 8'd10;
        feature5 = 8'd5;
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
