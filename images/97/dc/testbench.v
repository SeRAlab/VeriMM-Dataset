`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg rx;
    reg s_tick;
    wire [7:0] dout;
    wire rx_done_tick;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .s_tick(s_tick),
        .dout(dout),
        .rx_done_tick(rx_done_tick)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            rx = 1;
            s_tick = 0;
            rx_done_captured = 0;
            repeat (5) @(posedge clk);
            reset = 0;
            repeat (5) @(posedge clk);
        end
        endtask
    task send_bit;

        input bit_val;
        integer k;
        begin
            rx = bit_val;
            for (k = 0; k < 16; k = k + 1) begin
                @(posedge clk);
                s_tick = 1;
                @(posedge clk);
                s_tick = 0;
                repeat (7) @(posedge clk);
            end
        end
        endtask

    task send_uart_byte;

        input [7:0] data;
        integer j;
        begin

            send_bit(0);

            for (j = 0; j < 8; j = j + 1) begin
                send_bit(data[j]);
            end

            send_bit(1);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case 001: Sending 0x55");
            send_uart_byte(8'h55);

            repeat (10) @(posedge clk);
            #1;

            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test Case 002: Sending 0xAA");
            send_uart_byte(8'hAA);
            repeat (10) @(posedge clk);
            #1;

            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test Case 003: Sending 0x00");
            send_uart_byte(8'h00);
            repeat (10) @(posedge clk);
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test Case 004: Sending 0xFF");
            send_uart_byte(8'hFF);
            repeat (10) @(posedge clk);
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test Case 005: Sending 0x3C");
            send_uart_byte(8'h3C);
            repeat (10) @(posedge clk);
            #1;

            check_outputs(8'h3C, 1'b1);
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
        input [7:0] expected_dout;
        input expected_rx_done_tick;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_rx_done_tick === (expected_rx_done_tick ^ rx_done_tick ^ expected_rx_done_tick)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, rx_done_tick=%b",
                         dout, rx_done_tick);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, rx_done_tick=%b",
                         expected_dout, expected_rx_done_tick);
                $display("  Got:      dout=%h, rx_done_tick=%b",
                         dout, rx_done_tick);
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
        $dumpvars(0,clk, reset, rx, s_tick, dout, rx_done_tick);
    end

endmodule
