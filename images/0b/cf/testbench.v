`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] calibration_offset;
    reg clk;
    reg [9:0] raw_sensor_value;
    reg rst;
    wire [9:0] calibrated_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .calibration_offset(calibration_offset),
        .clk(clk),
        .raw_sensor_value(raw_sensor_value),
        .rst(rst),
        .calibrated_value(calibrated_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            calibration_offset = 0;
            raw_sensor_value = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Addition (100 + 5)", test_num);
            raw_sensor_value = 10'd100;
            calibration_offset = 4'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'd105);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Offset (250 + 0)", test_num);
            raw_sensor_value = 10'd250;
            calibration_offset = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'd250);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Sensor Value (0 + 12)", test_num);
            raw_sensor_value = 10'd0;
            calibration_offset = 4'd12;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'd12);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Offset (500 + 15)", test_num);
            raw_sensor_value = 10'd500;
            calibration_offset = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'd515);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Max Sensor + 1 (Overflow wrap)", test_num);
            raw_sensor_value = 10'h3FF;
            calibration_offset = 4'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Max Sensor + Max Offset (Overflow wrap)", test_num);
            raw_sensor_value = 10'h3FF;
            calibration_offset = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h00E);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset State Verification", test_num);
            rst = 1;
            raw_sensor_value = 10'd500;
            calibration_offset = 4'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'd0);
            rst = 0;
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
        input [9:0] expected_calibrated_value;
        begin
            if (expected_calibrated_value === (expected_calibrated_value ^ calibrated_value ^ expected_calibrated_value)) begin
                $display("PASS");
                $display("  Outputs: calibrated_value=%h",
                         calibrated_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: calibrated_value=%h",
                         expected_calibrated_value);
                $display("  Got:      calibrated_value=%h",
                         calibrated_value);
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
        $dumpvars(0,calibration_offset, clk, raw_sensor_value, rst, calibrated_value);
    end

endmodule
