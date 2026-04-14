`timescale 1ns/1ps

module thermal_sensor_calibrator_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] calibration_factor;
    reg [9:0] raw_temp;
    wire [9:0] calibrated_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibrator dut (
        .calibration_factor(calibration_factor),
        .raw_temp(raw_temp),
        .calibrated_temp(calibrated_temp)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero inputs", test_num);
            raw_temp = 10'd0;
            calibration_factor = 10'd0;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic addition without overflow", test_num);
            raw_temp = 10'd100;
            calibration_factor = 10'd50;
            #1;

            check_outputs(10'd150);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum raw temp, zero calibration", test_num);
            raw_temp = 10'h3FF;
            calibration_factor = 10'd0;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero raw temp, maximum calibration", test_num);
            raw_temp = 10'd0;
            calibration_factor = 10'h3FF;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sum exactly at maximum (1023)", test_num);
            raw_temp = 10'd512;
            calibration_factor = 10'd511;
            #1;

            check_outputs(10'd1023);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Overflow saturation (1023 + 1)", test_num);
            raw_temp = 10'd1023;
            calibration_factor = 10'd1;
            #1;

            check_outputs(10'd1023);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum possible overflow (1023 + 1023)", test_num);
            raw_temp = 10'd1023;
            calibration_factor = 10'd1023;
            #1;

            check_outputs(10'd1023);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Arbitrary addition within range", test_num);
            raw_temp = 10'd256;
            calibration_factor = 10'd128;
            #1;

            check_outputs(10'd384);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High raw value with saturation", test_num);
            raw_temp = 10'd900;
            calibration_factor = 10'd200;
            #1;

            check_outputs(10'd1023);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Small increment", test_num);
            raw_temp = 10'd1;
            calibration_factor = 10'd1;
            #1;

            check_outputs(10'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("thermal_sensor_calibrator Testbench");
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
        input [9:0] expected_calibrated_temp;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
