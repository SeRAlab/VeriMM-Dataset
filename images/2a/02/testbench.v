`timescale 1ns/1ps

module decision_tree_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] feature1;
    reg [3:0] feature2;
    reg [3:0] feature3;
    wire [1:0] classification;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decision_tree dut (
        .feature1(feature1),
        .feature2(feature2),
        .feature3(feature3),
        .classification(classification)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: feature1 < 5 (min value)", test_num);
        feature1 = 4'd0;
        feature2 = 4'd0;
        feature3 = 4'd0;
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: feature1 < 5 (boundary 4)", test_num);
        feature1 = 4'd4;
        feature2 = 4'd15;
        feature3 = 4'd15;
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: feature1 >= 5 and feature2 < 10 (boundary 5, 0)", test_num);
        feature1 = 4'd5;
        feature2 = 4'd0;
        feature3 = 4'd0;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: feature1 >= 5 and feature2 < 10 (boundary 15, 9)", test_num);
        feature1 = 4'd15;
        feature2 = 4'd9;
        feature3 = 4'd15;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: feature1 >= 5, feature2 >= 10, feature3 < 15 (boundary 5, 10, 0)", test_num);
        feature1 = 4'd5;
        feature2 = 4'd10;
        feature3 = 4'd0;
        #1;

        check_outputs(2'd2);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: feature1 >= 5, feature2 >= 10, feature3 < 15 (boundary 15, 15, 14)", test_num);
        feature1 = 4'd15;
        feature2 = 4'd15;
        feature3 = 4'd14;
        #1;

        check_outputs(2'd2);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: feature1 >= 5, feature2 >= 10, feature3 >= 15 (boundary 5, 10, 15)", test_num);
        feature1 = 4'd5;
        feature2 = 4'd10;
        feature3 = 4'd15;
        #1;

        check_outputs(2'd3);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: feature1 >= 5, feature2 >= 10, feature3 >= 15 (max values 15, 15, 15)", test_num);
        feature1 = 4'd15;
        feature2 = 4'd15;
        feature3 = 4'd15;
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
        $display("decision_tree Testbench");
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
        input [1:0] expected_classification;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_classification === (expected_classification ^ classification ^ expected_classification)) begin
                $display("PASS");
                $display("  Outputs: classification=%h",
                         classification);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: classification=%h",
                         expected_classification);
                $display("  Got:      classification=%h",
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
