`timescale 1ns/1ps

module backpropagation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] inputs;
    reg [7:0] learning_rate;
    reg [7:0] target;
    reg [7:0] weights;
    wire [7:0] new_weights;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    backpropagation dut (
        .inputs(inputs),
        .learning_rate(learning_rate),
        .target(target),
        .weights(weights),
        .new_weights(new_weights)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No Error (Target matches Prediction)", test_num);

            inputs = 8'd2;
            learning_rate = 8'd1;
            target = 8'd10;
            weights = 8'd5;
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive Error (Weight Increase)", test_num);


            inputs = 8'd2;
            learning_rate = 8'd1;
            target = 8'd10;
            weights = 8'd2;
            #1;

            check_outputs(8'd14);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative Error (Weight Decrease)", test_num);



            inputs = 8'd2;
            learning_rate = 8'd1;
            target = 8'd4;
            weights = 8'd10;
            #1;

            check_outputs(8'd234);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Learning Rate Effect", test_num);



            inputs = 8'd2;
            learning_rate = 8'd2;
            target = 8'd10;
            weights = 8'd2;
            #1;

            check_outputs(8'd26);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Learning Rate (No Update)", test_num);


            inputs = 8'd5;
            learning_rate = 8'd0;
            target = 8'd100;
            weights = 8'd5;
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Inputs (No Update)", test_num);

            inputs = 8'd0;
            learning_rate = 8'd5;
            target = 8'd20;
            weights = 8'd10;
            #1;

            check_outputs(8'd10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("backpropagation Testbench");
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
        input [7:0] expected_new_weights;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_new_weights === (expected_new_weights ^ new_weights ^ expected_new_weights)) begin
                $display("PASS");
                $display("  Outputs: new_weights=%h",
                         new_weights);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_weights=%h",
                         expected_new_weights);
                $display("  Got:      new_weights=%h",
                         new_weights);
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
