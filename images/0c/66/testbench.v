`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg calibrate;
    reg [15:0] calibration_factor;
    reg clk;
    reg [15:0] raw_temp;
    reg reset;
    wire [31:0] calibrated_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .calibrate(calibrate),
        .calibration_factor(calibration_factor),
        .clk(clk),
        .raw_temp(raw_temp),
        .reset(reset),
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
            calibrate = 0;
            calibration_factor = 16'd0;
            raw_temp = 16'd0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Basic multiplication");
            reset_dut();
            test_num = 1;
            raw_temp = 16'd100;
            calibration_factor = 16'd5;
            calibrate = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd500);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Identity Factor");
            reset_dut();
            test_num = 2;
            raw_temp = 16'd1234;
            calibration_factor = 16'd1;
            calibrate = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd1234);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Multiplication by Zero");
            reset_dut();
            test_num = 3;
            raw_temp = 16'd5000;
            calibration_factor = 16'd0;
            calibrate = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Max Factor and Max Temperature");
            reset_dut();
            test_num = 4;
            raw_temp = 16'hFFFF;
            calibration_factor = 16'hFFFF;
            calibrate = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFE0001);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Sequential Adjustments");
            reset_dut();
            test_num = 5;


            raw_temp = 16'd10;
            calibration_factor = 16'd2;
            calibrate = 1;
            @(posedge clk);



            raw_temp = 16'd20;
            calibration_factor = 16'd10;
            calibrate = 1;
            @(posedge clk);

            #1;
            #1;

            check_outputs(32'd200);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Verify Reset State");
            reset_dut();
            test_num = 6;

            raw_temp = 16'd100;
            calibration_factor = 16'd100;
            calibrate = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'd0);
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
        input [31:0] expected_calibrated_temp;
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
        $dumpvars(0,calibrate, calibration_factor, clk, raw_temp, reset, calibrated_temp);
    end

endmodule
