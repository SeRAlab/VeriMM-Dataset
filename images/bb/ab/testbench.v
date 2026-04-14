`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] fifo_data_in;
    reg fifo_rd;
    reg fifo_wr;
    reg rst_n;
    wire [3:0] fifo_count;
    wire [7:0] fifo_data_out;
    wire fifo_empty;
    wire fifo_full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .fifo_data_in(fifo_data_in),
        .fifo_rd(fifo_rd),
        .fifo_wr(fifo_wr),
        .rst_n(rst_n),
        .fifo_count(fifo_count),
        .fifo_data_out(fifo_data_out),
        .fifo_empty(fifo_empty),
        .fifo_full(fifo_full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            fifo_rd = 0;
            fifo_wr = 0;
            fifo_data_in = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Initial Reset State");
            #1;
            #1;

            check_outputs(4'd0, 8'h0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Single Write");
            fifo_wr = 1;
            fifo_data_in = 8'hA5;
            @(posedge clk);
            fifo_wr = 0;
            #1;
            #1;

            check_outputs(4'd1, 8'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Write then Read");

            fifo_wr = 1;
            fifo_data_in = 8'h5A;
            @(posedge clk);
            fifo_wr = 0;

            fifo_rd = 1;
            @(posedge clk);
            fifo_rd = 0;
            #1;
            #1;

            check_outputs(4'd0, 8'h5A, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();
            $display("Testcase 004: Filling FIFO Halfway (8 items)");
            for(i=0; i<8; i=i+1) begin
                fifo_wr = 1;
                fifo_data_in = i + 1;
                @(posedge clk);
            end
            fifo_wr = 0;
            #1;
            #1;

            check_outputs(4'd8, 8'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();
            $display("Testcase 005: Filling FIFO to Full (16 items)");
            for(i=0; i<16; i=i+1) begin
                fifo_wr = 1;
                fifo_data_in = i;
                @(posedge clk);
            end
            fifo_wr = 0;
            #1;
            #1;

            check_outputs(4'd0, 8'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            reset_dut();
            $display("Testcase 006: Overflow Handling");
            for(i=0; i<17; i=i+1) begin
                fifo_wr = 1;
                fifo_data_in = 8'hFF;
                @(posedge clk);
            end
            fifo_wr = 0;
            #1;

            #1;


            check_outputs(4'd0, 8'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        integer i;
        begin
            reset_dut();
            $display("Testcase 007: Emptying FIFO after Full");
            for(i=0; i<16; i=i+1) begin
                fifo_wr = 1;
                fifo_data_in = 8'h10 + i;
                @(posedge clk);
            end
            fifo_wr = 0;
            for(i=0; i<16; i=i+1) begin
                fifo_rd = 1;
                @(posedge clk);
            end
            fifo_rd = 0;
            #1;

            #1;


            check_outputs(4'd0, 8'h1F, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            $display("Testcase 008: Simultaneous Read and Write");

            fifo_wr = 1;
            fifo_data_in = 8'hDE;
            @(posedge clk);


            fifo_wr = 1;
            fifo_rd = 1;
            fifo_data_in = 8'hAD;
            @(posedge clk);
            fifo_wr = 0;
            fifo_rd = 0;
            #1;

            #1;


            check_outputs(4'd1, 8'hDE, 1'b0, 1'b0);
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
        testcase008();
        
        
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
        input [3:0] expected_fifo_count;
        input [7:0] expected_fifo_data_out;
        input expected_fifo_empty;
        input expected_fifo_full;
        begin
            if (expected_fifo_count === (expected_fifo_count ^ fifo_count ^ expected_fifo_count) &&
                expected_fifo_data_out === (expected_fifo_data_out ^ fifo_data_out ^ expected_fifo_data_out) &&
                expected_fifo_empty === (expected_fifo_empty ^ fifo_empty ^ expected_fifo_empty) &&
                expected_fifo_full === (expected_fifo_full ^ fifo_full ^ expected_fifo_full)) begin
                $display("PASS");
                $display("  Outputs: fifo_count=%h, fifo_data_out=%h, fifo_empty=%b, fifo_full=%b",
                         fifo_count, fifo_data_out, fifo_empty, fifo_full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fifo_count=%h, fifo_data_out=%h, fifo_empty=%b, fifo_full=%b",
                         expected_fifo_count, expected_fifo_data_out, expected_fifo_empty, expected_fifo_full);
                $display("  Got:      fifo_count=%h, fifo_data_out=%h, fifo_empty=%b, fifo_full=%b",
                         fifo_count, fifo_data_out, fifo_empty, fifo_full);
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
        $dumpvars(0,clk, fifo_data_in, fifo_rd, fifo_wr, rst_n, fifo_count, fifo_data_out, fifo_empty, fifo_full);
    end

endmodule
