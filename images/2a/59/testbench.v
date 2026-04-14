`timescale 1ns/1ps

module kalman_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] measurement;
    reg [15:0] measurement_noise;
    reg [15:0] previous_estimate;
    reg [15:0] process_noise;
    reg reset;
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
        .previous_estimate(previous_estimate),
        .process_noise(process_noise),
        .reset(reset),
        .updated_estimate(updated_estimate)
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
            previous_estimate = 0;
            process_noise = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Balanced Noise (50/50 split)", test_num);
            reset_dut();
            measurement = 16'd200;
            measurement_noise = 16'd10;
            previous_estimate = 16'd100;
            process_noise = 16'd10;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd150);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: High Measurement Noise (Trusting Estimate)", test_num);
            reset_dut();
            measurement = 16'd200;
            measurement_noise = 16'd30;
            previous_estimate = 16'd100;
            process_noise = 16'd10;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd125);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: High Process Noise (Trusting Measurement)", test_num);
            reset_dut();
            measurement = 16'd100;
            measurement_noise = 16'd10;
            previous_estimate = 16'd500;
            process_noise = 16'd30;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd200);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Stationary State (No change)", test_num);
            reset_dut();
            measurement = 16'd1000;
            measurement_noise = 16'd50;
            previous_estimate = 16'd1000;
            process_noise = 16'd50;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Zero Measurement Noise (Perfect Sensor)", test_num);
            reset_dut();
            measurement = 16'd800;
            measurement_noise = 16'd0;
            previous_estimate = 16'd500;
            process_noise = 16'd100;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd800);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Large Value Calculation", test_num);
            reset_dut();
            measurement = 16'd20000;
            measurement_noise = 16'd300;
            previous_estimate = 16'd10000;
            process_noise = 16'd100;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd12500);
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
        input [15:0] expected_updated_estimate;
        begin
            if (expected_updated_estimate === (expected_updated_estimate ^ updated_estimate ^ expected_updated_estimate)) begin
                $display("PASS");
                $display("  Outputs: updated_estimate=%h",
                         updated_estimate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_estimate=%h",
                         expected_updated_estimate);
                $display("  Got:      updated_estimate=%h",
                         updated_estimate);
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
        $dumpvars(0,clk, measurement, measurement_noise, previous_estimate, process_noise, reset, updated_estimate);
    end

endmodule
