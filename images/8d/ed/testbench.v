`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] din;
    reg rd_en;
    reg srst;
    reg wr_en;
    wire [11:0] dout;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .rd_en(rd_en),
        .srst(srst),
        .wr_en(wr_en),
        .dout(dout),
        .empty(empty),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            srst = 1;
            wr_en = 0;
            rd_en = 0;
            din = 0;
            @(posedge clk);
            #1 srst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset State Check");
            reset_dut();

            #1;


            check_outputs(12'h0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Write and Read");
            reset_dut();

            din = 12'hA5A;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;

            rd_en = 1;
            @(posedge clk);
            rd_en = 0;
            @(posedge clk);

            #1;


            check_outputs(12'hA5A, 1, 0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Running testcase003: Fill FIFO (1024 entries)");
            reset_dut();
            wr_en = 1;
            for (i = 0; i < 1024; i = i + 1) begin
                din = i[11:0];
                @(posedge clk);
            end
            wr_en = 0;
            @(posedge clk);

            #1;


            check_outputs(12'h0, 0, 1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Running testcase004: Fill and Empty FIFO");
            reset_dut();

            wr_en = 1;
            for (i = 0; i < 1024; i = i + 1) begin
                din = i[11:0];
                @(posedge clk);
            end
            wr_en = 0;

            rd_en = 1;
            for (i = 0; i < 1024; i = i + 1) begin
                @(posedge clk);
            end
            rd_en = 0;
            @(posedge clk);

            #1;


            check_outputs(12'd1023, 1, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Simultaneous Read and Write");
            reset_dut();

            wr_en = 1;
            din = 12'h100; @(posedge clk);
            din = 12'h200; @(posedge clk);
            din = 12'h300; @(posedge clk);
            din = 12'h400; @(posedge clk);
            din = 12'h500; @(posedge clk);

            din = 12'h600;
            rd_en = 1;
            @(posedge clk);
            wr_en = 0;
            rd_en = 0;
            @(posedge clk);

            #1;


            check_outputs(12'h100, 0, 0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Running testcase006: Write Overflow");
            reset_dut();
            wr_en = 1;

            for (i = 0; i < 1034; i = i + 1) begin
                din = i[11:0];
                @(posedge clk);
            end
            wr_en = 0;
            @(posedge clk);

            #1;


            check_outputs(12'h0, 0, 1);
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
        input [11:0] expected_dout;
        input expected_empty;
        input expected_full;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, empty=%b, full=%b",
                         dout, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, empty=%b, full=%b",
                         expected_dout, expected_empty, expected_full);
                $display("  Got:      dout=%h, empty=%b, full=%b",
                         dout, empty, full);
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
        $dumpvars(0,clk, din, rd_en, srst, wr_en, dout, empty, full);
    end

endmodule
