`timescale 1ns/1ps

module DVFS_Controller_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] control_signal;
    wire [3:0] voltage_freq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DVFS_Controller dut (
        .control_signal(control_signal),
        .voltage_freq(voltage_freq)
    );
    task testcase001;

        begin
            $display("Test Case 001: Level 00 (0V, 0Hz)");
            control_signal = 2'b00;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Level 01 (1V, 1Hz)");
            control_signal = 2'b01;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Level 10 (2V, 2Hz)");
            control_signal = 2'b10;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Level 11 (3V, 3Hz)");
            control_signal = 2'b11;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Switching from High to Low Level");

            control_signal = 2'b11;
            #5;
            control_signal = 2'b00;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Rapid Level Switching (01 to 10)");
            control_signal = 2'b01;
            #2;
            control_signal = 2'b10;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DVFS_Controller Testbench");
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
        input [3:0] expected_voltage_freq;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_voltage_freq === (expected_voltage_freq ^ voltage_freq ^ expected_voltage_freq)) begin
                $display("PASS");
                $display("  Outputs: voltage_freq=%h",
                         voltage_freq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: voltage_freq=%h",
                         expected_voltage_freq);
                $display("  Got:      voltage_freq=%h",
                         voltage_freq);
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
