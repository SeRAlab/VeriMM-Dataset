`timescale 1ns/1ps

module simple_nn_layer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] error_gradient;
    reg [4:0] inputs;
    reg [4:0] learning_rate;
    reg reset;
    reg [4:0] weights;
    wire [4:0] outputs;
    wire [4:0] updated_weights;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_nn_layer dut (
        .clk(clk),
        .error_gradient(error_gradient),
        .inputs(inputs),
        .learning_rate(learning_rate),
        .reset(reset),
        .weights(weights),
        .outputs(outputs),
        .updated_weights(updated_weights)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            inputs = 0;
            weights = 0;
            learning_rate = 0;
            error_gradient = 0;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero input and weights", test_num);
            reset_dut();

            inputs = 5'd0;
            weights = 5'd0;
            learning_rate = 5'd0;
            error_gradient = 5'd0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0, 5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Forward pass check", test_num);
            reset_dut();

            inputs = 5'd3;
            weights = 5'd4;
            learning_rate = 5'd0;
            error_gradient = 5'd5;

            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd12, 5'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic backpropagation update", test_num);
            reset_dut();

            inputs = 5'd1;
            weights = 5'd20;
            learning_rate = 5'd2;
            error_gradient = 5'd3;

            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd20, 5'd14);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Forward pass truncation", test_num);
            reset_dut();

            inputs = 5'd8;
            weights = 5'd8;
            learning_rate = 5'd1;
            error_gradient = 5'd1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0, 5'd7);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Weight update underflow/wrap", test_num);
            reset_dut();

            inputs = 5'd2;
            weights = 5'd5;
            learning_rate = 5'd4;
            error_gradient = 5'd3;

            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd10, 5'd25);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max input values", test_num);
            reset_dut();

            inputs = 5'd31;
            weights = 5'd1;
            learning_rate = 5'd31;
            error_gradient = 5'd1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd31, 5'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_nn_layer Testbench");
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
        input [4:0] expected_outputs;
        input [4:0] expected_updated_weights;
        begin
            if (expected_outputs === (expected_outputs ^ outputs ^ expected_outputs) &&
                expected_updated_weights === (expected_updated_weights ^ updated_weights ^ expected_updated_weights)) begin
                $display("PASS");
                $display("  Outputs: outputs=%h, updated_weights=%h",
                         outputs, updated_weights);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outputs=%h, updated_weights=%h",
                         expected_outputs, expected_updated_weights);
                $display("  Got:      outputs=%h, updated_weights=%h",
                         outputs, updated_weights);
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
        $dumpvars(0,clk, error_gradient, inputs, learning_rate, reset, weights, outputs, updated_weights);
    end

endmodule
