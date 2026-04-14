`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg temp;
    wire fan_speed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .temp(temp),
        .fan_speed(fan_speed)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Temperature below minimum (15°C)", test_num);
        temp = 8'd15;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Temperature at minimum (20°C)", test_num);
        temp = 8'd20;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Temperature at maximum (80°C)", test_num);
        temp = 8'd80;
        #1;

        check_outputs(8'd100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Temperature above maximum (95°C)", test_num);
        temp = 8'd95;
        #1;

        check_outputs(8'd100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Temperature at midpoint (50°C)", test_num);
        temp = 8'd50;
        #1;

        check_outputs(8'd50);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Temperature at 25%% range (35°C)", test_num);
        temp = 8'd35;
        #1;

        check_outputs(8'd25);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Temperature at 75%% range (65°C)", test_num);
        temp = 8'd65;
        #1;

        check_outputs(8'd75);
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
        input expected_fan_speed;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_fan_speed === (expected_fan_speed ^ fan_speed ^ expected_fan_speed)) begin
                $display("PASS");
                $display("  Outputs: fan_speed=%b",
                         fan_speed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fan_speed=%b",
                         expected_fan_speed);
                $display("  Got:      fan_speed=%b",
                         fan_speed);
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
