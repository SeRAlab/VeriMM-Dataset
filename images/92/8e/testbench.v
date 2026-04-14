`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in;
    reg rd;
    reg reset;
    reg wr;
    wire [11:0] cnt;
    wire empty;
    wire full;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .rd(rd),
        .reset(reset),
        .wr(wr),
        .cnt(cnt),
        .empty(empty),
        .full(full),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 0;
            rd = 0;
            wr = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Single Write/Read", test_num);
            reset_dut();


            wr = 1; in = 16'hAAAA;
            @(posedge clk);
            #1 wr = 0;


            @(posedge clk);
            #1 rd = 1;
            @(posedge clk);
            #1 rd = 0;


            #1;



            check_outputs(12'd0, 1'b1, 1'b0, 16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Filling FIFO to Capacity (2048)", test_num);
            reset_dut();


            for (i = 0; i < 2048; i = i + 1) begin
                wr = 1; in = i[15:0];
                @(posedge clk);
                #1;
            end
            wr = 0;


            #1;



            check_outputs(12'h800, 1'b0, 1'b1, out);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Emptying FIFO after Full", test_num);
            reset_dut();


            for (i = 0; i < 2048; i = i + 1) begin
                wr = 1; in = i[15:0];
                @(posedge clk);
                #1;
            end
            wr = 0;


            for (i = 0; i < 2048; i = i + 1) begin
                rd = 1;
                @(posedge clk);
                #1;
            end
            rd = 0;


            #1;



            check_outputs(12'd0, 1'b1, 1'b0, 16'd2047);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Simultaneous Read and Write", test_num);
            reset_dut();


            for (i = 0; i < 10; i = i + 1) begin
                wr = 1; in = i[15:0];
                @(posedge clk);
                #1;
            end
            wr = 0;



            wr = 1; in = 16'hBEEF;
            rd = 1;
            @(posedge clk);
            #1;
            wr = 0; rd = 0;


            #1;



            check_outputs(12'd10, 1'b0, 1'b0, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Mixed Write and Read Pattern", test_num);
            reset_dut();


            for (i = 0; i < 100; i = i + 1) begin
                wr = 1; in = i[15:0];
                @(posedge clk);
                #1;
            end
            wr = 0;


            for (i = 0; i < 50; i = i + 1) begin
                rd = 1;
                @(posedge clk);
                #1;
            end
            rd = 0;


            #1;



            check_outputs(12'd50, 1'b0, 1'b0, 16'd49);
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
        input [11:0] expected_cnt;
        input expected_empty;
        input expected_full;
        input [15:0] expected_out;
        begin
            if (expected_cnt === (expected_cnt ^ cnt ^ expected_cnt) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: cnt=%h, empty=%b, full=%b, out=%h",
                         cnt, empty, full, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cnt=%h, empty=%b, full=%b, out=%h",
                         expected_cnt, expected_empty, expected_full, expected_out);
                $display("  Got:      cnt=%h, empty=%b, full=%b, out=%h",
                         cnt, empty, full, out);
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
        $dumpvars(0,clk, in, rd, reset, wr, cnt, empty, full, out);
    end

endmodule
