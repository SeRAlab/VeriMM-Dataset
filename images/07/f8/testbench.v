`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] calibration_factor;
    reg clk;
    reg rst;
    reg [7:0] sensor_reading;
    wire [7:0] calibrated_reading;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .calibration_factor(calibration_factor),
        .clk(clk),
        .rst(rst),
        .sensor_reading(sensor_reading),
        .calibrated_reading(calibrated_reading)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            sensor_reading = 0;
            calibration_factor = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum inputs (0 + 0)", test_num);
            sensor_reading = 8'h00;
            calibration_factor = 4'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Normal addition (100 + 5)", test_num);
            sensor_reading = 8'd100;
            calibration_factor = 4'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd105);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Saturation at max sensor reading (255 + 15)", test_num);
            sensor_reading = 8'hFF;
            calibration_factor = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Saturation boundary (250 + 10)", test_num);
            sensor_reading = 8'd250;
            calibration_factor = 4'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Exact 255 boundary (240 + 15)", test_num);
            sensor_reading = 8'd240;
            calibration_factor = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: High value without saturation (200 + 15)", test_num);
            sensor_reading = 8'd200;
            calibration_factor = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd215);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Small sensor reading, large factor (5 + 15)", test_num);
            sensor_reading = 8'd5;
            calibration_factor = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd20);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Random mid-range values (127 + 8)", test_num);
            sensor_reading = 8'd127;
            calibration_factor = 4'd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd135);
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
        testcase008();
        
        
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
        input [7:0] expected_calibrated_reading;
        begin
            if (expected_calibrated_reading === (expected_calibrated_reading ^ calibrated_reading ^ expected_calibrated_reading)) begin
                $display("PASS");
                $display("  Outputs: calibrated_reading=%h",
                         calibrated_reading);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: calibrated_reading=%h",
                         expected_calibrated_reading);
                $display("  Got:      calibrated_reading=%h",
                         calibrated_reading);
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
        $dumpvars(0,calibration_factor, clk, rst, sensor_reading, calibrated_reading);
    end

endmodule
