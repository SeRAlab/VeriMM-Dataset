`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] calibration_factor;
    reg clk;
    reg [15:0] raw_temp;
    wire [15:0] calibrated_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .calibration_factor(calibration_factor),
        .clk(clk),
        .raw_temp(raw_temp),
        .calibrated_temp(calibrated_temp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            raw_temp = 16'd0;
            calibration_factor = 8'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Zero Adjustment");
            reset_dut();
            test_num = 1;
            raw_temp = 16'hA5A5;
            calibration_factor = 8'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Standard Adjustment");
            reset_dut();
            test_num = 2;
            raw_temp = 16'd1000;
            calibration_factor = 8'd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd1050);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Maximum Factor Adjustment");
            reset_dut();
            test_num = 3;
            raw_temp = 16'd5000;
            calibration_factor = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd5255);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Min Raw Temp Adjustment");
            reset_dut();
            test_num = 4;
            raw_temp = 16'h0000;
            calibration_factor = 8'h10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0010);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Wrap-around Check");
            reset_dut();
            test_num = 5;
            raw_temp = 16'hFFFF;
            calibration_factor = 8'h01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: High Value Boundary");
            reset_dut();
            test_num = 6;
            raw_temp = 16'hFF00;
            calibration_factor = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
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
        input [15:0] expected_calibrated_temp;
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
        $dumpvars(0,calibration_factor, clk, raw_temp, calibrated_temp);
    end

endmodule
