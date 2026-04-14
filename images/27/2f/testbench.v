`timescale 1ns/1ps

module svm_classifier_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] features;
    wire classification;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    svm_classifier dut (
        .features(features),
        .classification(classification)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Features = 00000 (Minimum Input)", test_num);
        features = 5'b00000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Features = 11111 (Maximum Input)", test_num);
        features = 5'b11111;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Features = 10101 (Sparse High Weights)", test_num);
        features = 5'b10101;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Features = 00010 (Single Low Feature)", test_num);
        features = 5'b00010;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Features = 10000 (MSB Heavy)", test_num);
        features = 5'b10000;
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
        $display("svm_classifier Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
