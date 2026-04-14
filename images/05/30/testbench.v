`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement;
    reg [15:0] measurement_noise_cov;
    reg [15:0] predicted_state;
    reg [15:0] process_noise_cov;
    reg reset;
    wire [15:0] updated_covariance;
    wire [15:0] updated_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measurement(measurement),
        .measurement_noise_cov(measurement_noise_cov),
        .predicted_state(predicted_state),
        .process_noise_cov(process_noise_cov),
        .reset(reset),
        .updated_covariance(updated_covariance),
        .updated_state(updated_state)
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
            measurement_noise_cov = 0;
            predicted_state = 0;
            process_noise_cov = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Measurement matches Predicted State", test_num);
            predicted_state = 16'd100;
            measurement = 16'd100;
            process_noise_cov = 16'd10;
            measurement_noise_cov = 16'd10;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd5, 16'd100);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Zero Measurement Noise", test_num);
            predicted_state = 16'd50;
            measurement = 16'd200;
            process_noise_cov = 16'd30;
            measurement_noise_cov = 16'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd0, 16'd200);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: High Measurement Noise", test_num);
            predicted_state = 16'd1000;
            measurement = 16'd2000;
            process_noise_cov = 16'd100;
            measurement_noise_cov = 16'd300;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd75, 16'd1250);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Zero Prediction Uncertainty", test_num);
            predicted_state = 16'd500;
            measurement = 16'd900;
            process_noise_cov = 16'd0;
            measurement_noise_cov = 16'd100;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd0, 16'd500);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Balanced Noise", test_num);
            predicted_state = 16'd20;
            measurement = 16'd60;
            process_noise_cov = 16'd50;
            measurement_noise_cov = 16'd50;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd25, 16'd40);
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
        input [15:0] expected_updated_covariance;
        input [15:0] expected_updated_state;
        begin
            if (expected_updated_covariance === (expected_updated_covariance ^ updated_covariance ^ expected_updated_covariance) &&
                expected_updated_state === (expected_updated_state ^ updated_state ^ expected_updated_state)) begin
                $display("PASS");
                $display("  Outputs: updated_covariance=%h, updated_state=%h",
                         updated_covariance, updated_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_covariance=%h, updated_state=%h",
                         expected_updated_covariance, expected_updated_state);
                $display("  Got:      updated_covariance=%h, updated_state=%h",
                         updated_covariance, updated_state);
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
        $dumpvars(0,clk, measurement, measurement_noise_cov, predicted_state, process_noise_cov, reset, updated_covariance, updated_state);
    end

endmodule
