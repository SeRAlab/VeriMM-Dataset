`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] data_in;
    reg ready;
    reg start;
    reg sys_clk;
    wire done;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .ready(ready),
        .start(start),
        .sys_clk(sys_clk),
        .done(done),
        .tx(tx)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

        task reset_dut;

        begin
            start = 0;
            ready = 1;
            data_in = 8'h00;
            @(posedge sys_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Transmitting 0xA5 (10100101)");
            reset_dut();
            data_in = 8'hA5;
            start = 1;
            @(posedge sys_clk);
            start = 0;

            repeat(11) @(posedge sys_clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Transmitting 0x5A (01011010)");
            reset_dut();
            data_in = 8'h5A;
            start = 1;
            @(posedge sys_clk);
            start = 0;
            repeat(11) @(posedge sys_clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Transmitting 0x00");
            reset_dut();
            data_in = 8'h00;
            start = 1;
            @(posedge sys_clk);
            start = 0;
            repeat(11) @(posedge sys_clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Transmitting 0xFF");
            reset_dut();
            data_in = 8'hFF;
            start = 1;
            @(posedge sys_clk);
            start = 0;
            repeat(11) @(posedge sys_clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Start signal ignored when ready=0");
            reset_dut();
            ready = 0;
            data_in = 8'hAA;
            start = 1;
            @(posedge sys_clk);
            start = 0;

            repeat(5) @(posedge sys_clk);
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_done;
        input expected_tx;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: done=%b, tx=%b",
                         done, tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, tx=%b",
                         expected_done, expected_tx);
                $display("  Got:      done=%b, tx=%b",
                         done, tx);
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
        $dumpvars(0,data_in, ready, start, sys_clk, done, tx);
    end

endmodule
