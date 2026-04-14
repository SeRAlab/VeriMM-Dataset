`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] count;
    wire led_0;
    wire led_1;
    wire led_2;
    wire led_3;
    wire led_4;
    wire led_5;
    wire led_6;
    wire led_7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .count(count),
        .led_0(led_0),
        .led_1(led_1),
        .led_2(led_2),
        .led_3(led_3),
        .led_4(led_4),
        .led_5(led_5),
        .led_6(led_6),
        .led_7(led_7)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All LEDs OFF (count = 0x00)", test_num);
            count = 8'h00;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All LEDs ON (count = 0xFF)", test_num);
            count = 8'hFF;
            #1;

            check_outputs(1, 1, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating pattern 1 (count = 0x55)", test_num);
            count = 8'b01010101;

            #1;


            check_outputs(1, 0, 1, 0, 1, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating pattern 2 (count = 0xAA)", test_num);
            count = 8'b10101010;

            #1;


            check_outputs(0, 1, 0, 1, 0, 1, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: LSB only (count = 0x01)", test_num);
            count = 8'h01;
            #1;

            check_outputs(1, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: MSB only (count = 0x80)", test_num);
            count = 8'h80;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Random pattern (count = 0xC3)", test_num);
            count = 8'b11000011;
            #1;

            check_outputs(1, 1, 0, 0, 0, 0, 1, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Middle bits (count = 0x3C)", test_num);
            count = 8'b00111100;
            #1;

            check_outputs(0, 0, 1, 1, 1, 1, 0, 0);
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
        testcase008();
        
        
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
        input expected_led_0;
        input expected_led_1;
        input expected_led_2;
        input expected_led_3;
        input expected_led_4;
        input expected_led_5;
        input expected_led_6;
        input expected_led_7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_led_0 === (expected_led_0 ^ led_0 ^ expected_led_0) &&
                expected_led_1 === (expected_led_1 ^ led_1 ^ expected_led_1) &&
                expected_led_2 === (expected_led_2 ^ led_2 ^ expected_led_2) &&
                expected_led_3 === (expected_led_3 ^ led_3 ^ expected_led_3) &&
                expected_led_4 === (expected_led_4 ^ led_4 ^ expected_led_4) &&
                expected_led_5 === (expected_led_5 ^ led_5 ^ expected_led_5) &&
                expected_led_6 === (expected_led_6 ^ led_6 ^ expected_led_6) &&
                expected_led_7 === (expected_led_7 ^ led_7 ^ expected_led_7)) begin
                $display("PASS");
                $display("  Outputs: led_0=%b, led_1=%b, led_2=%b, led_3=%b, led_4=%b, led_5=%b, led_6=%b, led_7=%b",
                         led_0, led_1, led_2, led_3, led_4, led_5, led_6, led_7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led_0=%b, led_1=%b, led_2=%b, led_3=%b, led_4=%b, led_5=%b, led_6=%b, led_7=%b",
                         expected_led_0, expected_led_1, expected_led_2, expected_led_3, expected_led_4, expected_led_5, expected_led_6, expected_led_7);
                $display("  Got:      led_0=%b, led_1=%b, led_2=%b, led_3=%b, led_4=%b, led_5=%b, led_6=%b, led_7=%b",
                         led_0, led_1, led_2, led_3, led_4, led_5, led_6, led_7);
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
