`timescale 1ns/1ps

module decision_tree_inference_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] feature1;
    reg [3:0] feature2;
    reg [3:0] feature3;
    wire [1:0] decision;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decision_tree_inference dut (
        .feature1(feature1),
        .feature2(feature2),
        .feature3(feature3),
        .decision(decision)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: feature1 >= 8 (High boundary)", test_num);
            feature1 = 4'd15;
            feature2 = 4'd0;
            feature3 = 4'd0;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: feature1 >= 8 (Low boundary)", test_num);
            feature1 = 4'd8;
            feature2 = 4'd15;
            feature3 = 4'd15;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: feature1 < 8 and feature2 >= 8 (High boundary)", test_num);
            feature1 = 4'd7;
            feature2 = 4'd15;
            feature3 = 4'd0;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: feature1 < 8 and feature2 >= 8 (Low boundary)", test_num);
            feature1 = 4'd0;
            feature2 = 4'd8;
            feature3 = 4'd15;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: feature1 < 8, feature2 < 8, feature3 >= 8 (High boundary)", test_num);
            feature1 = 4'd7;
            feature2 = 4'd7;
            feature3 = 4'd15;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: feature1 < 8, feature2 < 8, feature3 >= 8 (Low boundary)", test_num);
            feature1 = 4'd3;
            feature2 = 4'd2;
            feature3 = 4'd8;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All features < 8 (Boundary)", test_num);
            feature1 = 4'd7;
            feature2 = 4'd7;
            feature3 = 4'd7;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All features 0", test_num);
            feature1 = 4'd0;
            feature2 = 4'd0;
            feature3 = 4'd0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decision_tree_inference Testbench");
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
        input [1:0] expected_decision;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decision === (expected_decision ^ decision ^ expected_decision)) begin
                $display("PASS");
                $display("  Outputs: decision=%h",
                         decision);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decision=%h",
                         expected_decision);
                $display("  Got:      decision=%h",
                         decision);
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
