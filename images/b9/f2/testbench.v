`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg alarm;
    reg blink;
    reg sw0;
    reg sw1;
    reg sw2;
    reg sw3;
    reg sw4;
    wire led0;
    wire led1;
    wire led2;
    wire led3;
    wire led4;
    wire led7;
    wire led9;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alarm(alarm),
        .blink(blink),
        .sw0(sw0),
        .sw1(sw1),
        .sw2(sw2),
        .sw3(sw3),
        .sw4(sw4),
        .led0(led0),
        .led1(led1),
        .led2(led2),
        .led3(led3),
        .led4(led4),
        .led7(led7),
        .led9(led9)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All inputs zero", test_num);
        sw0 = 0; sw1 = 0; sw2 = 0; sw3 = 0; sw4 = 0;
        blink = 0;
        alarm = 0;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Switches check, blink/alarm off", test_num);
        sw0 = 1; sw1 = 0; sw2 = 1; sw3 = 0; sw4 = 1;
        blink = 0;
        alarm = 0;
        #1;

        check_outputs(1, 0, 1, 0, 1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Blink ON, Alarm OFF (led7 should be 0)", test_num);
        sw0 = 0; sw1 = 0; sw2 = 0; sw3 = 0; sw4 = 0;
        blink = 1;
        alarm = 0;
        #1;

        check_outputs(0, 0, 0, 0, 0, 0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Blink ON, Alarm ON (led7 should be 1)", test_num);
        sw0 = 0; sw1 = 0; sw2 = 0; sw3 = 0; sw4 = 0;
        blink = 1;
        alarm = 1;
        #1;

        check_outputs(0, 0, 0, 0, 0, 1, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: All switches ON, Blink OFF, Alarm ON (led7 should be 0)", test_num);
        sw0 = 1; sw1 = 1; sw2 = 1; sw3 = 1; sw4 = 1;
        blink = 0;
        alarm = 1;
        #1;

        check_outputs(1, 1, 1, 1, 1, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Mixed inputs check", test_num);
        sw0 = 0; sw1 = 1; sw2 = 0; sw3 = 1; sw4 = 0;
        blink = 1;
        alarm = 1;
        #1;

        check_outputs(0, 1, 0, 1, 0, 1, 1);
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
        input expected_led0;
        input expected_led1;
        input expected_led2;
        input expected_led3;
        input expected_led4;
        input expected_led7;
        input expected_led9;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_led0 === (expected_led0 ^ led0 ^ expected_led0) &&
                expected_led1 === (expected_led1 ^ led1 ^ expected_led1) &&
                expected_led2 === (expected_led2 ^ led2 ^ expected_led2) &&
                expected_led3 === (expected_led3 ^ led3 ^ expected_led3) &&
                expected_led4 === (expected_led4 ^ led4 ^ expected_led4) &&
                expected_led7 === (expected_led7 ^ led7 ^ expected_led7) &&
                expected_led9 === (expected_led9 ^ led9 ^ expected_led9)) begin
                $display("PASS");
                $display("  Outputs: led0=%b, led1=%b, led2=%b, led3=%b, led4=%b, led7=%b, led9=%b",
                         led0, led1, led2, led3, led4, led7, led9);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led0=%b, led1=%b, led2=%b, led3=%b, led4=%b, led7=%b, led9=%b",
                         expected_led0, expected_led1, expected_led2, expected_led3, expected_led4, expected_led7, expected_led9);
                $display("  Got:      led0=%b, led1=%b, led2=%b, led3=%b, led4=%b, led7=%b, led9=%b",
                         led0, led1, led2, led3, led4, led7, led9);
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
