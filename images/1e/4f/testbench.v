`timescale 1ns/1ps

module backpropagation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] bias_hidden;
    reg [7:0] expected_output;
    reg [7:0] input_data;
    reg [7:0] learning_rate;
    reg [7:0] weights_hidden;
    wire [7:0] new_bias_hidden;
    wire [7:0] new_weights_hidden;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    backpropagation dut (
        .bias_hidden(bias_hidden),
        .expected_output(expected_output),
        .input_data(input_data),
        .learning_rate(learning_rate),
        .weights_hidden(weights_hidden),
        .new_bias_hidden(new_bias_hidden),
        .new_weights_hidden(new_weights_hidden)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Prediction matches target (1==1)", test_num);
            input_data = 8'h05;
            weights_hidden = 8'h02;
            bias_hidden = 8'h0A;
            expected_output = 8'h01;
            learning_rate = 8'h02;


            #1;



            check_outputs(8'h0A, 8'h02);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Under-prediction (0 vs 1)", test_num);
            input_data = 8'h03;
            weights_hidden = 8'hF6;
            bias_hidden = 8'h05;
            expected_output = 8'h01;
            learning_rate = 8'h02;



            #1;




            check_outputs(8'h07, 8'hFC);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Over-prediction (1 vs 0)", test_num);
            input_data = 8'h04;
            weights_hidden = 8'h05;
            bias_hidden = 8'h02;
            expected_output = 8'h00;
            learning_rate = 8'h03;



            #1;




            check_outputs(8'hFF, 8'hF9);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Zero input (Bias update only)", test_num);
            input_data = 8'h00;
            weights_hidden = 8'h05;
            bias_hidden = 8'hFB;
            expected_output = 8'h01;
            learning_rate = 8'h04;



            #1;




            check_outputs(8'hFF, 8'h05);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Learning rate is zero", test_num);
            input_data = 8'h0A;
            weights_hidden = 8'h0A;
            bias_hidden = 8'h0A;
            expected_output = 8'h00;
            learning_rate = 8'h00;


            #1;



            check_outputs(8'h0A, 8'h0A);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Sum is exactly zero", test_num);
            input_data = 8'h02;
            weights_hidden = 8'hFB;
            bias_hidden = 8'h0A;
            expected_output = 8'h00;
            learning_rate = 8'h01;



            #1;




            check_outputs(8'h09, 8'hF9);
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
        input [7:0] expected_new_bias_hidden;
        input [7:0] expected_new_weights_hidden;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_new_bias_hidden === (expected_new_bias_hidden ^ new_bias_hidden ^ expected_new_bias_hidden) &&
                expected_new_weights_hidden === (expected_new_weights_hidden ^ new_weights_hidden ^ expected_new_weights_hidden)) begin
                $display("PASS");
                $display("  Outputs: new_bias_hidden=%h, new_weights_hidden=%h",
                         new_bias_hidden, new_weights_hidden);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_bias_hidden=%h, new_weights_hidden=%h",
                         expected_new_bias_hidden, expected_new_weights_hidden);
                $display("  Got:      new_bias_hidden=%h, new_weights_hidden=%h",
                         new_bias_hidden, new_weights_hidden);
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
