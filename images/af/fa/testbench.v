`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg rd_en;
    reg rst;
    reg wr_en;
    wire [7:0] dout;
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
        .rst(rst),
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
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        din = 0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Basic Single Write/Read");
        test_num = test_num + 1;
        reset_dut();


        wr_en = 1; din = 8'hAA;
        @(posedge clk);
        wr_en = 0;


        rd_en = 1;
        @(posedge clk);
        rd_en = 0;

        #1;
        #1;

        check_outputs(8'hAA, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    integer i;
    begin
        $display("Running testcase002: Fill to Full Capacity");
        test_num = test_num + 1;
        reset_dut();

        wr_en = 1;
        for (i = 1; i <= 16; i = i + 1) begin
            din = i[7:0];
            @(posedge clk);
        end
        wr_en = 0;

        #1;
        #1;

        check_outputs(dout, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    integer i;
    begin
        $display("Running testcase003: Fill then Empty Completely");
        test_num = test_num + 1;
        reset_dut();


        wr_en = 1;
        for (i = 1; i <= 16; i = i + 1) begin
            din = i[7:0];
            @(posedge clk);
        end
        wr_en = 0;


        rd_en = 1;
        for (i = 1; i <= 16; i = i + 1) begin
            @(posedge clk);
        end
        rd_en = 0;

        #1;
        #1;

        check_outputs(8'd16, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    integer i;
    begin
        $display("Running testcase004: Overflow Check (Write 17 times)");
        test_num = test_num + 1;
        reset_dut();


        wr_en = 1;
        for (i = 1; i <= 17; i = i + 1) begin
            din = i[7:0];
            @(posedge clk);
        end
        wr_en = 0;


        rd_en = 1;
        @(posedge clk);
        rd_en = 0;

        #1;
        #1;

        check_outputs(8'd1, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Interleaved Operations");
        test_num = test_num + 1;
        reset_dut();


        wr_en = 1; din = 8'h11; @(posedge clk);
        din = 8'h22; @(posedge clk);
        wr_en = 0;


        rd_en = 1; @(posedge clk);
        rd_en = 0;


        wr_en = 1; din = 8'h33; @(posedge clk);
        wr_en = 0;


        rd_en = 1; @(posedge clk);
        rd_en = 0;

        #1;
        #1;

        check_outputs(8'h22, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Underflow Check");
        test_num = test_num + 1;
        reset_dut();


        rd_en = 1;
        repeat(3) @(posedge clk);
        rd_en = 0;

        #1;
        #1;

        check_outputs(dout, 1'b1, 1'b0);
    end
        endtask

    task testcase007;

    integer i;
    begin
        $display("Running testcase007: Pointer Wraparound Logic");
        test_num = test_num + 1;
        reset_dut();


        wr_en = 1; for(i=0; i<10; i=i+1) begin din = i[7:0]; @(posedge clk); end
        wr_en = 0;
        rd_en = 1; for(i=0; i<10; i=i+1) begin @(posedge clk); end
        rd_en = 0;


        wr_en = 1; for(i=0; i<10; i=i+1) begin din = 8'hF0 + i[7:0]; @(posedge clk); end
        wr_en = 0;


        rd_en = 1; @(posedge clk);
        rd_en = 0;

        #1;
        #1;

        check_outputs(8'hF0, 1'b0, 1'b0);
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
        input [7:0] expected_dout;
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
        $dumpvars(0,clk, din, rd_en, rst, wr_en, dout, empty, full);
    end

endmodule
