`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg baud;
    reg clk;
    reg reset_;
    reg tx_enable;
    reg [7:0] txdata;
    wire tx;
    wire tx_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .baud(baud),
        .clk(clk),
        .reset_(reset_),
        .tx_enable(tx_enable),
        .txdata(txdata),
        .tx(tx),
        .tx_ready(tx_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_ = 0;
            tx_enable = 0;
            txdata = 8'b0;
            baud = 0;
            repeat(5) @(posedge clk);
            reset_ = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task pulse_baud;

        begin
            baud = 1;
            @(posedge clk);
            baud = 0;
            repeat(2) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Transmitting 0x55...", test_num);
            reset_dut();
            transmit_and_capture(8'h55);


            #1;



            check_outputs(1'b1 & ~sequence_error, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Transmitting 0xAA...", test_num);
            reset_dut();
            transmit_and_capture(8'hAA);
            #1;

            check_outputs(1'b1 & ~sequence_error, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Transmitting 0x00...", test_num);
            reset_dut();
            transmit_and_capture(8'h00);
            #1;

            check_outputs(1'b1 & ~sequence_error, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Transmitting 0xFF...", test_num);
            reset_dut();
            transmit_and_capture(8'hFF);
            #1;

            check_outputs(1'b1 & ~sequence_error, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Checking Idle State...", test_num);
            reset_dut();
            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1);
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
        input expected_tx;
        input expected_tx_ready;
        begin
            if (expected_tx === (expected_tx ^ tx ^ expected_tx) &&
                expected_tx_ready === (expected_tx_ready ^ tx_ready ^ expected_tx_ready)) begin
                $display("PASS");
                $display("  Outputs: tx=%b, tx_ready=%b",
                         tx, tx_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx=%b, tx_ready=%b",
                         expected_tx, expected_tx_ready);
                $display("  Got:      tx=%b, tx_ready=%b",
                         tx, tx_ready);
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
        $dumpvars(0,baud, clk, reset_, tx_enable, txdata, tx, tx_ready);
    end

endmodule
