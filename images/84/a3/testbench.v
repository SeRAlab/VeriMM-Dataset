`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg key;
    reg rst;
    wire led;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .key(key),
        .rst(rst),
        .led(led)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Reset then set key High");

            rst = 1; key = 0; #20;
            rst = 0; #10;

            key = 1;
            #20;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Reset then set key Low");

            rst = 1; key = 1; #20;
            rst = 0; #10;

            key = 0;
            #20;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Rapid fluctuations (noise) ending High");

            rst = 1; key = 0; #20;
            rst = 0; #10;

            key = 1; #2;
            key = 0; #3;
            key = 1; #1;
            key = 0; #4;
            key = 1; #20;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Rapid fluctuations (noise) ending Low");

            rst = 1; key = 0; #20;
            rst = 0; #10;

            key = 1; #5;
            key = 0; #2;
            key = 1; #3;
            key = 0; #20;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Reset priority (Key high while Reset is active)");

            rst = 1; key = 1; #20;

            #1;


            check_outputs(1'b0);

            rst = 0; #10;
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
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_led === (expected_led ^ led ^ expected_led)) begin
                $display("PASS");
                $display("  Outputs: led=%b",
                         led);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led=%b",
                         expected_led);
                $display("  Got:      led=%b",
                         led);
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
