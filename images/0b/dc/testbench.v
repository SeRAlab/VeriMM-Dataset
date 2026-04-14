`timescale 1ns/1ps

module svm_classifier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] feature1;
    reg [7:0] feature2;
    wire class_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    svm_classifier dut (
        .feature1(feature1),
        .feature2(feature2),
        .class_output(class_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both features positive", test_num);
            feature1 = 8'd10;
            feature2 = 8'd20;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both features negative", test_num);
            feature1 = -8'd15;
            feature2 = -8'd5;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero input boundary", test_num);
            feature1 = 8'd0;
            feature2 = 8'd0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed signs, positive result", test_num);
            feature1 = 8'd50;
            feature2 = -8'd20;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed signs, negative result", test_num);
            feature1 = -8'd100;
            feature2 = 8'd30;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum positive values", test_num);
            feature1 = 8'sb01111111;
            feature2 = 8'sb01111111;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum negative values", test_num);
            feature1 = 8'sb10000000;
            feature2 = 8'sb10000000;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Result exactly -1 (close to boundary)", test_num);
            feature1 = -8'd1;
            feature2 = 8'd0;

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
        input expected_class_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_class_output === (expected_class_output ^ class_output ^ expected_class_output)) begin
                $display("PASS");
                $display("  Outputs: class_output=%b",
                         class_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: class_output=%b",
                         expected_class_output);
                $display("  Got:      class_output=%b",
                         class_output);
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
