`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] raw_temperature;
    wire [4:0] calibrated_temperature;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .raw_temperature(raw_temperature),
        .calibrated_temperature(calibrated_temperature)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Lower bound raw temperature (0)", test_num);
            raw_temperature = 5'd0;
            #1;

            check_outputs(5'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Mid-low raw temperature (5)", test_num);
            raw_temperature = 5'd5;
            #1;

            check_outputs(5'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Boundary check (10)", test_num);
            raw_temperature = 5'd10;
            #1;

            check_outputs(5'd13);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Start of second range (11)", test_num);
            raw_temperature = 5'd11;
            #1;

            check_outputs(5'd12);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Mid-range temperature (15)", test_num);
            raw_temperature = 5'd15;
            #1;

            check_outputs(5'd16);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Boundary check (20)", test_num);
            raw_temperature = 5'd20;
            #1;

            check_outputs(5'd21);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Start of third range (21)", test_num);
            raw_temperature = 5'd21;
            #1;

            check_outputs(5'd19);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: High range temperature (26)", test_num);
            raw_temperature = 5'd26;
            #1;

            check_outputs(5'd24);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Upper bound raw temperature (31)", test_num);
            raw_temperature = 5'd31;
            #1;

            check_outputs(5'd29);
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
        input [4:0] expected_calibrated_temperature;
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
