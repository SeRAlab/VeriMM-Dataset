`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] calibration_factor;
    reg [9:0] temperature_input;
    wire [9:0] calibrated_temperature;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .calibration_factor(calibration_factor),
        .temperature_input(temperature_input),
        .calibrated_temperature(calibrated_temperature)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Inputs", test_num);
            temperature_input = 10'd0;
            calibration_factor = 4'd0;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Addition", test_num);
            temperature_input = 10'd100;
            calibration_factor = 4'd5;
            #1;

            check_outputs(10'd105);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Calibration Factor", test_num);
            temperature_input = 10'd500;
            calibration_factor = 4'd15;
            #1;

            check_outputs(10'd515);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Input, Zero Calibration", test_num);
            temperature_input = 10'd1023;
            calibration_factor = 4'd0;
            #1;

            check_outputs(10'd1023);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Overflow Wrap-around (1023 + 1)", test_num);
            temperature_input = 10'd1023;
            calibration_factor = 4'd1;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Overflow Wrap-around (Max + Max)", test_num);
            temperature_input = 10'd1023;
            calibration_factor = 4'd15;
            #1;

            check_outputs(10'd14);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mid-scale Value", test_num);
            temperature_input = 10'h200;
            calibration_factor = 4'h8;
            #1;

            check_outputs(10'h208);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High-scale Near Overflow", test_num);
            temperature_input = 10'd1010;
            calibration_factor = 4'd10;
            #1;

            check_outputs(10'd1020);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary Value Addition", test_num);
            temperature_input = 10'd1020;
            calibration_factor = 4'd4;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random Bit Pattern", test_num);
            temperature_input = 10'b1010101010;
            calibration_factor = 4'b0101;
            #1;

            check_outputs(10'd687);
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
        testcase009();
        testcase010();
        
        
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
        input [9:0] expected_calibrated_temperature;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
