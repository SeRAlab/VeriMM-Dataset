`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg fifo_rd;
    reg fifo_we;
    reg rd;
    reg [4:0] rptr;
    reg rst_n;
    reg [4:0] wptr;
    reg wr;
    wire fifo_empty;
    wire fifo_full;
    wire fifo_overflow;
    wire fifo_threshold;
    wire fifo_underflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .fifo_rd(fifo_rd),
        .fifo_we(fifo_we),
        .rd(rd),
        .rptr(rptr),
        .rst_n(rst_n),
        .wptr(wptr),
        .wr(wr),
        .fifo_empty(fifo_empty),
        .fifo_full(fifo_full),
        .fifo_overflow(fifo_overflow),
        .fifo_threshold(fifo_threshold),
        .fifo_underflow(fifo_underflow)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            wr = 0;
            rd = 0;
            fifo_we = 0;
            fifo_rd = 0;
            wptr = 0;
            rptr = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset State", test_num);
            reset_dut();

            #1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Single Write", test_num);
            reset_dut();
            @(posedge clk);
            wptr = 5'd1;
            rptr = 5'd0;
            wr = 1'b1;
            fifo_we = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Reach Threshold (assuming half-full)", test_num);
            reset_dut();
            @(posedge clk);
            wptr = 5'd8;
            rptr = 5'd0;
            wr = 1'b1;
            fifo_we = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Fill to Full", test_num);
            reset_dut();
            @(posedge clk);
            wptr = 5'b10000;
            rptr = 5'b00000;
            wr = 1'b1;
            fifo_we = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Overflow Condition", test_num);
            reset_dut();
            @(posedge clk);
            wptr = 5'b10000;
            rptr = 5'b00000;
            @(posedge clk);
            wr = 1'b1;
            fifo_we = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Emptying the FIFO", test_num);
            reset_dut();
            @(posedge clk);
            wptr = 5'd5;
            rptr = 5'd5;
            rd = 1'b1;
            fifo_rd = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Underflow Condition", test_num);
            reset_dut();
            @(posedge clk);
            wptr = 5'd4;
            rptr = 5'd4;
            @(posedge clk);
            rd = 1'b1;
            fifo_rd = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Simultaneous Read and Write at Empty", test_num);
            reset_dut();
            @(posedge clk);
            wptr = 5'd0;
            rptr = 5'd0;
            wr = 1'b1;
            fifo_we = 1'b1;
            rd = 1'b1;
            fifo_rd = 1'b1;
            @(posedge clk);

            wptr = 5'd1;
            rptr = 5'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
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
        input expected_fifo_empty;
        input expected_fifo_full;
        input expected_fifo_overflow;
        input expected_fifo_threshold;
        input expected_fifo_underflow;
        begin
            if (expected_fifo_empty === (expected_fifo_empty ^ fifo_empty ^ expected_fifo_empty) &&
                expected_fifo_full === (expected_fifo_full ^ fifo_full ^ expected_fifo_full) &&
                expected_fifo_overflow === (expected_fifo_overflow ^ fifo_overflow ^ expected_fifo_overflow) &&
                expected_fifo_threshold === (expected_fifo_threshold ^ fifo_threshold ^ expected_fifo_threshold) &&
                expected_fifo_underflow === (expected_fifo_underflow ^ fifo_underflow ^ expected_fifo_underflow)) begin
                $display("PASS");
                $display("  Outputs: fifo_empty=%b, fifo_full=%b, fifo_overflow=%b, fifo_threshold=%b, fifo_underflow=%b",
                         fifo_empty, fifo_full, fifo_overflow, fifo_threshold, fifo_underflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fifo_empty=%b, fifo_full=%b, fifo_overflow=%b, fifo_threshold=%b, fifo_underflow=%b",
                         expected_fifo_empty, expected_fifo_full, expected_fifo_overflow, expected_fifo_threshold, expected_fifo_underflow);
                $display("  Got:      fifo_empty=%b, fifo_full=%b, fifo_overflow=%b, fifo_threshold=%b, fifo_underflow=%b",
                         fifo_empty, fifo_full, fifo_overflow, fifo_threshold, fifo_underflow);
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
        $dumpvars(0,clk, fifo_rd, fifo_we, rd, rptr, rst_n, wptr, wr, fifo_empty, fifo_full, fifo_overflow, fifo_threshold, fifo_underflow);
    end

endmodule
