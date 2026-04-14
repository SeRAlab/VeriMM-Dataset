`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg reset;
    reg [99:0] rx_packet;
    wire [31:0] data_out;
    wire tx_busy;
    wire [99:0] tx_packet;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .rx_packet(rx_packet),
        .data_out(data_out),
        .tx_busy(tx_busy),
        .tx_packet(tx_packet)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 0;
            rx_packet = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        reg [31:0] tx_val;
        reg [31:0] rx_val;
        begin
            $display("\n--- Testcase 001: Valid Tx/Rx ---");
            test_num = test_num + 1;
            reset_dut();

            tx_val = 32'hA5A5B6B6;
            rx_val = 32'h12345678;

            data_in = tx_val;
            rx_packet = build_packet(rx_val);


            repeat(2) @(posedge clk);

            #1;


            check_outputs(rx_val, 1'b1, build_packet(tx_val));
        end
        endtask

    task testcase002;

        reg [31:0] tx_val;
        reg [99:0] corrupt_rx;
        begin
            $display("\n--- Testcase 002: Invalid Rx Checksum ---");
            test_num = test_num + 1;
            reset_dut();

            tx_val = 32'hFFFFFFFF;

            corrupt_rx = {32'hDEADBEEF, 32'h0, 32'hFFFFFFFF, 4'b0};

            data_in = tx_val;
            rx_packet = corrupt_rx;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(32'h0, 1'b1, build_packet(tx_val));
        end
        endtask

    task testcase003;

        reg [31:0] tx_val;
        reg [31:0] rx_val;
        begin
            $display("\n--- Testcase 003: All Zeros Data ---");
            test_num = test_num + 1;
            reset_dut();

            tx_val = 32'h00000000;
            rx_val = 32'hFFFFFFFF;

            data_in = tx_val;
            rx_packet = build_packet(rx_val);

            repeat(2) @(posedge clk);

            #1;


            check_outputs(rx_val, 1'b1, build_packet(tx_val));
        end
        endtask

    task testcase004;

        begin
            $display("\n--- Testcase 004: Reset mid-operation ---");
            test_num = test_num + 1;
            reset_dut();

            data_in = 32'h1234ABCD;
            rx_packet = build_packet(32'h87654321);
            @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);



            #1;




            check_outputs(32'h0, 1'b0, 100'h0);
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
        input [31:0] expected_data_out;
        input expected_tx_busy;
        input [99:0] expected_tx_packet;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_tx_busy === (expected_tx_busy ^ tx_busy ^ expected_tx_busy) &&
                expected_tx_packet === (expected_tx_packet ^ tx_packet ^ expected_tx_packet)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, tx_busy=%b, tx_packet=%h",
                         data_out, tx_busy, tx_packet);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, tx_busy=%b, tx_packet=%h",
                         expected_data_out, expected_tx_busy, expected_tx_packet);
                $display("  Got:      data_out=%h, tx_busy=%b, tx_packet=%h",
                         data_out, tx_busy, tx_packet);
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
        $dumpvars(0,clk, data_in, reset, rx_packet, data_out, tx_busy, tx_packet);
    end

endmodule
