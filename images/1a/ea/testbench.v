`timescale 1ns/1ps

module svm_classifier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] feature1;
    reg [7:0] feature2;
    wire classification;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    svm_classifier dut (
        .feature1(feature1),
        .feature2(feature2),
        .classification(classification)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Origin - Inputs (0, 0). 5(0) - 3(0) + 2 = 2 (Positive)", test_num);
        feature1 = 8'd0;
        feature2 = 8'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Clear Negative - Inputs (10, 20). 5(10) - 3(20) + 2 = -8 (Negative)", test_num);
        feature1 = 8'd10;
        feature2 = 8'd20;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Boundary Zero - Inputs (2, 4). 5(2) - 3(4) + 2 = 0 (Boundary Positive)", test_num);
        feature1 = 8'd2;
        feature2 = 8'd4;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Near Boundary Negative - Inputs (1, 4). 5(1) - 3(4) + 2 = -5 (Negative)", test_num);
        feature1 = 8'd1;
        feature2 = 8'd4;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Max Range Positive - Inputs (255, 0). 5(255) - 0 + 2 = 1277 (Positive)", test_num);
        feature1 = 8'd255;
        feature2 = 8'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Max Range Negative - Inputs (0, 255). 0 - 3(255) + 2 = -763 (Negative)", test_num);
        feature1 = 8'd0;
        feature2 = 8'd255;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Max Both - Inputs (255, 255). 5(255) - 3(255) + 2 = 512 (Positive)", test_num);
        feature1 = 8'd255;
        feature2 = 8'd255;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Another Boundary - Inputs (20, 34). 5(20) - 3(34) + 2 = 0 (Boundary Positive)", test_num);
        feature1 = 8'd20;
        feature2 = 8'd34;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Near Boundary Positive - Inputs (2, 3). 5(2) - 3(3) + 2 = 3 (Positive)", test_num);
        feature1 = 8'd2;
        feature2 = 8'd3;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Inputs (100, 168). 500 - 504 + 2 = -2 (Negative)", test_num);
        feature1 = 8'd100;
        feature2 = 8'd168;
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
        input expected_classification;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_classification === (expected_classification ^ classification ^ expected_classification)) begin
                $display("PASS");
                $display("  Outputs: classification=%b",
                         classification);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: classification=%b",
                         expected_classification);
                $display("  Got:      classification=%b",
                         classification);
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
