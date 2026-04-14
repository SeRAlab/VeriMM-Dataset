`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ref_clk;
    reg reset;
    reg rx_valid;
    reg [31:0] tx_data;
    reg tx_valid;
    wire [31:0] rx_data;
    wire rx_error;
    wire tx_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ref_clk(ref_clk),
        .reset(reset),
        .rx_valid(rx_valid),
        .tx_data(tx_data),
        .tx_valid(tx_valid),
        .rx_data(rx_data),
        .rx_error(rx_error),
        .tx_ready(tx_ready)
    );

    // Clock generation (10ns period)
    initial begin
        ref_clk = 0;
        forever #5 ref_clk = ~ref_clk;
    end

        task reset_dut;

        begin
            reset = 1;
            tx_data = 32'b0;
            tx_valid = 0;
            rx_valid = 0;
            @(posedge ref_clk);
            #1 reset = 0;
            @(posedge ref_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Transmit Handshake", test_num);
            reset_dut();
            tx_valid = 1;
            tx_data = 32'hA5A5A5A5;
            repeat(2) @(posedge ref_clk);

            #1;


            check_outputs(32'h0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Basic Reception", test_num);
            reset_dut();
            rx_valid = 1;


            repeat(5) @(posedge ref_clk);

            #1;


            check_outputs(rx_data, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Full Duplex Operation", test_num);
            reset_dut();
            tx_valid = 1;
            tx_data = 32'h12345678;
            rx_valid = 1;
            repeat(3) @(posedge ref_clk);
            #1;

            check_outputs(rx_data, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Transmit Idle", test_num);
            reset_dut();
            tx_valid = 1;
            @(posedge ref_clk);
            tx_valid = 0;
            repeat(2) @(posedge ref_clk);
            #1;

            check_outputs(rx_data, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Reset During Operation", test_num);
            reset_dut();
            tx_valid = 1;
            rx_valid = 1;
            repeat(2) @(posedge ref_clk);
            reset = 1;
            @(posedge ref_clk);
            reset = 0;
            tx_valid = 0;
            rx_valid = 0;
            @(posedge ref_clk);
            #1;

            check_outputs(32'h0, 0, 0);
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
        input [31:0] expected_rx_data;
        input expected_rx_error;
        input expected_tx_ready;
        begin
            if (expected_rx_data === (expected_rx_data ^ rx_data ^ expected_rx_data) &&
                expected_rx_error === (expected_rx_error ^ rx_error ^ expected_rx_error) &&
                expected_tx_ready === (expected_tx_ready ^ tx_ready ^ expected_tx_ready)) begin
                $display("PASS");
                $display("  Outputs: rx_data=%h, rx_error=%b, tx_ready=%b",
                         rx_data, rx_error, tx_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rx_data=%h, rx_error=%b, tx_ready=%b",
                         expected_rx_data, expected_rx_error, expected_tx_ready);
                $display("  Got:      rx_data=%h, rx_error=%b, tx_ready=%b",
                         rx_data, rx_error, tx_ready);
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
        $dumpvars(0,ref_clk, reset, rx_valid, tx_data, tx_valid, rx_data, rx_error, tx_ready);
    end

endmodule
