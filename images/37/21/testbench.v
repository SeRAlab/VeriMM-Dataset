`timescale 1ns/1ps

module NeuralLayer_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] bias;
    reg clk;
    reg [7:0] expected_output;
    reg [2:0] inputs;
    reg reset;
    reg [2:0] weights;
    wire [7:0] new_bias;
    wire [2:0] new_weights;
    wire [7:0] output_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NeuralLayer dut (
        .bias(bias),
        .clk(clk),
        .expected_output(expected_output),
        .inputs(inputs),
        .reset(reset),
        .weights(weights),
        .new_bias(new_bias),
        .new_weights(new_weights),
        .output_value(output_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            bias = 8'h0;
            inputs = 3'b000;
            weights = 3'b000;
            expected_output = 8'h0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Forward pass matches expected (No update)", test_num);



            bias = 8'd10;
            weights = 3'b101;
            inputs = 3'b101;
            expected_output = 8'd12;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd10, 3'b101, 8'd12);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Positive error, zero inputs (Bias increases)", test_num);



            bias = 8'd20;
            weights = 3'b111;
            inputs = 3'b000;
            expected_output = 8'd30;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd30, 3'b111, 8'd20);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Negative error, zero inputs (Bias decreases)", test_num);


            bias = 8'd50;
            weights = 3'b111;
            inputs = 3'b000;
            expected_output = 8'd40;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd40, 3'b111, 8'd50);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Positive error, active inputs (Weights increase)", test_num);




            bias = 8'd0;
            weights = 3'b000;
            inputs = 3'b111;
            expected_output = 8'd10;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd10, 3'b111, 8'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Negative error, specific inputs (Weights decrease)", test_num);






            bias = 8'd10;
            weights = 3'b111;
            inputs = 3'b101;
            expected_output = 8'd5;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd3, 3'b010, 8'd12);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NeuralLayer Testbench");
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
        input [7:0] expected_new_bias;
        input [2:0] expected_new_weights;
        input [7:0] expected_output_value;
        begin
            if (expected_new_bias === (expected_new_bias ^ new_bias ^ expected_new_bias) &&
                expected_new_weights === (expected_new_weights ^ new_weights ^ expected_new_weights) &&
                expected_output_value === (expected_output_value ^ output_value ^ expected_output_value)) begin
                $display("PASS");
                $display("  Outputs: new_bias=%h, new_weights=%h, output_value=%h",
                         new_bias, new_weights, output_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_bias=%h, new_weights=%h, output_value=%h",
                         expected_new_bias, expected_new_weights, expected_output_value);
                $display("  Got:      new_bias=%h, new_weights=%h, output_value=%h",
                         new_bias, new_weights, output_value);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,bias, clk, expected_output, inputs, reset, weights, new_bias, new_weights, output_value);
    end

endmodule
