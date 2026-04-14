`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg hwclk;
    wire led1;
    wire led2;
    wire led3;
    wire led4;
    wire led5;
    wire led6;
    wire led7;
    wire led8;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hwclk(hwclk),
        .led1(led1),
        .led2(led2),
        .led3(led3),
        .led4(led4),
        .led5(led5),
        .led6(led6),
        .led7(led7),
        .led8(led8)
    );

    // Clock generation (10ns period)
    initial begin
        hwclk = 0;
        forever #5 hwclk = ~hwclk;
    end

        task reset_dut;

        begin
            $display("--- Resetting Test Sequence ---");


            if ($time == 0) begin
                current_count = 0;
            end
            @(posedge hwclk);
            #1;
        end
        endtask
    task advance_to_count;

        input [31:0] target;
        begin
            if (target > current_count) begin
                repeat (target - current_count) @(posedge hwclk);
                current_count = target;
            end
            #1;
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Initial state", test_num);
            advance_to_count(0);
            #1;

            check_outputs(0,0,0,0,0,0,0,0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Check count 131,071 (2^17 - 1)", test_num);
            advance_to_count(131071);
            #1;

            check_outputs(0,0,0,0,0,0,0,0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Check count 131,072 (2^17)", test_num);
            advance_to_count(131072);
            #1;

            check_outputs(1,0,0,0,0,0,0,0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Check count 262,144 (2^18)", test_num);
            advance_to_count(262144);
            #1;

            check_outputs(0,1,0,0,0,0,0,0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Check count 393,216 (led1 and led2)", test_num);
            advance_to_count(393216);
            #1;

            check_outputs(1,1,0,0,0,0,0,0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Check count 16,777,216 (2^24)", test_num);
            advance_to_count(16777216);
            #1;

            check_outputs(0,0,0,0,0,0,0,1);
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
        input expected_led1;
        input expected_led2;
        input expected_led3;
        input expected_led4;
        input expected_led5;
        input expected_led6;
        input expected_led7;
        input expected_led8;
        begin
            if (expected_led1 === (expected_led1 ^ led1 ^ expected_led1) &&
                expected_led2 === (expected_led2 ^ led2 ^ expected_led2) &&
                expected_led3 === (expected_led3 ^ led3 ^ expected_led3) &&
                expected_led4 === (expected_led4 ^ led4 ^ expected_led4) &&
                expected_led5 === (expected_led5 ^ led5 ^ expected_led5) &&
                expected_led6 === (expected_led6 ^ led6 ^ expected_led6) &&
                expected_led7 === (expected_led7 ^ led7 ^ expected_led7) &&
                expected_led8 === (expected_led8 ^ led8 ^ expected_led8)) begin
                $display("PASS");
                $display("  Outputs: led1=%b, led2=%b, led3=%b, led4=%b, led5=%b, led6=%b, led7=%b, led8=%b",
                         led1, led2, led3, led4, led5, led6, led7, led8);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led1=%b, led2=%b, led3=%b, led4=%b, led5=%b, led6=%b, led7=%b, led8=%b",
                         expected_led1, expected_led2, expected_led3, expected_led4, expected_led5, expected_led6, expected_led7, expected_led8);
                $display("  Got:      led1=%b, led2=%b, led3=%b, led4=%b, led5=%b, led6=%b, led7=%b, led8=%b",
                         led1, led2, led3, led4, led5, led6, led7, led8);
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
        $dumpvars(0,hwclk, led1, led2, led3, led4, led5, led6, led7, led8);
    end

endmodule
