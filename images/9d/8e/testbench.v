`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg dtr;
    reg rts;
    reg rx;
    reg tx2;
    wire D1;
    wire D2;
    wire rx2;
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
        .tx2(tx2),
        .D1(D1),
        .D2(D2),
        .rx2(rx2),
        .tx(tx)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: All zeros");
            dtr = 0; rts = 0; rx = 0; tx2 = 0;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: All ones");
            dtr = 1; rts = 1; rx = 1; tx2 = 1;
            #1;

            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: DTR high only");
            dtr = 1; rts = 0; rx = 0; tx2 = 0;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: RTS high only");
            dtr = 0; rts = 1; rx = 0; tx2 = 0;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: RX high only");
            dtr = 0; rts = 0; rx = 1; tx2 = 0;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: TX2 high only");
            dtr = 0; rts = 0; rx = 0; tx2 = 1;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Alternate pattern A");
            dtr = 1; rts = 0; rx = 1; tx2 = 0;
            #1;

            check_outputs(1, 0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            $display("\nTestcase 008: Alternate pattern B");
            dtr = 0; rts = 1; rx = 0; tx2 = 1;
            #1;

            check_outputs(0, 1, 0, 1);
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
        input expected_rx2;
        input expected_tx;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D1 === (expected_D1 ^ D1 ^ expected_D1) &&
                expected_D2 === (expected_D2 ^ D2 ^ expected_D2) &&
                expected_rx2 === (expected_rx2 ^ rx2 ^ expected_rx2) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: D1=%b, D2=%b, rx2=%b, tx=%b",
                         D1, D2, rx2, tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D1=%b, D2=%b, rx2=%b, tx=%b",
                         expected_D1, expected_D2, expected_rx2, expected_tx);
                $display("  Got:      D1=%b, D2=%b, rx2=%b, tx=%b",
                         D1, D2, rx2, tx);
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
