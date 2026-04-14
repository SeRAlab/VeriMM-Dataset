`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg rst;
    wire nextch;
    wire txd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .rst(rst),
        .nextch(nextch),
        .txd(txd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data = 8'h00;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Checking Idle State after Reset");
            reset_dut();

            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Transmitting 0x55");
            reset_dut();
            data = 8'h55;

            repeat(15) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Transmitting 0xAA");
            reset_dut();
            data = 8'hAA;
            repeat(15) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Transmitting 0x00");
            reset_dut();
            data = 8'h00;
            repeat(15) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Transmitting 0xFF");
            reset_dut();
            data = 8'hFF;
            repeat(15) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Transmitting 0xA5");
            reset_dut();
            data = 8'hA5;
            repeat(15) @(posedge clk);
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
        input expected_nextch;
        input expected_txd;
        begin
            if (expected_nextch === (expected_nextch ^ nextch ^ expected_nextch) &&
                expected_txd === (expected_txd ^ txd ^ expected_txd)) begin
                $display("PASS");
                $display("  Outputs: nextch=%b, txd=%b",
                         nextch, txd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nextch=%b, txd=%b",
                         expected_nextch, expected_txd);
                $display("  Got:      nextch=%b, txd=%b",
                         nextch, txd);
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
        $dumpvars(0,clk, data, rst, nextch, txd);
    end

endmodule
