`timescale 1ns/1ps

module backpropagation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] expected_output;
    reg [7:0] input_data;
    reg [7:0] learning_rate;
    reg [7:0] weights;
    wire [7:0] updated_weights;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    backpropagation dut (
        .expected_output(expected_output),
        .input_data(input_data),
        .learning_rate(learning_rate),
        .weights(weights),
        .updated_weights(updated_weights)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No error scenario", test_num);


            weights = 8'd50;
            input_data = 8'd100;
            expected_output = 8'd100;
            learning_rate = 8'd5;
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive error adjustment", test_num);

            weights = 8'd20;
            input_data = 8'd30;
            expected_output = 8'd40;
            learning_rate = 8'd2;
            #1;

            check_outputs(8'd40);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative error adjustment", test_num);

            weights = 8'd100;
            input_data = 8'd50;
            expected_output = 8'd40;
            learning_rate = 8'd3;
            #1;

            check_outputs(8'd70);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero learning rate", test_num);

            weights = 8'd85;
            input_data = 8'd50;
            expected_output = 8'd100;
            learning_rate = 8'd0;
            #1;

            check_outputs(8'd85);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large adjustment", test_num);

            weights = 8'd10;
            input_data = 8'd10;
            expected_output = 8'd20;
            learning_rate = 8'd10;
            #1;

            check_outputs(8'd110);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative weight update (2's complement)", test_num);


            weights = 8'd10;
            input_data = 8'd20;
            expected_output = 8'd0;
            learning_rate = 8'd1;
            #1;

            check_outputs(8'hF6);
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
        input [7:0] expected_updated_weights;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_updated_weights === (expected_updated_weights ^ updated_weights ^ expected_updated_weights)) begin
                $display("PASS");
                $display("  Outputs: updated_weights=%h",
                         updated_weights);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_weights=%h",
                         expected_updated_weights);
                $display("  Got:      updated_weights=%h",
                         updated_weights);
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
