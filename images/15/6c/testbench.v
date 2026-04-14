`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] calibration_factor;
    reg [11:0] raw_reading;
    wire [11:0] calibrated_temperature;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .calibration_factor(calibration_factor),
        .raw_reading(raw_reading),
        .calibrated_temperature(calibrated_temperature)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Zero Factor", test_num);
        raw_reading = 12'hFFF;
        calibration_factor = 4'h0;

        #1;


        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Zero Raw Reading", test_num);
        raw_reading = 12'h000;
        calibration_factor = 4'hF;

        #1;


        check_outputs(12'h000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Maximum Values", test_num);
        raw_reading = 12'hFFF;
        calibration_factor = 4'hF;

        #1;


        check_outputs(12'hEFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Half Scale Factor (0.5)", test_num);
        raw_reading = 12'h400;
        calibration_factor = 4'h8;

        #1;


        check_outputs(12'h200);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Mid-range value with truncation check", test_num);
        raw_reading = 12'h7D0;
        calibration_factor = 4'hA;

        #1;


        check_outputs(12'h4E2);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Minimum Non-zero Factor", test_num);
        raw_reading = 12'h100;
        calibration_factor = 4'h1;

        #1;


        check_outputs(12'h010);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Small result rounding down to zero", test_num);
        raw_reading = 12'h00F;
        calibration_factor = 4'h1;

        #1;


        check_outputs(12'h000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: Complex division result", test_num);
        raw_reading = 12'h4D2;
        calibration_factor = 4'hD;

        #1;


        check_outputs(12'h3EA);
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
        input [11:0] expected_calibrated_temperature;
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
