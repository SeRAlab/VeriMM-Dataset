`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] calibration_factor;
    reg clk;
    reg enable;
    reg [3:0] sensor_value;
    wire [3:0] calibrated_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .calibration_factor(calibration_factor),
        .clk(clk),
        .enable(enable),
        .sensor_value(sensor_value),
        .calibrated_output(calibrated_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sensor_value = 4'd0;
            calibration_factor = 4'd0;
            enable = 1'b1;
            @(posedge clk);
            #1;
            enable = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Addition (5 + 3 = 8)");
            reset_dut();
            sensor_value = 4'd5;
            calibration_factor = 4'd3;
            enable = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Output Persistence (Enable=0)");
            reset_dut();

            sensor_value = 4'd4;
            calibration_factor = 4'd2;
            enable = 1'b1;
            @(posedge clk);
            #1;


            enable = 1'b0;
            sensor_value = 4'd10;
            calibration_factor = 4'd5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'd6);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Overflow Handling (15 + 1 = 0)");
            reset_dut();
            sensor_value = 4'd15;
            calibration_factor = 4'd1;
            enable = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Changing Calibration Factor (7 + 7 = 14)");
            reset_dut();
            sensor_value = 4'd7;
            calibration_factor = 4'd7;
            enable = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Zero Inputs (0 + 0 = 0)");
            reset_dut();
            sensor_value = 4'd0;
            calibration_factor = 4'd0;
            enable = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Near Overflow (8 + 7 = 15)");
            reset_dut();
            sensor_value = 4'd8;
            calibration_factor = 4'd7;
            enable = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15);
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
        input [3:0] expected_calibrated_output;
        begin
            if (expected_calibrated_output === (expected_calibrated_output ^ calibrated_output ^ expected_calibrated_output)) begin
                $display("PASS");
                $display("  Outputs: calibrated_output=%h",
                         calibrated_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: calibrated_output=%h",
                         expected_calibrated_output);
                $display("  Got:      calibrated_output=%h",
                         calibrated_output);
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
        $dumpvars(0,calibration_factor, clk, enable, sensor_value, calibrated_output);
    end

endmodule
