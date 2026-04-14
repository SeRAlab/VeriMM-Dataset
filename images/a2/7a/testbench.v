`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg dtr;
    reg rts;
    reg rx;
    wire D1;
    wire D2;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dtr(dtr),
        .rts(rts),
        .rx(rx),
        .D1(D1),
        .D2(D2),
        .tx(tx)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: All inputs zero");
        dtr = 0;
        rts = 0;
        rx = 0;
        #1;

        check_outputs(0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Only rx high");
        dtr = 0;
        rts = 0;
        rx = 1;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Only rts high");
        dtr = 0;
        rts = 1;
        rx = 0;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Only dtr high");
        dtr = 1;
        rts = 0;
        rx = 0;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: rts and rx high");
        dtr = 0;
        rts = 1;
        rx = 1;
        #1;

        check_outputs(0, 1, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: dtr and rx high");
        dtr = 1;
        rts = 0;
        rx = 1;
        #1;

        check_outputs(1, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: dtr and rts high");
        dtr = 1;
        rts = 1;
        rx = 0;
        #1;

        check_outputs(1, 1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: All inputs high");
        dtr = 1;
        rts = 1;
        rx = 1;
        #1;

        check_outputs(1, 1, 1);
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
        input expected_D1;
        input expected_D2;
        input expected_tx;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D1 === (expected_D1 ^ D1 ^ expected_D1) &&
                expected_D2 === (expected_D2 ^ D2 ^ expected_D2) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: D1=%b, D2=%b, tx=%b",
                         D1, D2, tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D1=%b, D2=%b, tx=%b",
                         expected_D1, expected_D2, expected_tx);
                $display("  Got:      D1=%b, D2=%b, tx=%b",
                         D1, D2, tx);
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
