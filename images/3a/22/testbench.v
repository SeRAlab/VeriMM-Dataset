`timescale 1ns/1ps

module ThermalSensorCalibration_tb;

    // Testbench signals (sequential circuit)
    reg calibrate;
    reg [7:0] calibration_value;
    reg [7:0] raw_temp;
    wire [7:0] calibrated_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ThermalSensorCalibration dut (
        .calibrate(calibrate),
        .calibration_value(calibration_value),
        .raw_temp(raw_temp),
        .calibrated_temp(calibrated_temp)
    );

    // Clock generation (10ns period)
    initial begin
        calibrate = 0;
        forever #5 calibrate = ~calibrate;
    end

        task reset_dut;

        begin
            raw_temp = 8'h0;
            calibration_value = 8'h0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %03d: Basic Calibration Adjustment", test_num);
            raw_temp = 8'd50;
            calibration_value = 8'd15;

            @(posedge calibrate);
            #2;
            #1;

            check_outputs(8'd65);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %03d: Zero Calibration Value", test_num);
            raw_temp = 8'd100;
            calibration_value = 8'd0;
            @(posedge calibrate);
            #2;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %03d: Overflow Handling", test_num);
            raw_temp = 8'd250;
            calibration_value = 8'd10;

            @(posedge calibrate);
            #2;
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %03d: Zero Raw Temp with Adjustment", test_num);
            raw_temp = 8'd0;
            calibration_value = 8'd42;
            @(posedge calibrate);
            #2;
            #1;

            check_outputs(8'd42);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %03d: Maximum Input Values", test_num);
            raw_temp = 8'hFF;
            calibration_value = 8'hFF;

            @(posedge calibrate);
            #2;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ThermalSensorCalibration Testbench");
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
        input [7:0] expected_calibrated_temp;
        begin
            if (expected_calibrated_temp === (expected_calibrated_temp ^ calibrated_temp ^ expected_calibrated_temp)) begin
                $display("PASS");
                $display("  Outputs: calibrated_temp=%h",
                         calibrated_temp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: calibrated_temp=%h",
                         expected_calibrated_temp);
                $display("  Got:      calibrated_temp=%h",
                         calibrated_temp);
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
        $dumpvars(0,calibrate, calibration_value, raw_temp, calibrated_temp);
    end

endmodule
