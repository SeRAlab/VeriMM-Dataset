`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CS;
    reg MOSI;
    reg SCK;
    wire STORE;
    wire TMP;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CS(CS),
        .MOSI(MOSI),
        .SCK(SCK),
        .STORE(STORE),
        .TMP(TMP)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            CS = 1;
            SCK = 0;
            MOSI = 0;
            repeat(5) @(posedge CLK);
        end
        endtask
    task send_bit;

        input bit_val;
        begin
            MOSI = bit_val;
            repeat(2) @(posedge CLK);
            SCK = 1;
            repeat(2) @(posedge CLK);
            SCK = 0;
            repeat(2) @(posedge CLK);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            CS = 0;
            repeat(2) @(posedge CLK);
            send_bit(1);
            send_bit(1);
            send_bit(0);
            send_bit(1);
            CS = 1;
            repeat(5) @(posedge CLK);

            $display("Test Case 001: 4 bits [1101]");
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            CS = 0;
            repeat(2) @(posedge CLK);
            send_bit(1); send_bit(0);
            send_bit(1); send_bit(0);
            send_bit(1); send_bit(0);
            send_bit(1); send_bit(0);
            CS = 1;
            repeat(5) @(posedge CLK);

            $display("Test Case 002: 8 bits [10101010]");
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            CS = 0;
            repeat(2) @(posedge CLK);
            send_bit(1);
            CS = 1;
            repeat(5) @(posedge CLK);

            $display("Test Case 003: 1 bit [1]");
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            CS = 0;
            repeat(2) @(posedge CLK);
            send_bit(0); send_bit(0); send_bit(0); send_bit(0); send_bit(0);
            CS = 1;
            repeat(5) @(posedge CLK);

            $display("Test Case 004: 5 bits [00000]");
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            CS = 0;
            repeat(2) @(posedge CLK);
            CS = 1;
            repeat(5) @(posedge CLK);

            $display("Test Case 005: Empty message");
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_STORE;
        input expected_TMP;
        begin
            if (expected_STORE === (expected_STORE ^ STORE ^ expected_STORE) &&
                expected_TMP === (expected_TMP ^ TMP ^ expected_TMP)) begin
                $display("PASS");
                $display("  Outputs: STORE=%b, TMP=%b",
                         STORE, TMP);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: STORE=%b, TMP=%b",
                         expected_STORE, expected_TMP);
                $display("  Got:      STORE=%b, TMP=%b",
                         STORE, TMP);
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
        $dumpvars(0,CLK, CS, MOSI, SCK, STORE, TMP);
    end

endmodule
