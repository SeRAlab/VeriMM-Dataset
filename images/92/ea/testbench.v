`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg fifo_rd;
    reg ps2c;
    reg ps2d;
    reg reset;
    reg watchdog;
    wire [3:0] count;
    wire [7:0] fifo_data;
    wire fifo_empty;
    wire fifo_overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .fifo_rd(fifo_rd),
        .ps2c(ps2c),
        .ps2d(ps2d),
        .reset(reset),
        .watchdog(watchdog),
        .count(count),
        .fifo_data(fifo_data),
        .fifo_empty(fifo_empty),
        .fifo_overflow(fifo_overflow)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            fifo_rd = 0;
            ps2c = 1;
            ps2d = 1;
            watchdog = 0;
            repeat(5) @(posedge clock);
            reset = 0;
            repeat(5) @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            send_ps2_byte(8'h1A);
            repeat(10) @(posedge clock);

            $display("Testcase 001: Single Byte Reception");
            #1;

            check_outputs(4'h1, 8'h1A, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            send_ps2_byte(8'hA5);
            repeat(10) @(posedge clock);


            @(posedge clock);
            fifo_rd = 1;
            @(posedge clock);
            fifo_rd = 0;
            repeat(10) @(posedge clock);


            $display("Testcase 002: FIFO Read Operation");
            #1;

            check_outputs(4'h0, 8'hA5, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            send_ps2_byte(8'h11);
            send_ps2_byte(8'h22);
            send_ps2_byte(8'h33);
            repeat(10) @(posedge clock);


            @(posedge clock);
            fifo_rd = 1;
            @(posedge clock);
            fifo_rd = 0;
            repeat(10) @(posedge clock);


            $display("Testcase 003: Multiple Byte Sequence");
            #1;

            check_outputs(4'h2, 8'h22, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        integer k;
        begin
            test_num = 4;
            reset_dut();

            for (k = 0; k < 16; k = k + 1) begin
                send_ps2_byte(k[7:0]);
            end

            send_ps2_byte(8'hFF);
            repeat(10) @(posedge clock);

            $display("Testcase 004: Overflow Check");




            if (fifo_overflow === 1'b1) begin

                 #1;


                 check_outputs(count, fifo_data, 1'b0, 1'b1);
            end else begin
                 #1;

                 check_outputs(count, fifo_data, 1'b0, 1'b1);
            end
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
        input [3:0] expected_count;
        input [7:0] expected_fifo_data;
        input expected_fifo_empty;
        input expected_fifo_overflow;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_fifo_data === (expected_fifo_data ^ fifo_data ^ expected_fifo_data) &&
                expected_fifo_empty === (expected_fifo_empty ^ fifo_empty ^ expected_fifo_empty) &&
                expected_fifo_overflow === (expected_fifo_overflow ^ fifo_overflow ^ expected_fifo_overflow)) begin
                $display("PASS");
                $display("  Outputs: count=%h, fifo_data=%h, fifo_empty=%b, fifo_overflow=%b",
                         count, fifo_data, fifo_empty, fifo_overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, fifo_data=%h, fifo_empty=%b, fifo_overflow=%b",
                         expected_count, expected_fifo_data, expected_fifo_empty, expected_fifo_overflow);
                $display("  Got:      count=%h, fifo_data=%h, fifo_empty=%b, fifo_overflow=%b",
                         count, fifo_data, fifo_empty, fifo_overflow);
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
        $dumpvars(0,clock, fifo_rd, ps2c, ps2d, reset, watchdog, count, fifo_data, fifo_empty, fifo_overflow);
    end

endmodule
