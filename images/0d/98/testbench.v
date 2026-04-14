`timescale 1ns/1ps

module neural_network_layer_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] bias;
    reg clk;
    reg [7:0] input_data;
    reg rst;
    reg [7:0] target;
    reg train;
    reg [7:0] weights;
    wire [7:0] output_data;
    wire [7:0] updated_bias;
    wire [7:0] updated_weights;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    neural_network_layer dut (
        .bias(bias),
        .clk(clk),
        .input_data(input_data),
        .rst(rst),
        .target(target),
        .train(train),
        .weights(weights),
        .output_data(output_data),
        .updated_bias(updated_bias),
        .updated_weights(updated_weights)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        clk = 0;
        input_data = 0;
        weights = 0;
        bias = 0;
        target = 0;
        train = 0;
        #10;
        rst = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Forward Pass Only", test_num);

        input_data = 8'h02;
        weights    = 8'h03;
        bias       = 8'h04;
        target     = 8'h0A;
        train      = 1'b0;

        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h0A, 8'h04, 8'h03);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Training - Decrease Params", test_num);

        input_data = 8'h02;
        weights    = 8'h0A;
        bias       = 8'h05;
        target     = 8'h14;
        train      = 1'b1;

        repeat(2) @(posedge clk);
        #1;

        #1;


        check_outputs(8'h19, 8'h00, 8'h00);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Training - Increase Params", test_num);

        input_data = 8'h01;
        weights    = 8'h05;
        bias       = 8'h02;
        target     = 8'h0C;
        train      = 1'b1;

        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h07, 8'h07, 8'h0A);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Input Training", test_num);

        input_data = 8'h00;
        weights    = 8'h0A;
        bias       = 8'h0A;
        target     = 8'h05;
        train      = 1'b1;

        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h0A, 8'h05, 8'h0A);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Error Stability", test_num);

        input_data = 8'h04;
        weights    = 8'h02;
        bias       = 8'h02;
        target     = 8'h0A;
        train      = 1'b1;

        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h0A, 8'h02, 8'h02);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("neural_network_layer Testbench");
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
        input [7:0] expected_output_data;
        input [7:0] expected_updated_bias;
        input [7:0] expected_updated_weights;
        begin
            if (expected_output_data === (expected_output_data ^ output_data ^ expected_output_data) &&
                expected_updated_bias === (expected_updated_bias ^ updated_bias ^ expected_updated_bias) &&
                expected_updated_weights === (expected_updated_weights ^ updated_weights ^ expected_updated_weights)) begin
                $display("PASS");
                $display("  Outputs: output_data=%h, updated_bias=%h, updated_weights=%h",
                         output_data, updated_bias, updated_weights);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_data=%h, updated_bias=%h, updated_weights=%h",
                         expected_output_data, expected_updated_bias, expected_updated_weights);
                $display("  Got:      output_data=%h, updated_bias=%h, updated_weights=%h",
                         output_data, updated_bias, updated_weights);
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
        $dumpvars(0,bias, clk, input_data, rst, target, train, weights, output_data, updated_bias, updated_weights);
    end

endmodule
