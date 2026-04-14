`timescale 1ns/1ps

module neural_net_backpropagation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] initial_weight;
    reg [7:0] input_data;
    reg [7:0] learning_rate;
    reg rst;
    reg [7:0] target_output;
    wire [7:0] output_data;
    wire [7:0] updated_weight;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    neural_net_backpropagation dut (
        .clk(clk),
        .initial_weight(initial_weight),
        .input_data(input_data),
        .learning_rate(learning_rate),
        .rst(rst),
        .target_output(target_output),
        .output_data(output_data),
        .updated_weight(updated_weight)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            initial_weight = 0;
            input_data = 0;
            learning_rate = 0;
            target_output = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: Perfect match - No weight update", test_num);
            initial_weight = 8'd2;
            input_data     = 8'd3;
            target_output  = 8'd6;
            learning_rate  = 8'd1;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'd6, 8'd2);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: Positive Error - Weight increase", test_num);
            initial_weight = 8'd5;
            input_data     = 8'd4;
            target_output  = 8'd30;
            learning_rate  = 8'd2;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'd20, 8'd85);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: Negative Error - Weight decrease", test_num);
            initial_weight = 8'd10;
            input_data     = 8'd5;
            target_output  = 8'd40;
            learning_rate  = 8'd1;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'd50, 8'd216);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: Zero Input - No weight update", test_num);
            initial_weight = 8'd10;
            input_data     = 8'd0;
            target_output  = 8'd50;
            learning_rate  = 8'd5;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'd0, 8'd10);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: Zero Learning Rate - No weight update", test_num);
            initial_weight = 8'd2;
            input_data     = 8'd10;
            target_output  = 8'd100;
            learning_rate  = 8'd0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'd20, 8'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("neural_net_backpropagation Testbench");
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
        input [7:0] expected_updated_weight;
        begin
            if (expected_output_data === (expected_output_data ^ output_data ^ expected_output_data) &&
                expected_updated_weight === (expected_updated_weight ^ updated_weight ^ expected_updated_weight)) begin
                $display("PASS");
                $display("  Outputs: output_data=%h, updated_weight=%h",
                         output_data, updated_weight);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_data=%h, updated_weight=%h",
                         expected_output_data, expected_updated_weight);
                $display("  Got:      output_data=%h, updated_weight=%h",
                         output_data, updated_weight);
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
        $dumpvars(0,clk, initial_weight, input_data, learning_rate, rst, target_output, output_data, updated_weight);
    end

endmodule
