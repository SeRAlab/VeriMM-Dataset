`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] control;
    reg temp_sensor_out;
    wire alarm;
    wire fan_control;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control(control),
        .temp_sensor_out(temp_sensor_out),
        .alarm(alarm),
        .fan_control(fan_control)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Low Temp, High Threshold", test_num);
        control = 4'b1111;
        temp_sensor_out = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: High Temp, Low Threshold", test_num);
        control = 4'b0001;
        temp_sensor_out = 1'b1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Low Temp, Low Threshold", test_num);
        control = 4'b0000;
        temp_sensor_out = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: High Temp, High Threshold", test_num);
        control = 4'b1111;
        temp_sensor_out = 1'b1;

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: High Temp, Mid Threshold", test_num);
        control = 4'b0111;
        temp_sensor_out = 1'b1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_alarm;
        input expected_fan_control;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alarm === (expected_alarm ^ alarm ^ expected_alarm) &&
                expected_fan_control === (expected_fan_control ^ fan_control ^ expected_fan_control)) begin
                $display("PASS");
                $display("  Outputs: alarm=%b, fan_control=%b",
                         alarm, fan_control);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alarm=%b, fan_control=%b",
                         expected_alarm, expected_fan_control);
                $display("  Got:      alarm=%b, fan_control=%b",
                         alarm, fan_control);
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
