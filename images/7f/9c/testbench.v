`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg reset_alarm;
    reg trigger_alarm;
    wire alarm_on;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk(clk),
        .reset_alarm(reset_alarm),
        .trigger_alarm(trigger_alarm),
        .alarm_on(alarm_on)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            trigger_alarm = 0;
            reset_alarm = 0;
            #12;
            areset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Initial State after Reset", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Off -> On Transition", test_num);
            reset_dut();
            @(posedge clk);
            trigger_alarm = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: On -> Off Transition", test_num);
            reset_dut();

            @(posedge clk);
            trigger_alarm = 1;
            @(posedge clk);

            trigger_alarm = 0;
            reset_alarm = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Maintain Alarm_Off", test_num);
            reset_dut();
            trigger_alarm = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Maintain Alarm_On", test_num);
            reset_dut();

            trigger_alarm = 1;
            @(posedge clk);

            trigger_alarm = 0;
            reset_alarm = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Async Reset during Alarm_On", test_num);
            reset_dut();

            trigger_alarm = 1;
            @(posedge clk);
            #1;

            areset = 1;
            #2;
            #1;

            check_outputs(0);
            areset = 0;
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
        input expected_alarm_on;
        begin
            if (expected_alarm_on === (expected_alarm_on ^ alarm_on ^ expected_alarm_on)) begin
                $display("PASS");
                $display("  Outputs: alarm_on=%b",
                         alarm_on);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alarm_on=%b",
                         expected_alarm_on);
                $display("  Got:      alarm_on=%b",
                         alarm_on);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,areset, clk, reset_alarm, trigger_alarm, alarm_on);
    end

endmodule
