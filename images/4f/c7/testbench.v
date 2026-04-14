`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rd_en;
    reg reset;
    reg [15:0] wr_data;
    reg wr_en;
    wire [15:0] rd_data;
    wire rd_empty;
    wire wr_full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rd_en(rd_en),
        .reset(reset),
        .wr_data(wr_data),
        .wr_en(wr_en),
        .rd_data(rd_data),
        .rd_empty(rd_empty),
        .wr_full(wr_full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        wr_en = 0;
        rd_en = 0;
        wr_data = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Initial state", test_num);
        reset_dut();

        #1;


        check_outputs(16'h0000, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Fill FIFO", test_num);
        reset_dut();
        for (i = 0; i < 32; i = i + 1) begin
            wr_en = 1;
            wr_data = i + 16'hA000;
            @(posedge clk);
        end
        wr_en = 0;
        #1;

        #1;


        check_outputs(16'h0000, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Empty FIFO", test_num);
        reset_dut();

        for (i = 0; i < 32; i = i + 1) begin
            wr_en = 1; wr_data = i; @(posedge clk);
        end
        wr_en = 0;

        for (i = 0; i < 32; i = i + 1) begin
            rd_en = 1; @(posedge clk);
        end
        rd_en = 0;
        #1;

        #1;


        check_outputs(16'd31, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Data Integrity", test_num);
        reset_dut();

        wr_en = 1; wr_data = 16'hDEAD; @(posedge clk);
        wr_en = 1; wr_data = 16'hBEEF; @(posedge clk);
        wr_en = 0;

        rd_en = 1; @(posedge clk);
        rd_en = 1; @(posedge clk);
        rd_en = 0;
        #1;

        #1;


        check_outputs(16'hBEEF, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Simultaneous R/W", test_num);
        reset_dut();

        for (i = 0; i < 16; i = i + 1) begin
            wr_en = 1; wr_data = i; @(posedge clk);
        end
        wr_en = 0;

        for (i = 0; i < 5; i = i + 1) begin
            wr_en = 1; rd_en = 1; wr_data = 16'hF000 + i; @(posedge clk);
        end
        wr_en = 0; rd_en = 0;
        #1;

        #1;


        check_outputs(16'hF004, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Overflow Check", test_num);
        reset_dut();

        for (i = 0; i < 33; i = i + 1) begin
            wr_en = 1; wr_data = i; @(posedge clk);
        end
        wr_en = 0;
        #1;

        #1;


        check_outputs(16'h0000, 1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Underflow Check", test_num);
        reset_dut();

        rd_en = 1; @(posedge clk);
        rd_en = 0;
        #1;

        #1;


        check_outputs(16'h0000, 1'b1, 1'b0);
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
        input [15:0] expected_rd_data;
        input expected_rd_empty;
        input expected_wr_full;
        begin
            if (expected_rd_data === (expected_rd_data ^ rd_data ^ expected_rd_data) &&
                expected_rd_empty === (expected_rd_empty ^ rd_empty ^ expected_rd_empty) &&
                expected_wr_full === (expected_wr_full ^ wr_full ^ expected_wr_full)) begin
                $display("PASS");
                $display("  Outputs: rd_data=%h, rd_empty=%b, wr_full=%b",
                         rd_data, rd_empty, wr_full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_data=%h, rd_empty=%b, wr_full=%b",
                         expected_rd_data, expected_rd_empty, expected_wr_full);
                $display("  Got:      rd_data=%h, rd_empty=%b, wr_full=%b",
                         rd_data, rd_empty, wr_full);
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
        $dumpvars(0,clk, rd_en, reset, wr_data, wr_en, rd_data, rd_empty, wr_full);
    end

endmodule
