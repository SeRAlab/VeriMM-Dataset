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
        rd = 0;
        wr = 0;
        in = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(12'd0, 1'b1, 1'b0, 16'hxxxx);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Single Write then Read", test_num);
        reset_dut();


        in = 16'hAAAA;
        wr = 1;
        @(posedge clk);
        #1 wr = 0;
        in = 0;
        @(posedge clk);


        rd = 1;
        @(posedge clk);
        #1 rd = 0;
        @(posedge clk);


        #1;



        check_outputs(12'd0, 1'b1, 1'b0, 16'hAAAA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Multiple Writes", test_num);
        reset_dut();


        for (i = 0; i < 5; i = i + 1) begin
            in = i + 1;
            wr = 1;
            @(posedge clk);
        end
        #1 wr = 0;
        in = 0;
        @(posedge clk);


        #1;



        check_outputs(12'd5, 1'b0, 1'b0, 16'hxxxx);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Fill to Full", test_num);
        reset_dut();

        for (i = 0; i < 4096; i = i + 1) begin
            in = i;
            wr = 1;
            @(posedge clk);
        end
        #1 wr = 0;
        in = 0;
        @(posedge clk);




        if (full === 1'b1) begin
            pass_count = pass_count + 1;
            $display("PASS - Full flag set");
        end else begin
            fail_count = fail_count + 1;
            $display("FAIL - Full flag not set");
        end
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Data Integrity Sequence", test_num);
        reset_dut();


        in = 16'h1111; wr = 1; @(posedge clk);
        in = 16'h2222; wr = 1; @(posedge clk);
        #1 wr = 0;


        rd = 1; @(posedge clk);
        #1 rd = 0; @(posedge clk);


        in = 16'h3333; wr = 1; @(posedge clk);
        #1 wr = 0; @(posedge clk);


        #1;



        check_outputs(12'd2, 1'b0, 1'b0, 16'h1111);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Simultaneous RD/WR", test_num);
        reset_dut();


        in = 16'h8888; wr = 1; @(posedge clk);
        #1 wr = 0; @(posedge clk);


        in = 16'h9999;
        wr = 1;
        rd = 1;
        @(posedge clk);
        #1 wr = 0; rd = 0;
        @(posedge clk);


        #1;



        check_outputs(12'd1, 1'b0, 1'b0, 16'h8888);
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
