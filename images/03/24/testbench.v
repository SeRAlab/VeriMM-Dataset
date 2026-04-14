`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] calibration_offset;
    reg [4:0] temp_reading;
    wire [6:0] calibrated_temperature;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .calibration_offset(calibration_offset),
        .temp_reading(temp_reading),
        .calibrated_temperature(calibrated_temperature)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero inputs", test_num);
            temp_reading = 5'd0;
            calibration_offset = 5'd0;
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Small values", test_num);
            temp_reading = 5'd5;
            calibration_offset = 5'd10;
            #1;

            check_outputs(7'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum possible sum (31 + 31)", test_num);
            temp_reading = 5'd31;
            calibration_offset = 5'd31;
            #1;

            check_outputs(7'd62);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum temp reading with zero offset", test_num);
            temp_reading = 5'd31;
            calibration_offset = 5'd0;
            #1;

            check_outputs(7'd31);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero temp reading with maximum offset", test_num);
            temp_reading = 5'd0;
            calibration_offset = 5'd31;
            #1;

            check_outputs(7'd31);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mid-range values", test_num);
            temp_reading = 5'd15;
            calibration_offset = 5'd15;
            #1;

            check_outputs(7'd30);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Offset causing 6-bit result", test_num);
            temp_reading = 5'd20;
            calibration_offset = 5'd12;
            #1;

            check_outputs(7'd32);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating bits", test_num);
            temp_reading = 5'b10101;
            calibration_offset = 5'b01010;
            #1;

            check_outputs(7'd31);
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
        input [6:0] expected_calibrated_temperature;
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
