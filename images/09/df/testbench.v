`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] raw_data;
    wire [3:0] calibrated_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .raw_data(raw_data),
        .calibrated_data(calibrated_data)
    );
    task testcase001;

        begin
            test_num = 1;
            raw_data = 4'd0;
            $display("Testcase %03d: raw_data = 0 (Expect 3)", test_num);
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            raw_data = 4'd5;
            $display("Testcase %03d: raw_data = 5 (Expect 8)", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            raw_data = 4'd12;
            $display("Testcase %03d: raw_data = 12 (Expect 15)", test_num);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            raw_data = 4'd13;
            $display("Testcase %03d: raw_data = 13 (Expect 15 saturation)", test_num);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            raw_data = 4'd15;
            $display("Testcase %03d: raw_data = 15 (Expect 15 saturation)", test_num);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            raw_data = 4'd8;
            $display("Testcase %03d: raw_data = 8 (Expect 11)", test_num);
            #1;

            check_outputs(4'd11);
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
        input [3:0] expected_calibrated_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_calibrated_data === (expected_calibrated_data ^ calibrated_data ^ expected_calibrated_data)) begin
                $display("PASS");
                $display("  Outputs: calibrated_data=%h",
                         calibrated_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: calibrated_data=%h",
                         expected_calibrated_data);
                $display("  Got:      calibrated_data=%h",
                         calibrated_data);
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
