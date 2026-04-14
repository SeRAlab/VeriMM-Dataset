`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] din;
    reg rd_en;
    reg rst;
    reg wr_en;
    wire [63:0] dout;
    wire empty;
    wire full;
    wire wr_rst_busy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .rd_en(rd_en),
        .rst(rst),
        .wr_en(wr_en),
        .dout(dout),
        .empty(empty),
        .full(full),
        .wr_rst_busy(wr_rst_busy)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            wr_en = 0;
            rd_en = 0;
            din = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;

            while (wr_rst_busy) @(posedge clk);
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial state after reset");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(64'bx, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single write and read cycle");
            test_num = 2;
            reset_dut();


            @(posedge clk);
            #1;
            wr_en = 1;
            din = 64'hAAAA_BBBB_CCCC_DDDD;
            @(posedge clk);
            #1;
            wr_en = 0;


            @(posedge clk);
            #1;
            rd_en = 1;
            @(posedge clk);
            #1;
            rd_en = 0;


            #1;



            check_outputs(64'hAAAA_BBBB_CCCC_DDDD, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Testcase 003: Fill FIFO to depth 16");
            test_num = 3;
            reset_dut();

            @(posedge clk);
            #1;
            wr_en = 1;
            for (i = 0; i < 16; i = i + 1) begin
                din = i;
                @(posedge clk);
                #1;
            end
            wr_en = 0;


            #1;



            check_outputs(64'bx, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Fill then completely empty");
            test_num = 4;
            reset_dut();


            @(posedge clk);
            #1;
            wr_en = 1;
            for (i = 0; i < 16; i = i + 1) begin
                din = i + 64'h100;
                @(posedge clk);
                #1;
            end
            wr_en = 0;


            rd_en = 1;
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            rd_en = 0;


            #1;



            check_outputs(64'h10F, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Testcase 005: Overflow (Write 17 times)");
            test_num = 5;
            reset_dut();

            @(posedge clk);
            #1;
            wr_en = 1;
            for (i = 0; i < 17; i = i + 1) begin
                din = i;
                @(posedge clk);
                #1;
            end
            wr_en = 0;


            #1;



            check_outputs(64'bx, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Underflow (Read from empty)");
            test_num = 6;
            reset_dut();

            @(posedge clk);
            #1;
            rd_en = 1;
            @(posedge clk);
            #1;
            rd_en = 0;


            #1;



            check_outputs(64'bx, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Simultaneous read and write");
            test_num = 7;
            reset_dut();


            @(posedge clk);
            #1;
            wr_en = 1;
            din = 64'hFACE_FEED_DEAD_BEEF;
            @(posedge clk);
            #1;


            wr_en = 1;
            rd_en = 1;
            din = 64'h1111_2222_3333_4444;
            @(posedge clk);
            #1;
            wr_en = 0;
            rd_en = 0;


            #1;



            check_outputs(64'hFACE_FEED_DEAD_BEEF, 1'b0, 1'b0, 1'b0);
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
        input [63:0] expected_dout;
        input expected_empty;
        input expected_full;
        input expected_wr_rst_busy;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_wr_rst_busy === (expected_wr_rst_busy ^ wr_rst_busy ^ expected_wr_rst_busy)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, empty=%b, full=%b, wr_rst_busy=%b",
                         dout, empty, full, wr_rst_busy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, empty=%b, full=%b, wr_rst_busy=%b",
                         expected_dout, expected_empty, expected_full, expected_wr_rst_busy);
                $display("  Got:      dout=%h, empty=%b, full=%b, wr_rst_busy=%b",
                         dout, empty, full, wr_rst_busy);
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
        $dumpvars(0,clk, din, rd_en, rst, wr_en, dout, empty, full, wr_rst_busy);
    end

endmodule
