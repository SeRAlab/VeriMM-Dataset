`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg avs_ctrl_address;
    reg avs_ctrl_read;
    reg avs_ctrl_write;
    reg [7:0] avs_ctrl_writedata;
    reg clk;
    reg [15:0] data;
    reg empty;
    reg endofpacket;
    reg reset;
    reg [15:0] rx_data;
    reg rx_empty;
    reg rx_mask;
    reg startofpacket;
    reg tx_full;
    reg valid;
    wire [7:0] avs_ctrl_readdata;
    wire ready;
    wire rx_read;
    wire [15:0] tx_data;
    wire [1:0] tx_mask;
    wire tx_write;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .avs_ctrl_address(avs_ctrl_address),
        .avs_ctrl_read(avs_ctrl_read),
        .avs_ctrl_write(avs_ctrl_write),
        .avs_ctrl_writedata(avs_ctrl_writedata),
        .clk(clk),
        .data(data),
        .empty(empty),
        .endofpacket(endofpacket),
        .reset(reset),
        .rx_data(rx_data),
        .rx_empty(rx_empty),
        .rx_mask(rx_mask),
        .startofpacket(startofpacket),
        .tx_full(tx_full),
        .valid(valid),
        .avs_ctrl_readdata(avs_ctrl_readdata),
        .ready(ready),
        .rx_read(rx_read),
        .tx_data(tx_data),
        .tx_mask(tx_mask),
        .tx_write(tx_write)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            avs_ctrl_address = 0;
            avs_ctrl_read = 0;
            avs_ctrl_write = 0;
            avs_ctrl_writedata = 0;
            data = 0;
            empty = 0;
            endofpacket = 0;
            rx_data = 0;
            rx_empty = 1;
            rx_mask = 0;
            startofpacket = 0;
            tx_full = 0;
            valid = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial State Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h0, 1'b1, 1'b0, 16'h0, 2'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Streaming Data Transmission", test_num);
            reset_dut();

            @(posedge clk);
            valid = 1;
            data = 16'hABCD;
            startofpacket = 1;
            tx_full = 0;

            @(posedge clk);

            #1;


            check_outputs(8'h0, 1'b1, 1'b0, 16'hABCD, 2'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Avalon Control Register Read", test_num);
            reset_dut();

            @(posedge clk);
            rx_empty = 0;
            avs_ctrl_address = 0;
            avs_ctrl_read = 1;

            @(posedge clk);


            #1;



            check_outputs(8'h01, 1'b1, 1'b0, 16'h0, 2'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: RX Handshake Mechanism", test_num);
            reset_dut();

            @(posedge clk);
            rx_empty = 0;
            rx_data = 16'h55AA;

            @(posedge clk);

            #1;


            check_outputs(8'h0, 1'b1, 1'b1, 16'h0, 2'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: End of Packet with Masking", test_num);
            reset_dut();

            @(posedge clk);
            valid = 1;
            data = 16'hFF00;
            endofpacket = 1;
            empty = 1;

            @(posedge clk);


            #1;



            check_outputs(8'h0, 1'b1, 1'b0, 16'hFF00, 2'b01, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: TX Full Backpressure", test_num);
            reset_dut();

            @(posedge clk);
            valid = 1;
            data = 16'h1234;
            tx_full = 1;

            @(posedge clk);

            #1;


            check_outputs(8'h0, 1'b0, 1'b0, 16'h1234, 2'b0, 1'b0);
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
        input [7:0] expected_avs_ctrl_readdata;
        input expected_ready;
        input expected_rx_read;
        input [15:0] expected_tx_data;
        input [1:0] expected_tx_mask;
        input expected_tx_write;
        begin
            if (expected_avs_ctrl_readdata === (expected_avs_ctrl_readdata ^ avs_ctrl_readdata ^ expected_avs_ctrl_readdata) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_rx_read === (expected_rx_read ^ rx_read ^ expected_rx_read) &&
                expected_tx_data === (expected_tx_data ^ tx_data ^ expected_tx_data) &&
                expected_tx_mask === (expected_tx_mask ^ tx_mask ^ expected_tx_mask) &&
                expected_tx_write === (expected_tx_write ^ tx_write ^ expected_tx_write)) begin
                $display("PASS");
                $display("  Outputs: avs_ctrl_readdata=%h, ready=%b, rx_read=%b, tx_data=%h, tx_mask=%h, tx_write=%b",
                         avs_ctrl_readdata, ready, rx_read, tx_data, tx_mask, tx_write);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: avs_ctrl_readdata=%h, ready=%b, rx_read=%b, tx_data=%h, tx_mask=%h, tx_write=%b",
                         expected_avs_ctrl_readdata, expected_ready, expected_rx_read, expected_tx_data, expected_tx_mask, expected_tx_write);
                $display("  Got:      avs_ctrl_readdata=%h, ready=%b, rx_read=%b, tx_data=%h, tx_mask=%h, tx_write=%b",
                         avs_ctrl_readdata, ready, rx_read, tx_data, tx_mask, tx_write);
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
        $dumpvars(0,avs_ctrl_address, avs_ctrl_read, avs_ctrl_write, avs_ctrl_writedata, clk, data, empty, endofpacket, reset, rx_data, rx_empty, rx_mask, startofpacket, tx_full, valid, avs_ctrl_readdata, ready, rx_read, tx_data, tx_mask, tx_write);
    end

endmodule
