`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] calibration_factor;
    reg clk;
    reg enable;
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
        .enable(enable),
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
            raw_temp = 16'h0;
            calibration_factor = 16'h0;
            enable = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic calibration (addition)");
            reset_dut();

            raw_temp = 16'd1000;
            calibration_factor = 16'd50;
            enable = 1'b1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'd1050);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Zero calibration factor");
            reset_dut();

            raw_temp = 16'd2500;
            calibration_factor = 16'd0;
            enable = 1'b1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'd2500);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Enable signal low (output should remain 0)");
            reset_dut();

            raw_temp = 16'd500;
            calibration_factor = 16'd10;
            enable = 1'b0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(16'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Calibration with negative offset (wrap-around logic)");
            reset_dut();

            raw_temp = 16'd100;
            calibration_factor = 16'hFFFF;
            enable = 1'b1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'd99);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Maximum value overflow");
            reset_dut();

            raw_temp = 16'hFFFF;
            calibration_factor = 16'h0001;
            enable = 1'b1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: High value addition");
            reset_dut();

            raw_temp = 16'h7000;
            calibration_factor = 16'h1000;
            enable = 1'b1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h8000);
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
        $dumpvars(0,calibration_factor, clk, enable, raw_temp, calibrated_temp);
    end

endmodule
