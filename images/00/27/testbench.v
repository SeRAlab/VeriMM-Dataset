`timescale 1ns/1ps

module thermal_sensor_calibrator_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] correction_factor;
    reg [9:0] sensor_reading;
    wire [9:0] calibrated_reading;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibrator dut (
        .correction_factor(correction_factor),
        .sensor_reading(sensor_reading),
        .calibrated_reading(calibrated_reading)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        sensor_reading = 10'd0;
        correction_factor = 10'd0;
        $display("Test %0d: All zeros", test_num);
        #1;

        check_outputs(10'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        sensor_reading = 10'd500;
        correction_factor = 10'd0;
        $display("Test %0d: Zero correction factor", test_num);
        #1;

        check_outputs(10'd500);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        sensor_reading = 10'd0;
        correction_factor = 10'd500;
        $display("Test %0d: Zero sensor reading", test_num);
        #1;

        check_outputs(10'd500);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        sensor_reading = 10'd100;
        correction_factor = 10'd200;
        $display("Test %0d: Standard addition (100 + 200)", test_num);
        #1;

        check_outputs(10'd300);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        sensor_reading = 10'd512;
        correction_factor = 10'd511;
        $display("Test %0d: Maximum value without overflow (512 + 511)", test_num);
        #1;

        check_outputs(10'd1023);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        sensor_reading = 10'd512;
        correction_factor = 10'd512;
        $display("Test %0d: Small overflow clamping (512 + 512)", test_num);
        #1;

        check_outputs(10'd1023);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        sensor_reading = 10'd1023;
        correction_factor = 10'd1;
        $display("Test %0d: Single unit overflow clamping (1023 + 1)", test_num);
        #1;

        check_outputs(10'd1023);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        sensor_reading = 10'd1023;
        correction_factor = 10'd1023;
        $display("Test %0d: Maximum overflow clamping (1023 + 1023)", test_num);
        #1;

        check_outputs(10'd1023);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        sensor_reading = 10'd750;
        correction_factor = 10'd300;
        $display("Test %0d: Partial overflow clamping (750 + 300)", test_num);
        #1;

        check_outputs(10'd1023);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        sensor_reading = 10'd1;
        correction_factor = 10'd1;
        $display("Test %0d: Minimal addition (1 + 1)", test_num);
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
        input [9:0] expected_calibrated_reading;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_calibrated_reading === (expected_calibrated_reading ^ calibrated_reading ^ expected_calibrated_reading)) begin
                $display("PASS");
                $display("  Outputs: calibrated_reading=%h",
                         calibrated_reading);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: calibrated_reading=%h",
                         expected_calibrated_reading);
                $display("  Got:      calibrated_reading=%h",
                         calibrated_reading);
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
