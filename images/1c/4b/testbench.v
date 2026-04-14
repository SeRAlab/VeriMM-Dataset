`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] calibration_factor;
    reg clk;
    reg rst;
    reg [9:0] temperature_input;
    wire [9:0] calibrated_temperature;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .calibration_factor(calibration_factor),
        .clk(clk),
        .rst(rst),
        .temperature_input(temperature_input),
        .calibrated_temperature(calibrated_temperature)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            temperature_input = 0;
            calibration_factor = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Zero Calibration");
            reset_dut();
            temperature_input = 10'd500;
            calibration_factor = 4'sd0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(10'd500);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Positive Calibration");
            reset_dut();
            temperature_input = 10'd100;
            calibration_factor = 4'sd7;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(10'd107);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Negative Calibration");
            reset_dut();
            temperature_input = 10'd100;
            calibration_factor = -4'sd5;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(10'd95);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Upper Bound Saturation");
            reset_dut();
            temperature_input = 10'd1020;
            calibration_factor = 4'sd7;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(10'd1023);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Lower Bound Saturation");
            reset_dut();
            temperature_input = 10'd5;
            calibration_factor = -4'sd8;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(10'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Max Input Negative Factor");
            reset_dut();
            temperature_input = 10'd1023;
            calibration_factor = -4'sd8;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(10'd1015);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Min Input Positive Factor");
            reset_dut();
            temperature_input = 10'd0;
            calibration_factor = 4'sd5;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(10'd5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("thermal_sensor_calibration Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [9:0] expected_calibrated_temperature;
        begin
            if (expected_calibrated_temperature === (expected_calibrated_temperature ^ calibrated_temperature ^ expected_calibrated_temperature)) begin
                $display("PASS");
                $display("  Outputs: calibrated_temperature=%h",
                         calibrated_temperature);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: calibrated_temperature=%h",
                         expected_calibrated_temperature);
                $display("  Got:      calibrated_temperature=%h",
                         calibrated_temperature);
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
        $dumpvars(0,calibration_factor, clk, rst, temperature_input, calibrated_temperature);
    end

endmodule
