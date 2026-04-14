`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dat;
    reg st;
    wire TXD;
    wire T_dat;
    wire T_start;
    wire T_stop;
    wire [3:0] cb_bit;
    wire ce_stop;
    wire ce_tact;
    wire en_tx_byte;
    wire [7:0] sr_dat;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dat(dat),
        .st(st),
        .TXD(TXD),
        .T_dat(T_dat),
        .T_start(T_start),
        .T_stop(T_stop),
        .cb_bit(cb_bit),
        .ce_stop(ce_stop),
        .ce_tact(ce_tact),
        .en_tx_byte(en_tx_byte),
        .sr_dat(sr_dat)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        st = 0;
        dat = 8'h00;
        repeat(5) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Transmitting 8'h00", test_num);
        reset_dut();
        dat = 8'h00;
        st = 1;
        @(posedge clk);
        #1 st = 0;


        wait(en_tx_byte == 1);

        wait(en_tx_byte == 0);
        repeat(5) @(posedge clk);



        #1;




        check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 4'h0, 1'b0, 1'b0, 1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Transmitting 8'hFF", test_num);
        reset_dut();
        dat = 8'hFF;
        st = 1;
        @(posedge clk);
        #1 st = 0;

        wait(en_tx_byte == 1);
        wait(en_tx_byte == 0);
        repeat(5) @(posedge clk);

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 4'h0, 1'b0, 1'b0, 1'b0, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Transmitting 8'h55", test_num);
        reset_dut();
        dat = 8'h55;
        st = 1;
        @(posedge clk);
        #1 st = 0;

        wait(en_tx_byte == 1);
        wait(en_tx_byte == 0);
        repeat(5) @(posedge clk);

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 4'h0, 1'b0, 1'b0, 1'b0, 8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Transmitting 8'hAA", test_num);
        reset_dut();
        dat = 8'hAA;
        st = 1;
        @(posedge clk);
        #1 st = 0;

        wait(en_tx_byte == 1);
        wait(en_tx_byte == 0);
        repeat(5) @(posedge clk);

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 4'h0, 1'b0, 1'b0, 1'b0, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Transmitting 8'hA5", test_num);
        reset_dut();
        dat = 8'hA5;
        st = 1;
        @(posedge clk);
        #1 st = 0;

        wait(en_tx_byte == 1);
        wait(en_tx_byte == 0);
        repeat(5) @(posedge clk);

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 4'h0, 1'b0, 1'b0, 1'b0, 8'h00);
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
        input expected_TXD;
        input expected_T_dat;
        input expected_T_start;
        input expected_T_stop;
        input [3:0] expected_cb_bit;
        input expected_ce_stop;
        input expected_ce_tact;
        input expected_en_tx_byte;
        input [7:0] expected_sr_dat;
        begin
            if (expected_TXD === (expected_TXD ^ TXD ^ expected_TXD) &&
                expected_T_dat === (expected_T_dat ^ T_dat ^ expected_T_dat) &&
                expected_T_start === (expected_T_start ^ T_start ^ expected_T_start) &&
                expected_T_stop === (expected_T_stop ^ T_stop ^ expected_T_stop) &&
                expected_cb_bit === (expected_cb_bit ^ cb_bit ^ expected_cb_bit) &&
                expected_ce_stop === (expected_ce_stop ^ ce_stop ^ expected_ce_stop) &&
                expected_ce_tact === (expected_ce_tact ^ ce_tact ^ expected_ce_tact) &&
                expected_en_tx_byte === (expected_en_tx_byte ^ en_tx_byte ^ expected_en_tx_byte) &&
                expected_sr_dat === (expected_sr_dat ^ sr_dat ^ expected_sr_dat)) begin
                $display("PASS");
                $display("  Outputs: TXD=%b, T_dat=%b, T_start=%b, T_stop=%b, cb_bit=%h, ce_stop=%b, ce_tact=%b, en_tx_byte=%b, sr_dat=%h",
                         TXD, T_dat, T_start, T_stop, cb_bit, ce_stop, ce_tact, en_tx_byte, sr_dat);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: TXD=%b, T_dat=%b, T_start=%b, T_stop=%b, cb_bit=%h, ce_stop=%b, ce_tact=%b, en_tx_byte=%b, sr_dat=%h",
                         expected_TXD, expected_T_dat, expected_T_start, expected_T_stop, expected_cb_bit, expected_ce_stop, expected_ce_tact, expected_en_tx_byte, expected_sr_dat);
                $display("  Got:      TXD=%b, T_dat=%b, T_start=%b, T_stop=%b, cb_bit=%h, ce_stop=%b, ce_tact=%b, en_tx_byte=%b, sr_dat=%h",
                         TXD, T_dat, T_start, T_stop, cb_bit, ce_stop, ce_tact, en_tx_byte, sr_dat);
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
        $dumpvars(0,clk, dat, st, TXD, T_dat, T_start, T_stop, cb_bit, ce_stop, ce_tact, en_tx_byte, sr_dat);
    end

endmodule
