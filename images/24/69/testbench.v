`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] raw_temp;
    wire [4:0] calibrated_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .raw_temp(raw_temp),
        .calibrated_temp(calibrated_temp)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Minimum input (0)", test_num);
            raw_temp = 5'd0;
            #1;

            check_outputs(5'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Standard reading (10)", test_num);
            raw_temp = 5'd10;
            #1;

            check_outputs(5'd13);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Maximum reading before overflow (28)", test_num);
            raw_temp = 5'd28;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Overflow boundary - wrap to 0 (29)", test_num);
            raw_temp = 5'd29;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Overflow boundary - wrap to 1 (30)", test_num);
            raw_temp = 5'd30;
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Maximum possible input - wrap to 2 (31)", test_num);
            raw_temp = 5'd31;
            #1;

            check_outputs(5'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Mid-range value (15)", test_num);
            raw_temp = 5'd15;
            #1;

            check_outputs(5'd18);
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
        input [4:0] expected_calibrated_temp;
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
