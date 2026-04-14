`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce_16;
    reg clock;
    reg new_tx_data;
    reg reset;
    reg [7:0] tx_data;
    wire ser_out;
    wire tx_busy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce_16(ce_16),
        .clock(clock),
        .new_tx_data(new_tx_data),
        .reset(reset),
        .tx_data(tx_data),
        .ser_out(ser_out),
        .tx_busy(tx_busy)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            new_tx_data = 0;
            tx_data = 8'h00;
            @(posedge clock);
            #2 reset = 0;
            @(posedge clock);
            repeat(5) @(posedge clock);
        end
        endtask
    task wait_for_tx;

        begin

            wait(tx_busy === 1'b1);

            wait(tx_busy === 1'b0);

            repeat(20) @(posedge clock);
        end
        endtask

    task testcase001;

        begin
            $display("\nRunning testcase001: Data 0x55...");
            reset_dut();
            tx_data = 8'h55;
            new_tx_data = 1;
            @(posedge clock);
            #1 new_tx_data = 0;
            wait_for_tx();
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Data 0xAA...");
            reset_dut();
            tx_data = 8'hAA;
            new_tx_data = 1;
            @(posedge clock);
            #1 new_tx_data = 0;
            wait_for_tx();
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Data 0x00...");
            reset_dut();
            tx_data = 8'h00;
            new_tx_data = 1;
            @(posedge clock);
            #1 new_tx_data = 0;
            wait_for_tx();
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Data 0xFF...");
            reset_dut();
            tx_data = 8'hFF;
            new_tx_data = 1;
            @(posedge clock);
            #1 new_tx_data = 0;
            wait_for_tx();
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Data 0xA5...");
            reset_dut();
            tx_data = 8'hA5;
            new_tx_data = 1;
            @(posedge clock);
            #1 new_tx_data = 0;
            wait_for_tx();
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_ser_out;
        input expected_tx_busy;
        begin
            if (expected_ser_out === (expected_ser_out ^ ser_out ^ expected_ser_out) &&
                expected_tx_busy === (expected_tx_busy ^ tx_busy ^ expected_tx_busy)) begin
                $display("PASS");
                $display("  Outputs: ser_out=%b, tx_busy=%b",
                         ser_out, tx_busy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ser_out=%b, tx_busy=%b",
                         expected_ser_out, expected_tx_busy);
                $display("  Got:      ser_out=%b, tx_busy=%b",
                         ser_out, tx_busy);
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
        $dumpvars(0,ce_16, clock, new_tx_data, reset, tx_data, ser_out, tx_busy);
    end

endmodule
