`timescale 1ns/1ps

module ThermalSensorCalibrator_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] calibration_factor;
    reg clk;
    reg [15:0] raw_temperature;
    reg reset;
    wire [15:0] calibrated_temperature;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ThermalSensorCalibrator dut (
        .calibration_factor(calibration_factor),
        .clk(clk),
        .raw_temperature(raw_temperature),
        .reset(reset),
        .calibrated_temperature(calibrated_temperature)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            raw_temperature = 0;
            calibration_factor = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Addition", test_num);
            reset_dut();

            raw_temperature = 16'h0064;
            calibration_factor = 16'h0032;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0096);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Addition with Zero", test_num);
            reset_dut();

            raw_temperature = 16'h1234;
            calibration_factor = 16'h0000;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Values (Overflow Check)", test_num);
            reset_dut();

            raw_temperature = 16'hFFFF;
            calibration_factor = 16'h0001;

            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mid-range Values", test_num);
            reset_dut();

            raw_temperature = 16'hA5A5;
            calibration_factor = 16'h5A5A;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset Priority Check", test_num);
            reset_dut();


            raw_temperature = 16'hBBBB;
            calibration_factor = 16'hCCCC;
            reset = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000);
            reset = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Consecutive Changes", test_num);
            reset_dut();


            raw_temperature = 16'h0010;
            calibration_factor = 16'h0020;
            @(posedge clk);
            #1;


            raw_temperature = 16'h0100;
            calibration_factor = 16'h0200;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0300);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ThermalSensorCalibrator Testbench");
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
        input [15:0] expected_calibrated_temperature;
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
        $dumpvars(0,calibration_factor, clk, raw_temperature, reset, calibrated_temperature);
    end

endmodule
