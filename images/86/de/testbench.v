`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg reset;
    wire led;
    wire led2;
    wire led3;
    wire led4;
    wire led5;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .reset(reset),
        .led(led),
        .led2(led2),
        .led3(led3),
        .led4(led4),
        .led5(led5)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clock);
            #1 reset = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking initial reset state", test_num);
            reset_dut();
            #1;

            check_outputs(0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Checking LED5 (Bit 22) high after 4,194,304 cycles", test_num);
            reset_dut();
            repeat(4194304) @(posedge clock);
            #1;

            check_outputs(0, 0, 0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Checking LED4 (Bit 23) high after 8,388,608 cycles", test_num);
            reset_dut();
            repeat(8388608) @(posedge clock);
            #1;

            check_outputs(0, 0, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Checking LED1 (Bit 26) high after 67,108,864 cycles", test_num);
            reset_dut();
            repeat(67108864) @(posedge clock);
            #1;

            check_outputs(1, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Checking all LEDs (Bits 26-22) high", test_num);
            reset_dut();

            repeat(130023424) @(posedge clock);
            #1;

            check_outputs(1, 1, 1, 1, 1);
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
        input expected_led;
        input expected_led2;
        input expected_led3;
        input expected_led4;
        input expected_led5;
        begin
            if (expected_led === (expected_led ^ led ^ expected_led) &&
                expected_led2 === (expected_led2 ^ led2 ^ expected_led2) &&
                expected_led3 === (expected_led3 ^ led3 ^ expected_led3) &&
                expected_led4 === (expected_led4 ^ led4 ^ expected_led4) &&
                expected_led5 === (expected_led5 ^ led5 ^ expected_led5)) begin
                $display("PASS");
                $display("  Outputs: led=%b, led2=%b, led3=%b, led4=%b, led5=%b",
                         led, led2, led3, led4, led5);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led=%b, led2=%b, led3=%b, led4=%b, led5=%b",
                         expected_led, expected_led2, expected_led3, expected_led4, expected_led5);
                $display("  Got:      led=%b, led2=%b, led3=%b, led4=%b, led5=%b",
                         led, led2, led3, led4, led5);
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
        $dumpvars(0,clock, reset, led, led2, led3, led4, led5);
    end

endmodule
