`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement;
    reg [15:0] measurement_noise;
    reg [15:0] model_noise;
    reg [15:0] prediction;
    reg reset;
    wire [15:0] error_covariance;
    wire [15:0] estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measurement(measurement),
        .measurement_noise(measurement_noise),
        .model_noise(model_noise),
        .prediction(prediction),
        .reset(reset),
        .error_covariance(error_covariance),
        .estimate(estimate)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            measurement = 0;
            measurement_noise = 0;
            model_noise = 0;
            prediction = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Balanced Noise", test_num);
            reset_dut();
            measurement = 16'd200;
            prediction = 16'd100;
            model_noise = 16'd50;
            measurement_noise = 16'd50;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd25, 16'd150);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: High Measurement Noise", test_num);
            reset_dut();
            measurement = 16'd200;
            prediction = 16'd100;
            model_noise = 16'd20;
            measurement_noise = 16'd80;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd16, 16'd120);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: High Model Noise", test_num);
            reset_dut();
            measurement = 16'd200;
            prediction = 16'd100;
            model_noise = 16'd80;
            measurement_noise = 16'd20;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd16, 16'd180);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Identical Inputs", test_num);
            reset_dut();
            measurement = 16'd500;
            prediction = 16'd500;
            model_noise = 16'd40;
            measurement_noise = 16'd60;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd24, 16'd500);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Zero Model Noise", test_num);
            reset_dut();
            measurement = 16'd1000;
            prediction = 16'd250;
            model_noise = 16'd0;
            measurement_noise = 16'd100;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0, 16'd250);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Zero Measurement Noise", test_num);
            reset_dut();
            measurement = 16'd777;
            prediction = 16'd111;
            model_noise = 16'd100;
            measurement_noise = 16'd0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0, 16'd777);
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
        input [15:0] expected_error_covariance;
        input [15:0] expected_estimate;
        begin
            if (expected_error_covariance === (expected_error_covariance ^ error_covariance ^ expected_error_covariance) &&
                expected_estimate === (expected_estimate ^ estimate ^ expected_estimate)) begin
                $display("PASS");
                $display("  Outputs: error_covariance=%h, estimate=%h",
                         error_covariance, estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error_covariance=%h, estimate=%h",
                         expected_error_covariance, expected_estimate);
                $display("  Got:      error_covariance=%h, estimate=%h",
                         error_covariance, estimate);
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
        $dumpvars(0,clk, measurement, measurement_noise, model_noise, prediction, reset, error_covariance, estimate);
    end

endmodule
