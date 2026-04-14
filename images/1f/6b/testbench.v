`timescale 1ns/1ps

module cnn_inference_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] filter;
    reg [23:0] input_map;
    reg rst;
    reg valid;
    wire [15:0] output_map;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cnn_inference dut (
        .clk(clk),
        .filter(filter),
        .input_map(input_map),
        .rst(rst),
        .valid(valid),
        .output_map(output_map)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid = 0;
            filter = 0;
            input_map = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            reset_dut();

            input_map = 24'h000000;
            filter = 16'h0000;
            valid = 1;
            @(posedge clk);
            valid = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Basic Positive Convolution", test_num);
            reset_dut();

            input_map = 24'h15555;
            filter = 16'h1111;
            valid = 1;
            @(posedge clk);
            valid = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h4444);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: ReLU Negative Clamping", test_num);
            reset_dut();

            input_map = 24'h15555;
            filter = 16'hFFFF;
            valid = 1;
            @(posedge clk);
            valid = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Specific Feature Pattern", test_num);
            reset_dut();

            input_map = 24'h11649;
            filter = 16'h1021;
            valid = 1;
            @(posedge clk);
            valid = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h6266);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Max Input Saturation", test_num);
            reset_dut();

            input_map = 24'h3FFFF;
            filter = 16'h7777;
            valid = 1;

            @(posedge clk);
            valid = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cnn_inference Testbench");
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
        input [15:0] expected_output_map;
        begin
            if (expected_output_map === (expected_output_map ^ output_map ^ expected_output_map)) begin
                $display("PASS");
                $display("  Outputs: output_map=%h",
                         output_map);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_map=%h",
                         expected_output_map);
                $display("  Got:      output_map=%h",
                         output_map);
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
        $dumpvars(0,clk, filter, input_map, rst, valid, output_map);
    end

endmodule
