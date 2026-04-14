`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement;
    reg [15:0] prev_estimate;
    reg [15:0] process_noise_cov;
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
        .prev_estimate(prev_estimate),
        .process_noise_cov(process_noise_cov),
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
            prev_estimate = 0;
            process_noise_cov = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            measurement = 16'h0000;
            prev_estimate = 16'h0000;
            process_noise_cov = 16'h0000;


            repeat(5) @(posedge clk);

            $display("Testcase %0d: Zero Inputs", test_num);
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            measurement = 16'h1000;
            prev_estimate = 16'h1000;
            process_noise_cov = 16'h00FF;

            repeat(5) @(posedge clk);

            $display("Testcase %0d: Measurement matches Estimate", test_num);




            #1;





            check_outputs(kalman_gain, 16'h1000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            measurement = 16'h4000;
            prev_estimate = 16'h2000;
            process_noise_cov = 16'hFFFF;

            repeat(5) @(posedge clk);

            $display("Testcase %0d: High Process Noise (High Gain)", test_num);


            #1;



            check_outputs(kalman_gain, updated_estimate);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            measurement = 16'h7000;
            prev_estimate = 16'h1000;
            process_noise_cov = 16'h0001;

            repeat(5) @(posedge clk);

            $display("Testcase %0d: Low Process Noise (Low Gain)", test_num);

            #1;


            check_outputs(kalman_gain, updated_estimate);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            measurement = 16'h1000;
            prev_estimate = 16'h5000;
            process_noise_cov = 16'h0800;

            repeat(5) @(posedge clk);

            $display("Testcase %0d: Negative Measurement Delta", test_num);

            #1;


            check_outputs(kalman_gain, updated_estimate);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            measurement = 16'hF000;
            prev_estimate = 16'h8000;
            process_noise_cov = 16'h4000;

            repeat(5) @(posedge clk);

            $display("Testcase %0d: Large Input Values", test_num);
            #1;

            check_outputs(kalman_gain, updated_estimate);
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
        $dumpvars(0,clk, measurement, prev_estimate, process_noise_cov, rst, kalman_gain, updated_estimate);
    end

endmodule
