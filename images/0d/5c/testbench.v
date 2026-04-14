`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] sensor_reading;
    wire [4:0] calibrated_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .sensor_reading(sensor_reading),
        .calibrated_value(calibrated_value)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Minimum sensor reading", test_num);
            sensor_reading = 5'd0;

            #1;


            check_outputs(5'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mid-range sensor reading", test_num);
            sensor_reading = 5'd10;

            #1;


            check_outputs(5'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum reading before overflow", test_num);
            sensor_reading = 5'd26;

            #1;


            check_outputs(5'd31);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Overflow boundary (Wrap to 0)", test_num);
            sensor_reading = 5'd27;

            #1;


            check_outputs(5'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Overflow boundary (Wrap to 1)", test_num);
            sensor_reading = 5'd28;

            #1;


            check_outputs(5'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum possible input reading", test_num);
            sensor_reading = 5'd31;

            #1;


            check_outputs(5'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Prime number reading", test_num);
            sensor_reading = 5'd17;

            #1;


            check_outputs(5'd22);
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
        input [4:0] expected_calibrated_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_calibrated_value === (expected_calibrated_value ^ calibrated_value ^ expected_calibrated_value)) begin
                $display("PASS");
                $display("  Outputs: calibrated_value=%h",
                         calibrated_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: calibrated_value=%h",
                         expected_calibrated_value);
                $display("  Got:      calibrated_value=%h",
                         calibrated_value);
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
