`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] calibration_offset;
    reg clk;
    reg [7:0] temperature_reading;
    wire [7:0] calibrated_temperature;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .calibration_offset(calibration_offset),
        .clk(clk),
        .temperature_reading(temperature_reading),
        .calibrated_temperature(calibrated_temperature)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            calibration_offset = 8'h00;
            temperature_reading = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            calibration_offset = 8'h00;
            temperature_reading = 8'h00;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Zero inputs", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            calibration_offset = 8'h05;
            temperature_reading = 8'h14;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Normal addition (20 + 5)", test_num);
            #1;

            check_outputs(8'h19);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            calibration_offset = 8'h10;
            temperature_reading = 8'h64;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Higher range (100 + 16)", test_num);
            #1;

            check_outputs(8'h74);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            calibration_offset = 8'h02;
            temperature_reading = 8'hFF;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Overflow check (255 + 2)", test_num);
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            calibration_offset = 8'hFF;
            temperature_reading = 8'h0A;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Negative offset/High unsigned addition (10 + 255)", test_num);
            #1;

            check_outputs(8'h09);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            calibration_offset = 8'hFF;
            temperature_reading = 8'hFF;
            @(posedge clk);
            #1;
            $display("Test Case %0d: Max values wrap (255 + 255)", test_num);
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
        input [7:0] expected_calibrated_temperature;
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
        $dumpvars(0,calibration_offset, clk, temperature_reading, calibrated_temperature);
    end

endmodule
