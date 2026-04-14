`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] din;
    reg rd_en;
    reg rst;
    reg wr_en;
    wire [31:0] dout;
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
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase 001: Checking flags after reset");
        #1;
        #1;

        check_outputs(dout, 1, 0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase 002: Single Write then Read");


        wr_en = 1; din = 32'hDEADBEEF;
        @(posedge clk);
        wr_en = 0;
        @(posedge clk);


        rd_en = 1;
        @(posedge clk);
        rd_en = 0;

        #1;
        #1;

        check_outputs(32'hDEADBEEF, 1, 0);
    end
        endtask

    task testcase003;

    integer i;
    begin
        reset_dut();
        test_num = 3;
        $display("Testcase 003: Fill FIFO to 256 entries");

        wr_en = 1;
        for (i = 0; i < 256; i = i + 1) begin
            din = i + 1;
            @(posedge clk);
        end
        wr_en = 0;

        #1;
        #1;

        check_outputs(dout, 0, 1);
    end
        endtask

    task testcase004;

    integer i;
    begin
        reset_dut();
        test_num = 4;
        $display("Testcase 004: Fill then Read all");


        wr_en = 1;
        for (i = 0; i < 256; i = i + 1) begin
            din = 32'hA000 + i;
            @(posedge clk);
        end
        wr_en = 0;


        rd_en = 1;
        for (i = 0; i < 256; i = i + 1) begin
            @(posedge clk);
        end
        rd_en = 0;

        #1;
        #1;

        check_outputs(32'hA000 + 255, 1, 0);
    end
        endtask

    task testcase005;

    integer i;
    begin
        reset_dut();
        test_num = 5;
        $display("Testcase 005: Overflow Attempt (Write 257 times)");

        wr_en = 1;
        for (i = 0; i < 257; i = i + 1) begin
            din = i;
            @(posedge clk);
        end
        wr_en = 0;

        #1;
        #1;

        check_outputs(dout, 0, 1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase 006: Underflow Attempt (Read from empty)");

        rd_en = 1;
        @(posedge clk);
        @(posedge clk);
        rd_en = 0;

        #1;
        #1;

        check_outputs(dout, 1, 0);
    end
        endtask

    task testcase007;

    integer i;
    begin
        reset_dut();
        test_num = 7;
        $display("Testcase 007: Wraparound behavior check");


        wr_en = 1;
        for (i = 0; i < 200; i = i + 1) begin
            din = i;
            @(posedge clk);
        end
        wr_en = 0;


        rd_en = 1;
        for (i = 0; i < 150; i = i + 1) begin
            @(posedge clk);
        end
        rd_en = 0;


        wr_en = 1;
        for (i = 0; i < 100; i = i + 1) begin
            din = 32'hFFFF0000 + i;
            @(posedge clk);
        end
        wr_en = 0;


        rd_en = 1;
        for (i = 0; i < 150; i = i + 1) begin
            @(posedge clk);
        end
        rd_en = 0;

        #1;
        #1;

        check_outputs(32'hFFFF0000 + 99, 1, 0);
    end
        endtask

    task testcase008;

    integer i;
    begin
        reset_dut();
        test_num = 8;
        $display("Testcase 008: Simultaneous Read/Write");


        wr_en = 1;
        for (i = 0; i < 10; i = i + 1) begin
            din = i;
            @(posedge clk);
        end


        rd_en = 1;
        for (i = 0; i < 5; i = i + 1) begin
            din = 32'hCC00 + i;
            @(posedge clk);
        end
        wr_en = 0;
        rd_en = 0;

        #1;

        #1;


        check_outputs(dout, 0, 0);
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
        input [31:0] expected_dout;
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
