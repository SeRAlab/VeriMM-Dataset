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
            data_in = 8'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            $display("\nTest Case 001: Initial Reset State");
            reset_dut();

            #1;


            check_outputs(8'hxx, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTest Case 002: Single Write and Read");
            reset_dut();


            wr_en = 1;
            data_in = 8'hA5;
            @(posedge clk);
            wr_en = 0;
            @(posedge clk);


            rd_en = 1;
            @(posedge clk);
            rd_en = 0;
            #1;


            #1;



            check_outputs(8'hA5, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("\nTest Case 003: Fill FIFO to Capacity (8 Bytes)");
            reset_dut();

            wr_en = 1;
            for (i = 0; i < 8; i = i + 1) begin
                data_in = i + 8'h10;
                @(posedge clk);
            end
            wr_en = 0;
            #1;



            #1;




            check_outputs(data_out, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("\nTest Case 004: Read All from Full FIFO");
            reset_dut();


            wr_en = 1;
            for (i = 0; i < 8; i = i + 1) begin
                data_in = i + 8'h20;
                @(posedge clk);
            end
            wr_en = 0;


            rd_en = 1;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
            end
            rd_en = 0;
            #1;


            #1;



            check_outputs(8'h27, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("\nTest Case 005: Overflow Handling (Write 10 items)");
            reset_dut();


            wr_en = 1;
            for (i = 0; i < 10; i = i + 1) begin
                data_in = i;
                @(posedge clk);
            end
            wr_en = 0;


            rd_en = 1;
            @(posedge clk);
            rd_en = 0;
            #1;

            #1;


            check_outputs(8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("\nTest Case 006: Underflow Handling (Read from empty)");
            reset_dut();


            rd_en = 1;
            @(posedge clk);
            rd_en = 0;
            #1;


            #1;



            check_outputs(data_out, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        integer i;
        begin
            $display("\nTest Case 007: Pointer Wrap Around");
            reset_dut();


            wr_en = 1;
            for (i = 0; i < 5; i = i + 1) begin
                data_in = 8'hA0 + i;
                @(posedge clk);
            end
            wr_en = 0;


            rd_en = 1;
            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
            end
            rd_en = 0;


            wr_en = 1;
            for (i = 0; i < 5; i = i + 1) begin
                data_in = 8'hB0 + i;
                @(posedge clk);
            end
            wr_en = 0;


            rd_en = 1;
            @(posedge clk);
            rd_en = 0;
            #1;

            #1;


            check_outputs(8'hB0, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("\nTest Case 008: Simultaneous Read and Write");
            reset_dut();


            wr_en = 1;
            data_in = 8'h11; @(posedge clk);
            data_in = 8'h22; @(posedge clk);
            data_in = 8'h33; @(posedge clk);
            data_in = 8'h44; @(posedge clk);
            wr_en = 0;



            wr_en = 1;
            rd_en = 1;
            data_in = 8'h55;
            @(posedge clk);
            wr_en = 0;
            rd_en = 0;
            #1;


            #1;



            check_outputs(8'h11, 1'b0, 1'b0);
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
