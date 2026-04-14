`timescale 1ns/1ps

module thermal_sensor_calibration_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] temperature_input;
    wire [9:0] calibrated_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    thermal_sensor_calibration dut (
        .temperature_input(temperature_input),
        .calibrated_output(calibrated_output)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Minimum Input (0)", test_num);
        temperature_input = 10'd0;
        #1;

        check_outputs(10'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Typical Value (25)", test_num);
        temperature_input = 10'd25;
        #1;

        check_outputs(10'd30);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Mid-scale Value (512)", test_num);
        temperature_input = 10'd512;
        #1;

        check_outputs(10'd517);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Near Max Value (1018)", test_num);
        temperature_input = 10'd1018;
        #1;

        check_outputs(10'd1023);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Maximum Input (1023) - Wrap around", test_num);
        temperature_input = 10'd1023;
        #1;

        check_outputs(10'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Random Value (777)", test_num);
        temperature_input = 10'd777;
        #1;

        check_outputs(10'd782);
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
        input [9:0] expected_calibrated_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_calibrated_output === (expected_calibrated_output ^ calibrated_output ^ expected_calibrated_output)) begin
                $display("PASS");
                $display("  Outputs: calibrated_output=%h",
                         calibrated_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: calibrated_output=%h",
                         expected_calibrated_output);
                $display("  Got:      calibrated_output=%h",
                         calibrated_output);
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
