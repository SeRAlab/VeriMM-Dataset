`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [7:0] d_in;
    reg pop_cb;
    reg push_cb;
    reg rst;
    wire [7:0] d_out;
    wire empty_cb;
    wire full_cb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .d_in(d_in),
        .pop_cb(pop_cb),
        .push_cb(push_cb),
        .rst(rst),
        .d_out(d_out),
        .empty_cb(empty_cb),
        .full_cb(full_cb)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            rst = 1;
            push_cb = 0;
            pop_cb = 0;
            d_in = 8'h00;
            @(posedge clock);
            #1 rst = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Reset State Check");
            reset_dut();
            #1;

            check_outputs(8'hxx, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Single Push and Pop");
            reset_dut();


            d_in = 8'hA5;
            push_cb = 1;
            @(posedge clock);
            #1 push_cb = 0;


            pop_cb = 1;
            @(posedge clock);
            #1 pop_cb = 0;

            #1;


            check_outputs(8'hA5, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Full Capacity Test");
            reset_dut();


            push_cb = 1;
            d_in = 8'h01; @(posedge clock); #1;
            d_in = 8'h02; @(posedge clock); #1;
            d_in = 8'h03; @(posedge clock); #1;
            d_in = 8'h04; @(posedge clock); #1;
            push_cb = 0;

            #1;


            check_outputs(8'hxx, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Data Order (FIFO Logic)");
            reset_dut();


            push_cb = 1;
            d_in = 8'h11; @(posedge clock); #1;
            d_in = 8'h22; @(posedge clock); #1;
            d_in = 8'h33; @(posedge clock); #1;
            d_in = 8'h44; @(posedge clock); #1;
            push_cb = 0;


            pop_cb = 1;
            @(posedge clock); #1;
            @(posedge clock); #1;
            @(posedge clock); #1;
            @(posedge clock); #1;
            pop_cb = 0;

            #1;


            check_outputs(8'h44, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Overflow Protection");
            reset_dut();


            push_cb = 1;
            d_in = 8'hD1; @(posedge clock); #1;
            d_in = 8'hD2; @(posedge clock); #1;
            d_in = 8'hD3; @(posedge clock); #1;
            d_in = 8'hD4; @(posedge clock); #1;
            d_in = 8'hD5; @(posedge clock); #1;
            push_cb = 0;


            pop_cb = 1;
            @(posedge clock); #1;
            @(posedge clock); #1;
            @(posedge clock); #1;
            @(posedge clock); #1;
            pop_cb = 0;

            #1;


            check_outputs(8'hD4, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Underflow Test");
            reset_dut();

            pop_cb = 1;
            @(posedge clock);
            #1 pop_cb = 0;

            #1;


            check_outputs(8'hxx, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning Testcase 007: Interleaved Push/Pop");
            reset_dut();


            push_cb = 1;
            d_in = 8'h0A; @(posedge clock); #1;
            d_in = 8'h0B; @(posedge clock); #1;
            push_cb = 0;


            pop_cb = 1;
            @(posedge clock); #1;
            pop_cb = 0;


            push_cb = 1;
            d_in = 8'h0C; @(posedge clock); #1;
            d_in = 8'h0D; @(posedge clock); #1;
            push_cb = 0;


            pop_cb = 1;
            @(posedge clock); #1;
            @(posedge clock); #1;
            @(posedge clock); #1;
            pop_cb = 0;

            #1;


            check_outputs(8'h0D, 1'b1, 1'b0);
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
        testcase007();
        
        
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
        input [7:0] expected_d_out;
        input expected_empty_cb;
        input expected_full_cb;
        begin
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out) &&
                expected_empty_cb === (expected_empty_cb ^ empty_cb ^ expected_empty_cb) &&
                expected_full_cb === (expected_full_cb ^ full_cb ^ expected_full_cb)) begin
                $display("PASS");
                $display("  Outputs: d_out=%h, empty_cb=%b, full_cb=%b",
                         d_out, empty_cb, full_cb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%h, empty_cb=%b, full_cb=%b",
                         expected_d_out, expected_empty_cb, expected_full_cb);
                $display("  Got:      d_out=%h, empty_cb=%b, full_cb=%b",
                         d_out, empty_cb, full_cb);
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
        $dumpvars(0,clock, d_in, pop_cb, push_cb, rst, d_out, empty_cb, full_cb);
    end

endmodule
