`timescale 1ns/1ps

module uart_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg rx;
    reg [7:0] tx_data;
    reg tx_start;
    wire [7:0] rx_data;
    wire rx_ready;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_controller dut (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .rx_data(rx_data),
        .rx_ready(rx_ready),
        .tx(tx)
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
            tx_data = 8'h0;
            tx_start = 0;
            #20;
            reset = 0;
            #20;
        end
        endtask
    task send_serial_byte;

        input [7:0] data;
        integer i;
        begin

            rx = 0;
            #(BIT_PERIOD);

            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                #(BIT_PERIOD);
            end

            rx = 1;
            #(BIT_PERIOD);

            #(BIT_PERIOD);
        end
        endtask

    task testcase001;

        begin
            $display("Running Testcase 001: Receive 0x55");
            reset_dut();
            send_serial_byte(8'h55);
            #1;

            check_outputs(8'h55, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Receive 0xAA");
            reset_dut();
            send_serial_byte(8'hAA);
            #1;

            check_outputs(8'hAA, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Receive 0xFF");
            reset_dut();
            send_serial_byte(8'hFF);
            #1;

            check_outputs(8'hFF, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Receive 0x00");
            reset_dut();
            send_serial_byte(8'h00);
            #1;

            check_outputs(8'h00, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Transmit Start/Idle Check");
            reset_dut();
            tx_data = 8'h3C;
            tx_start = 1;
            #10;
            tx_start = 0;

            #(BIT_PERIOD * 11);
            #1;

            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("uart_controller Testbench");
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
        input [7:0] expected_rx_data;
        input expected_rx_ready;
        input expected_tx;
        begin
            if (expected_rx_data === (expected_rx_data ^ rx_data ^ expected_rx_data) &&
                expected_rx_ready === (expected_rx_ready ^ rx_ready ^ expected_rx_ready) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: rx_data=%h, rx_ready=%b, tx=%b",
                         rx_data, rx_ready, tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rx_data=%h, rx_ready=%b, tx=%b",
                         expected_rx_data, expected_rx_ready, expected_tx);
                $display("  Got:      rx_data=%h, rx_ready=%b, tx=%b",
                         rx_data, rx_ready, tx);
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
        $dumpvars(0,clk, reset, rx, tx_data, tx_start, rx_data, rx_ready, tx);
    end

endmodule
