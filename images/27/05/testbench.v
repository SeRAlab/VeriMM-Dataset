`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] calibration_factor;
    reg clk;
    reg [15:0] raw_temperature;
    reg reset;
    wire [15:0] calibrated_temperature;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
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
            raw_temperature = 16'h0;
            calibration_factor = 8'h0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Calibration Logic", test_num);
            reset_dut();
            raw_temperature = 16'd1000;
            calibration_factor = 8'd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd1010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Calibration Factor", test_num);
            reset_dut();
            raw_temperature = 16'd500;
            calibration_factor = 8'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd500);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Raw Temperature", test_num);
            reset_dut();
            raw_temperature = 16'd0;
            calibration_factor = 8'd128;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd128);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Range Calibration", test_num);
            reset_dut();
            raw_temperature = 16'hFF00;
            calibration_factor = 8'hFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Functionality", test_num);
            reset_dut();
            raw_temperature = 16'hABCD;
            calibration_factor = 8'h12;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Consecutive Samples", test_num);
            reset_dut();


            raw_temperature = 16'd100;
            calibration_factor = 8'd5;
            @(posedge clk);


            raw_temperature = 16'd200;
            calibration_factor = 8'd10;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'd210);
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
