`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] calibration_factor;
    reg clk;
    reg reset;
    reg [7:0] temp_input;
    wire [7:0] calibrated_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .calibration_factor(calibration_factor),
        .clk(clk),
        .reset(reset),
        .temp_input(temp_input),
        .calibrated_temp(calibrated_temp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        temp_input = 0;
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
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Standard addition (25 + 10 = 35)", test_num);
        temp_input = 8'd25;
        calibration_factor = 8'd10;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'd35);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Exact limit (80 + 20 = 100)", test_num);
        temp_input = 8'd80;
        calibration_factor = 8'd20;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'd100);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Saturation check (90 + 20 = 100)", test_num);
        temp_input = 8'd90;
        calibration_factor = 8'd20;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'd100);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Zero calibration factor (50 + 0 = 50)", test_num);
        temp_input = 8'd50;
        calibration_factor = 8'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'd50);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Zero input temp (0 + 15 = 15)", test_num);
        temp_input = 8'd0;
        calibration_factor = 8'd15;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %0d: Input exceeds limit (110 + 5 = 100)", test_num);
        temp_input = 8'd110;
        calibration_factor = 8'd5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'd100);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Testcase %0d: Max bit values (255 + 255 = 100)", test_num);
        temp_input = 8'hFF;
        calibration_factor = 8'hFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'd100);
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
        $dumpvars(0,calibration_factor, clk, reset, temp_input, calibrated_temp);
    end

endmodule
