`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg [7:0] din;
    reg enable;
    reg reset;
    wire busy;
    wire done;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .din(din),
        .enable(enable),
        .reset(reset),
        .busy(busy),
        .done(done),
        .tx(tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

    begin
        reset = 1;
        enable = 0;
        din = 8'b0;
        @(posedge clk_in);
        #1 reset = 0;
        @(posedge clk_in);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running Testcase 001: Data = 8'h00");
        reset_dut();
        din = 8'h00;
        enable = 1;
        @(posedge clk_in);
        #1 enable = 0;


        wait(busy === 1);
        wait(done === 1);
        #1;
        #1;

        check_outputs(0, 1, 1);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: Data = 8'hFF");
        reset_dut();
        din = 8'hFF;
        enable = 1;
        @(posedge clk_in);
        #1 enable = 0;

        wait(busy === 1);
        wait(done === 1);
        #1;
        #1;

        check_outputs(0, 1, 1);
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: Data = 8'hAA");
        reset_dut();
        din = 8'hAA;
        enable = 1;
        @(posedge clk_in);
        #1 enable = 0;

        wait(busy === 1);
        wait(done === 1);
        #1;
        #1;

        check_outputs(0, 1, 1);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: Data = 8'h55");
        reset_dut();
        din = 8'h55;
        enable = 1;
        @(posedge clk_in);
        #1 enable = 0;

        wait(busy === 1);
        wait(done === 1);
        #1;
        #1;

        check_outputs(0, 1, 1);
    end
        endtask

    task testcase005;

    begin
        $display("Running Testcase 005: Data = 8'hA5");
        reset_dut();
        din = 8'hA5;
        enable = 1;
        @(posedge clk_in);
        #1 enable = 0;

        wait(busy === 1);
        wait(done === 1);
        #1;
        #1;

        check_outputs(0, 1, 1);
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
        input expected_busy;
        input expected_done;
        input expected_tx;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, done=%b, tx=%b",
                         busy, done, tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, done=%b, tx=%b",
                         expected_busy, expected_done, expected_tx);
                $display("  Got:      busy=%b, done=%b, tx=%b",
                         busy, done, tx);
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
        $dumpvars(0,clk_in, din, enable, reset, busy, done, tx);
    end

endmodule
