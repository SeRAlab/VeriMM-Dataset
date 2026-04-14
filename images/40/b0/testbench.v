`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement;
    reg [15:0] measurement_noise_cov;
    reg [15:0] prev_estimate;
    reg [15:0] process_noise_cov;
    reg reset;
    wire [15:0] state_estimate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kalman_filter dut (
        .clk(clk),
        .measurement(measurement),
        .measurement_noise_cov(measurement_noise_cov),
        .prev_estimate(prev_estimate),
        .process_noise_cov(process_noise_cov),
        .reset(reset),
        .state_estimate(state_estimate)
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
            prev_estimate = 0;
            process_noise_cov = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Zero Process Noise (Trusting Model)", test_num);
            reset_dut();
            prev_estimate = 16'd500;
            measurement = 16'd1000;
            process_noise_cov = 16'd0;
            measurement_noise_cov = 16'd100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd500);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Zero Measurement Noise (Trusting Sensor)", test_num);
            reset_dut();
            prev_estimate = 16'd500;
            measurement = 16'd1000;
            process_noise_cov = 16'd100;
            measurement_noise_cov = 16'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Equal Covariance (50/50 Weighting)", test_num);
            reset_dut();
            prev_estimate = 16'd100;
            measurement = 16'd200;
            process_noise_cov = 16'd50;
            measurement_noise_cov = 16'd50;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd150);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Higher Measurement Noise (Bias toward Prev)", test_num);
            reset_dut();
            prev_estimate = 16'd100;
            measurement = 16'd300;
            process_noise_cov = 16'd10;
            measurement_noise_cov = 16'd30;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd150);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Higher Process Noise (Bias toward Meas)", test_num);
            reset_dut();
            prev_estimate = 16'd100;
            measurement = 16'd300;
            process_noise_cov = 16'd30;
            measurement_noise_cov = 16'd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd250);
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
        input [15:0] expected_state_estimate;
        begin
            if (expected_state_estimate === (expected_state_estimate ^ state_estimate ^ expected_state_estimate)) begin
                $display("PASS");
                $display("  Outputs: state_estimate=%h",
                         state_estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state_estimate=%h",
                         expected_state_estimate);
                $display("  Got:      state_estimate=%h",
                         state_estimate);
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
        $dumpvars(0,clk, measurement, measurement_noise_cov, prev_estimate, process_noise_cov, reset, state_estimate);
    end

endmodule
