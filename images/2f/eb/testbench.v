`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement;
    reg [15:0] measurement_noise;
    reg [15:0] prediction;
    reg [15:0] prediction_noise;
    reg rst;
    wire [15:0] kalman_gain;
    wire [15:0] updated_estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measurement(measurement),
        .measurement_noise(measurement_noise),
        .prediction(prediction),
        .prediction_noise(prediction_noise),
        .rst(rst),
        .kalman_gain(kalman_gain),
        .updated_estimate(updated_estimate)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            measurement = 0;
            measurement_noise = 0;
            prediction = 0;
            prediction_noise = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Equal confidence (K=0.5)");
            reset_dut();
            prediction = 16'd100;
            prediction_noise = 16'd20;
            measurement = 16'd200;
            measurement_noise = 16'd20;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0080, 16'h0096);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: High confidence in measurement (K=0.75)");
            reset_dut();
            prediction = 16'd100;
            prediction_noise = 16'd60;
            measurement = 16'd200;
            measurement_noise = 16'd20;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h00C0, 16'h00AF);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: High confidence in prediction (K=0.25)");
            reset_dut();
            prediction = 16'd100;
            prediction_noise = 16'd20;
            measurement = 16'd200;
            measurement_noise = 16'd60;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0040, 16'h007D);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Zero Innovation (z == x_pred)");
            reset_dut();
            prediction = 16'd50;
            prediction_noise = 16'd10;
            measurement = 16'd50;
            measurement_noise = 16'd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0080, 16'h0032);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Absolute certainty in measurement (K=1.0)");
            reset_dut();
            prediction = 16'd0;
            prediction_noise = 16'd100;
            measurement = 16'd150;
            measurement_noise = 16'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0100, 16'h0096);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kalman_filter Testbench");
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
        input [15:0] expected_kalman_gain;
        input [15:0] expected_updated_estimate;
        begin
            if (expected_kalman_gain === (expected_kalman_gain ^ kalman_gain ^ expected_kalman_gain) &&
                expected_updated_estimate === (expected_updated_estimate ^ updated_estimate ^ expected_updated_estimate)) begin
                $display("PASS");
                $display("  Outputs: kalman_gain=%h, updated_estimate=%h",
                         kalman_gain, updated_estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: kalman_gain=%h, updated_estimate=%h",
                         expected_kalman_gain, expected_updated_estimate);
                $display("  Got:      kalman_gain=%h, updated_estimate=%h",
                         kalman_gain, updated_estimate);
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
        $dumpvars(0,clk, measurement, measurement_noise, prediction, prediction_noise, rst, kalman_gain, updated_estimate);
    end

endmodule
