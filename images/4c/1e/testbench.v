`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rd_en;
    reg rst;
    reg [7:0] wr_data;
    reg wr_en;
    wire empty;
    wire full;
    wire [7:0] rd_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rd_en(rd_en),
        .rst(rst),
        .wr_data(wr_data),
        .wr_en(wr_en),
        .empty(empty),
        .full(full),
        .rd_data(rd_data)
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
        wr_data = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Single Write and Single Read");
        reset_dut();

        @(negedge clk);
        wr_en = 1;
        wr_data = 8'hA5;
        @(negedge clk);
        wr_en = 0;
        rd_en = 1;
        @(negedge clk);
        rd_en = 0;


        #1 #1;
 check_outputs(1, 0, 8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Fill FIFO to check Full flag");
        reset_dut();

        for (i = 0; i < 8; i = i + 1) begin
            @(negedge clk);
            wr_en = 1;
            wr_data = i[7:0];
        end
        @(negedge clk);
        wr_en = 0;


        #1 #1;
 check_outputs(0, 1, rd_data);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Fill and then Empty the FIFO");
        reset_dut();


        for (i = 0; i < 8; i = i + 1) begin
            @(negedge clk);
            wr_en = 1;
            wr_data = i + 10;
        end

        for (i = 0; i < 8; i = i + 1) begin
            @(negedge clk);
            wr_en = 0;
            rd_en = 1;
        end
        @(negedge clk);
        rd_en = 0;


        #1 #1;
 check_outputs(1, 0, 8'd17);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Simultaneous Read and Write");
        reset_dut();


        @(negedge clk);
        wr_en = 1;
        wr_data = 8'h11;
        @(negedge clk);

        wr_en = 1;
        wr_data = 8'h22;
        rd_en = 1;
        @(negedge clk);
        wr_en = 0;
        rd_en = 0;


        #1 #1;
 check_outputs(0, 0, 8'h11);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Pointer Wrap-around");
        reset_dut();


        for (i = 0; i < 4; i = i + 1) begin
            @(negedge clk);
            wr_en = 1; wr_data = 8'hF0 + i;
        end

        for (i = 0; i < 4; i = i + 1) begin
            @(negedge clk);
            wr_en = 0; rd_en = 1;
        end

        for (i = 0; i < 6; i = i + 1) begin
            @(negedge clk);
            rd_en = 0; wr_en = 1; wr_data = 8'hE0 + i;
        end
        @(negedge clk);
        wr_en = 0;
        rd_en = 1;
        @(negedge clk);
        rd_en = 0;


        #1 #1;
 check_outputs(0, 0, 8'hE0);
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
        input expected_empty;
        input expected_full;
        input [7:0] expected_rd_data;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_rd_data === (expected_rd_data ^ rd_data ^ expected_rd_data)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, rd_data=%h",
                         empty, full, rd_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, rd_data=%h",
                         expected_empty, expected_full, expected_rd_data);
                $display("  Got:      empty=%b, full=%b, rd_data=%h",
                         empty, full, rd_data);
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
        $dumpvars(0,clk, rd_en, rst, wr_data, wr_en, empty, full, rd_data);
    end

endmodule
