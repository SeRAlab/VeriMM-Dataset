`timescale 1ns/1ps

module DVFS_Controller_tb;

    // Testbench signals (combinational circuit)
    reg frequency_control;
    reg [2:0] voltage_level;
    wire clock_enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DVFS_Controller dut (
        .frequency_control(frequency_control),
        .voltage_level(voltage_level),
        .clock_enable(clock_enable)
    );
    task testcase001;

    begin
        test_num = 1;
        frequency_control = 1'b0;
        voltage_level = 3'b000;
        $display("Test %03d: Low Freq, Volt 0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        frequency_control = 1'b0;
        voltage_level = 3'b001;
        $display("Test %03d: Low Freq, Volt 1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        frequency_control = 1'b1;
        voltage_level = 3'b011;
        $display("Test %03d: High Freq, Volt 3 (Insufficient)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        frequency_control = 1'b1;
        voltage_level = 3'b100;
        $display("Test %03d: High Freq, Volt 4 (Sufficient)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        frequency_control = 1'b1;
        voltage_level = 3'b111;
        $display("Test %03d: High Freq, Volt 7", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        frequency_control = 1'b0;
        voltage_level = 3'b111;
        $display("Test %03d: Low Freq, Volt 7", test_num);
        #1;

        check_outputs(1'b1);
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
        input expected_clock_enable;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clock_enable === (expected_clock_enable ^ clock_enable ^ expected_clock_enable)) begin
                $display("PASS");
                $display("  Outputs: clock_enable=%b",
                         clock_enable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clock_enable=%b",
                         expected_clock_enable);
                $display("  Got:      clock_enable=%b",
                         clock_enable);
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
