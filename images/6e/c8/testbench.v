`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg deq;
    reg enq;
    reg rst;
    wire [9:0] count;
    wire [7:0] data_out;
    wire [9:0] head;
    wire [9:0] tail;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .deq(deq),
        .enq(enq),
        .rst(rst),
        .count(count),
        .data_out(data_out),
        .head(head),
        .tail(tail)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enq = 0;
            deq = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase 001: Basic Enqueue");
            enq = 1;
            data_in = 8'hA5;
            @(posedge clk);
            #1;
            enq = 0;

            #1;


            check_outputs(10'd1, 8'h00, 10'd0, 10'd1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase 002: Enqueue then Dequeue");

            enq = 1; data_in = 8'h5A; @(posedge clk); #1;

            enq = 0; deq = 1; @(posedge clk); #1;
            deq = 0;

            #1;


            check_outputs(10'd0, 8'h5A, 10'd1, 10'd1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase 003: Fill Queue to Capacity");
            enq = 1;
            for (i = 1; i <= 10; i = i + 1) begin
                data_in = i[7:0];
                @(posedge clk);
                #1;
            end
            enq = 0;

            #1;


            check_outputs(10'd10, 8'h00, 10'd0, 10'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase 004: Empty Queue Dequeue");
            deq = 1;
            @(posedge clk);
            #1;
            deq = 0;

            #1;


            check_outputs(10'd0, 8'h00, 10'd0, 10'd0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase 005: Circular Wrap-around");

            enq = 1;
            for (i = 1; i <= 10; i = i + 1) begin
                data_in = i[7:0];
                @(posedge clk);
                #1;
            end
            enq = 0;

            deq = 1;
            for (i = 1; i <= 5; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            deq = 0;

            enq = 1;
            for (i = 11; i <= 13; i = i + 1) begin
                data_in = i[7:0];
                @(posedge clk);
                #1;
            end
            enq = 0;

            #1;


            check_outputs(10'd8, 8'h05, 10'd5, 10'd3);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Running Testcase 006: Reset mid-operation");
            enq = 1; data_in = 8'hFF; @(posedge clk); #1;
            rst = 1; @(posedge clk); #1;
            rst = 0;

            #1;


            check_outputs(10'd0, 8'h00, 10'd0, 10'd0);
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
        input [9:0] expected_count;
        input [7:0] expected_data_out;
        input [9:0] expected_head;
        input [9:0] expected_tail;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_head === (expected_head ^ head ^ expected_head) &&
                expected_tail === (expected_tail ^ tail ^ expected_tail)) begin
                $display("PASS");
                $display("  Outputs: count=%h, data_out=%h, head=%h, tail=%h",
                         count, data_out, head, tail);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, data_out=%h, head=%h, tail=%h",
                         expected_count, expected_data_out, expected_head, expected_tail);
                $display("  Got:      count=%h, data_out=%h, head=%h, tail=%h",
                         count, data_out, head, tail);
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
        $dumpvars(0,clk, data_in, deq, enq, rst, count, data_out, head, tail);
    end

endmodule
