`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg fan_ctrl_signal;
    reg temp_signal;
    wire fan_feedback_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .fan_ctrl_signal(fan_ctrl_signal),
        .temp_signal(temp_signal),
        .fan_feedback_signal(fan_feedback_signal)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("testcase001: Temperature below 30 (Low Temp)");
        temp_signal = 8'd20;
        fan_ctrl_signal = 1'b1;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("testcase002: Temperature in safe range (Safe Temp, Ctrl High)");
        temp_signal = 8'd50;
        fan_ctrl_signal = 1'b1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("testcase003: Temperature in safe range (Safe Temp, Ctrl Low)");
        temp_signal = 8'd50;
        fan_ctrl_signal = 1'b0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("testcase004: Temperature above 70 (High Temp)");
        temp_signal = 8'd85;
        fan_ctrl_signal = 1'b0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("testcase005: Boundary condition at 30 degrees");
        temp_signal = 8'd30;
        fan_ctrl_signal = 1'b1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("testcase006: Boundary condition at 70 degrees");
        temp_signal = 8'd70;
        fan_ctrl_signal = 1'b0;
        #10;
        #1;

        check_outputs(1'b0);
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
        input expected_fan_feedback_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_fan_feedback_signal === (expected_fan_feedback_signal ^ fan_feedback_signal ^ expected_fan_feedback_signal)) begin
                $display("PASS");
                $display("  Outputs: fan_feedback_signal=%b",
                         fan_feedback_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fan_feedback_signal=%b",
                         expected_fan_feedback_signal);
                $display("  Got:      fan_feedback_signal=%b",
                         fan_feedback_signal);
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
