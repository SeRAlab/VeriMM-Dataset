`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] TxD_data;
    reg TxD_start;
    reg clock;
    reg reset;
    reg uart_tick;
    wire TxD;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .TxD_data(TxD_data),
        .TxD_start(TxD_start),
        .clock(clock),
        .reset(reset),
        .uart_tick(uart_tick),
        .TxD(TxD),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            TxD_data = 8'h00;
            TxD_start = 0;
            uart_tick = 0;
            repeat(2) @(posedge clock);
            reset = 0;
            repeat(2) @(posedge clock);
        end
        endtask
    task pulse_tick;

        begin
            @(posedge clock);
            uart_tick = 1;
            @(posedge clock);
            uart_tick = 0;

            repeat(2) @(posedge clock);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset state check");
            reset_dut();
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("Testcase 002: Transmit 0xA5 (10100101)");
            reset_dut();

            TxD_data = 8'hA5;
            TxD_start = 1;
            @(posedge clock);
            TxD_start = 0;



            for (i = 0; i < 11; i = i + 1) begin
                pulse_tick();
            end

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase 003: Transmit 0x00");
            reset_dut();

            TxD_data = 8'h00;
            TxD_start = 1;
            @(posedge clock);
            TxD_start = 0;

            for (i = 0; i < 11; i = i + 1) begin
                pulse_tick();
            end

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase 004: Transmit 0xFF");
            reset_dut();

            TxD_data = 8'hFF;
            TxD_start = 1;
            @(posedge clock);
            TxD_start = 0;

            for (i = 0; i < 11; i = i + 1) begin
                pulse_tick();
            end

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase 005: Consecutive check (0x55 then 0xAA)");
            reset_dut();


            TxD_data = 8'h55;
            TxD_start = 1;
            @(posedge clock);
            TxD_start = 0;
            for (i = 0; i < 11; i = i + 1) pulse_tick();


            if (ready) begin
                TxD_data = 8'hAA;
                TxD_start = 1;
                @(posedge clock);
                TxD_start = 0;
                for (i = 0; i < 11; i = i + 1) pulse_tick();
            end

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
        input expected_TxD;
        input expected_ready;
        begin
            if (expected_TxD === (expected_TxD ^ TxD ^ expected_TxD) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: TxD=%b, ready=%b",
                         TxD, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: TxD=%b, ready=%b",
                         expected_TxD, expected_ready);
                $display("  Got:      TxD=%b, ready=%b",
                         TxD, ready);
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
        $dumpvars(0,TxD_data, TxD_start, clock, reset, uart_tick, TxD, ready);
    end

endmodule
