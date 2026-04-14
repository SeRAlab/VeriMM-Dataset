`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rx;
    wire [7:0] data_out;
    wire rx_valid;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rx(rx),
        .data_out(data_out),
        .rx_valid(rx_valid),
        .tx(tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rx = 1;
            data_in = 8'h00;
            @(posedge clk);
            @(posedge clk);
        end
        endtask
    task send_uart_frame;

        input [7:0] data;
        input parity;
        integer i;
        begin

            rx = 0;
            @(posedge clk);


            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                @(posedge clk);
            end


            rx = parity;
            @(posedge clk);


            rx = 1;
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            $display("Test Case 001: Receive 0x00, Parity 0 (Valid)");
            reset_dut();

            send_uart_frame(8'h00, 1'b0);
            #1;

            check_outputs(8'h00, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Receive 0xAA, Parity 0 (Valid)");
            reset_dut();

            send_uart_frame(8'hAA, 1'b0);
            #1;

            check_outputs(8'hAA, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Receive 0x07, Parity 1 (Valid)");
            reset_dut();

            send_uart_frame(8'h07, 1'b1);
            #1;

            check_outputs(8'h07, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Receive 0x07, Parity 0 (Invalid)");
            reset_dut();

            send_uart_frame(8'h07, 1'b0);

            #1;


            check_outputs(8'h07, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Receive 0xFF, Parity 0 (Valid)");
            reset_dut();

            send_uart_frame(8'hFF, 1'b0);
            #1;

            check_outputs(8'hFF, 1'b1, 1'b1);
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
        input [7:0] expected_data_out;
        input expected_rx_valid;
        input expected_tx;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_rx_valid === (expected_rx_valid ^ rx_valid ^ expected_rx_valid) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, rx_valid=%b, tx=%b",
                         data_out, rx_valid, tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, rx_valid=%b, tx=%b",
                         expected_data_out, expected_rx_valid, expected_tx);
                $display("  Got:      data_out=%h, rx_valid=%b, tx=%b",
                         data_out, rx_valid, tx);
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
        $dumpvars(0,clk, data_in, rx, data_out, rx_valid, tx);
    end

endmodule
