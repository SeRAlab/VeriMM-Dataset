`timescale 1ns/1ps

module decision_tree_inference_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] input1;
    reg [3:0] input2;
    wire class_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decision_tree_inference dut (
        .input1(input1),
        .input2(input2),
        .class_output(class_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: input1=6, input2=0 (Expect Class A)", test_num);
            input1 = 4'd6;
            input2 = 4'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: input1=15, input2=15 (Expect Class A)", test_num);
            input1 = 4'd15;
            input2 = 4'd15;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: input1=5, input2=4 (Expect Class A)", test_num);
            input1 = 4'd5;
            input2 = 4'd4;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: input1=0, input2=10 (Expect Class A)", test_num);
            input1 = 4'd0;
            input2 = 4'd10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: input1=5, input2=3 (Expect Class B)", test_num);
            input1 = 4'd5;
            input2 = 4'd3;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: input1=0, input2=0 (Expect Class B)", test_num);
            input1 = 4'd0;
            input2 = 4'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: input1=3, input2=2 (Expect Class B)", test_num);
            input1 = 4'd3;
            input2 = 4'd2;
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
        $display("decision_tree_inference Testbench");
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
