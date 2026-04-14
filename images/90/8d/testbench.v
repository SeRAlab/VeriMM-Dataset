`timescale 1ns/1ps

module alarm_system_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg resetn;
    reg trigger;
    wire alarm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alarm_system dut (
        .clk(clk),
        .resetn(resetn),
        .trigger(trigger),
        .alarm(alarm)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        resetn = 0;
        trigger = 0;
        @(posedge clk);
        #1;
        resetn = 1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset state check", test_num);
        reset_dut();
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Idle state (no trigger)", test_num);
        reset_dut();
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Trigger activation check", test_num);
        reset_dut();
        @(posedge clk);
        trigger = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Alarm latching check (trigger released)", test_num);
        reset_dut();
        @(posedge clk);
        trigger = 1;
        @(posedge clk);
        trigger = 0;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset from active state", test_num);
        reset_dut();

        trigger = 1;
        @(posedge clk);
        #1;

        resetn = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Multiple trigger pulses", test_num);
        reset_dut();
        trigger = 1;
        @(posedge clk);
        trigger = 0;
        @(posedge clk);
        trigger = 1;
        @(posedge clk);
        #1;
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
        $display("alarm_system Testbench");
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
        input expected_alarm;
        begin
            if (expected_alarm === (expected_alarm ^ alarm ^ expected_alarm)) begin
                $display("PASS");
                $display("  Outputs: alarm=%b",
                         alarm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alarm=%b",
                         expected_alarm);
                $display("  Got:      alarm=%b",
                         alarm);
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
        $dumpvars(0,clk, resetn, trigger, alarm);
    end

endmodule
