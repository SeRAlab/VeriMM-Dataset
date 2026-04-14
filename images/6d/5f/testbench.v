`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg senddata;
    reg [7:0] txbyte;
    wire tx;
    wire txdone;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .senddata(senddata),
        .txbyte(txbyte),
        .tx(tx),
        .txdone(txdone)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            senddata = 0;
            txbyte = 0;
            repeat(5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transmitting 0x55 (LSB-first: 1-0-1-0-1-0-1-0)", test_num);
            reset_dut();

            txbyte = 8'h55;
            senddata = 1;
            @(posedge clk);
            #1;
            senddata = 0;


            wait(txdone === 1'b1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transmitting 0xAA (LSB-first: 0-1-0-1-0-1-0-1)", test_num);
            reset_dut();

            txbyte = 8'hAA;
            senddata = 1;
            @(posedge clk);
            #1;
            senddata = 0;

            wait(txdone === 1'b1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transmitting 0x00 (Check long low period)", test_num);
            reset_dut();

            txbyte = 8'h00;
            senddata = 1;
            @(posedge clk);
            #1;
            senddata = 0;

            wait(txdone === 1'b1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transmitting 0xFF (Check logic high data)", test_num);
            reset_dut();

            txbyte = 8'hFF;
            senddata = 1;
            @(posedge clk);
            #1;
            senddata = 0;

            wait(txdone === 1'b1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transmitting 0x3C", test_num);
            reset_dut();

            txbyte = 8'h3C;
            senddata = 1;
            @(posedge clk);
            #1;
            senddata = 0;

            wait(txdone === 1'b1);
            @(posedge clk);
            #1;
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
        input expected_txdone;
        begin
            if (expected_tx === (expected_tx ^ tx ^ expected_tx) &&
                expected_txdone === (expected_txdone ^ txdone ^ expected_txdone)) begin
                $display("PASS");
                $display("  Outputs: tx=%b, txdone=%b",
                         tx, txdone);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx=%b, txdone=%b",
                         expected_tx, expected_txdone);
                $display("  Got:      tx=%b, txdone=%b",
                         tx, txdone);
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
        $dumpvars(0,clk, senddata, txbyte, tx, txdone);
    end

endmodule
