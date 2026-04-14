`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rd_en;
    reg rst;
    reg wr_en;
    wire [7:0] data_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rd_en(rd_en),
        .rst(rst),
        .wr_en(wr_en),
        .data_out(data_out),
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
        data_in = 0;
        repeat(2) wait_clk();
        rst = 0;
        wait_clk();
    end
        endtask
    task wait_clk;

        begin
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Initial State after Reset", test_num);
        reset_dut();

        #1;


        check_outputs(data_out, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Single Write and Read back", test_num);
        reset_dut();


        data_in = 8'hA5;
        wr_en = 1;
        wait_clk();
        wr_en = 0;


        rd_en = 1;
        wait_clk();
        rd_en = 0;


        #1;



        check_outputs(8'hA5, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = 3;
        $display("Test Case %0d: Fill FIFO to full capacity", test_num);
        reset_dut();

        wr_en = 1;
        for (i = 0; i < 8; i = i + 1) begin
            data_in = i + 1;
            wait_clk();
        end
        wr_en = 0;


        #1;



        check_outputs(data_out, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = 4;
        $display("Test Case %0d: Fill and then Empty FIFO", test_num);
        reset_dut();


        wr_en = 1;
        for (i = 0; i < 8; i = i + 1) begin
            data_in = 8'h10 + i;
            wait_clk();
        end
        wr_en = 0;


        rd_en = 1;
        for (i = 0; i < 8; i = i + 1) begin
            wait_clk();
        end
        rd_en = 0;


        #1;



        check_outputs(8'h17, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = 5;
        $display("Test Case %0d: Overflow Check (Write 10 items into 8-element FIFO)", test_num);
        reset_dut();

        wr_en = 1;
        for (i = 0; i < 10; i = i + 1) begin
            data_in = 8'hF0 + i;
            wait_clk();
        end
        wr_en = 0;


        #1;



        check_outputs(data_out, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Underflow Check (Read from empty)", test_num);
        reset_dut();

        rd_en = 1;
        repeat(2) wait_clk();
        rd_en = 0;


        #1;



        check_outputs(data_out, 1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Simultaneous Read and Write", test_num);
        reset_dut();


        data_in = 8'hCC;
        wr_en = 1;
        wait_clk();


        data_in = 8'hDD;
        wr_en = 1;
        rd_en = 1;
        wait_clk();
        wr_en = 0;
        rd_en = 0;


        #1;



        check_outputs(8'hCC, 1'b0, 1'b0);
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
        input [7:0] expected_data_out;
        input expected_empty;
        input expected_full;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b, full=%b",
                         expected_data_out, expected_empty, expected_full);
                $display("  Got:      data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
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
        $dumpvars(0,clk, data_in, rd_en, rst, wr_en, data_out, empty, full);
    end

endmodule
