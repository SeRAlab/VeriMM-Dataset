`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg rx;
    reg rx_valid;
    reg tx_ack;
    reg tx_ready;
    wire rx_ack;
    wire rx_ready;
    wire tx;
    wire tx_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .rx_valid(rx_valid),
        .tx_ack(tx_ack),
        .tx_ready(tx_ready),
        .rx_ack(rx_ack),
        .rx_ready(rx_ready),
        .tx(tx),
        .tx_valid(tx_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        rx = 0;
        rx_valid = 0;
        tx_ready = 0;
        tx_ack = 0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("\nTestcase 001: Initial State Check");
        reset_dut();

        #1;


        check_outputs(0, 1, 1'bx, 0);
    end
        endtask

    task testcase002;

    begin
        $display("\nTestcase 002: Single Data Reception");
        reset_dut();
        rx = 1;
        rx_valid = 1;
        @(posedge clk);
        rx_valid = 0;

        #1;


        check_outputs(1, 1, 1, 1);
    end
        endtask

    task testcase003;

    integer i;
    begin
        $display("\nTestcase 003: Fill Buffer (16 units)");
        reset_dut();
        for(i = 0; i < 16; i = i + 1) begin
            rx = i[0];
            rx_valid = 1;
            @(posedge clk);
        end
        rx_valid = 0;

        #1;


        check_outputs(1, 0, 0, 1);
    end
        endtask

    task testcase004;

    integer i;
    begin
        $display("\nTestcase 004: Buffer Overflow Prevention");
        reset_dut();

        for(i = 0; i < 16; i = i + 1) begin
            rx = 1;
            rx_valid = 1;
            @(posedge clk);
        end

        rx = 0;
        rx_valid = 1;
        @(posedge clk);
        rx_valid = 0;

        #1;


        check_outputs(0, 0, 1, 1);
    end
        endtask

    task testcase005;

    begin
        $display("\nTestcase 005: Transmit Data (Read)");
        reset_dut();

        rx = 1;
        rx_valid = 1;
        @(posedge clk);
        rx_valid = 0;

        tx_ready = 1;
        @(posedge clk);
        tx_ack = 1;
        @(posedge clk);
        tx_ready = 0;
        tx_ack = 0;

        #1;


        check_outputs(0, 1, 1'bx, 0);
    end
        endtask

    task testcase006;

    begin
        $display("\nTestcase 006: Simultaneous RX and TX");
        reset_dut();

        rx = 1;
        rx_valid = 1;
        @(posedge clk);


        rx = 0;
        rx_valid = 1;
        tx_ready = 1;
        @(posedge clk);

        rx_valid = 0;
        tx_ready = 0;

        #1;


        check_outputs(1, 1, 0, 1);
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
        input expected_rx_ack;
        input expected_rx_ready;
        input expected_tx;
        input expected_tx_valid;
        begin
            if (expected_rx_ack === (expected_rx_ack ^ rx_ack ^ expected_rx_ack) &&
                expected_rx_ready === (expected_rx_ready ^ rx_ready ^ expected_rx_ready) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx) &&
                expected_tx_valid === (expected_tx_valid ^ tx_valid ^ expected_tx_valid)) begin
                $display("PASS");
                $display("  Outputs: rx_ack=%b, rx_ready=%b, tx=%b, tx_valid=%b",
                         rx_ack, rx_ready, tx, tx_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rx_ack=%b, rx_ready=%b, tx=%b, tx_valid=%b",
                         expected_rx_ack, expected_rx_ready, expected_tx, expected_tx_valid);
                $display("  Got:      rx_ack=%b, rx_ready=%b, tx=%b, tx_valid=%b",
                         rx_ack, rx_ready, tx, tx_valid);
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
        $dumpvars(0,clk, rst, rx, rx_valid, tx_ack, tx_ready, rx_ack, rx_ready, tx, tx_valid);
    end

endmodule
