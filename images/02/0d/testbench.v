`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] calibration_factor;
    reg clk;
    reg [15:0] raw_temp;
    reg rst;
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
        .rst(rst),
        .calibrated_temp(calibrated_temp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            raw_temp = 16'h0;
            calibration_factor = 8'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Calibration", test_num);
            reset_dut();
            raw_temp = 16'd1000;
            calibration_factor = 8'd25;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd1025);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Factor Calibration", test_num);
            reset_dut();
            raw_temp = 16'hABCD;
            calibration_factor = 8'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Factor Calibration", test_num);
            reset_dut();
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
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset_dut();
            raw_temp = 16'd2000;
            calibration_factor = 8'd10;
            @(posedge clk);
            #1;

            if (calibrated_temp !== 16'd2010) $display("Setup failed");

            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High Range Temperature", test_num);
            reset_dut();
            raw_temp = 16'hFE00;
            calibration_factor = 8'h80;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFE80);
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
        $dumpvars(0,calibration_factor, clk, raw_temp, rst, calibrated_temp);
    end

endmodule
