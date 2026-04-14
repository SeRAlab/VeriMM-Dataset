`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_write;
    reg flush;
    reg read;
    reg rst;
    reg write;
    wire [15:0] data_read;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_write(data_write),
        .flush(flush),
        .read(read),
        .rst(rst),
        .write(write),
        .data_read(data_read),
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
            flush = 0;
            read = 0;
            write = 0;
            data_write = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Reset State Check");
            reset_dut();

            #1;


            check_outputs(16'h0000, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Single Write");
            reset_dut();
            data_write = 16'hA5A5;
            write = 1;
            @(posedge clk);
            #1 write = 0;

            #1;


            check_outputs(16'hA5A5, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Write then Read");
            reset_dut();

            data_write = 16'h1234;
            write = 1;
            @(posedge clk);
            #1 write = 0;

            read = 1;
            @(posedge clk);
            #1 read = 0;

            #1;


            check_outputs(16'h1234, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Fill FIFO to Full");
            reset_dut();
            for (i = 0; i < 512; i = i + 1) begin
                data_write = i[15:0];
                write = 1;
                @(posedge clk);
            end
            #1 write = 0;


            #1;



            check_outputs(16'h0000, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Fill and Drain FIFO");
            reset_dut();

            for (i = 0; i < 512; i = i + 1) begin
                data_write = i[15:0] + 16'h1000;
                write = 1;
                @(posedge clk);
            end
            #1 write = 0;

            for (i = 0; i < 512; i = i + 1) begin
                read = 1;
                @(posedge clk);
            end
            #1 read = 0;

            #1;


            check_outputs(16'h1000 + 511, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Flush Mid-Operation");
            reset_dut();

            for (i = 0; i < 100; i = i + 1) begin
                data_write = i[15:0];
                write = 1;
                @(posedge clk);
            end
            #1 write = 0;

            flush = 1;
            @(posedge clk);
            #1 flush = 0;
            @(posedge clk);

            #1;


            check_outputs(16'h0000, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Overflow Check");
            reset_dut();

            for (i = 0; i < 513; i = i + 1) begin
                data_write = i[15:0];
                write = 1;
                @(posedge clk);
            end
            #1 write = 0;

            #1;


            check_outputs(16'h0000, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Simultaneous Read/Write");
            reset_dut();

            data_write = 16'hBEEF;
            write = 1;
            @(posedge clk);
            #1 write = 0;

            data_write = 16'hCAFE;
            write = 1;
            read = 1;
            @(posedge clk);
            #1 write = 0;
            read = 0;
            @(posedge clk);

            #1;


            check_outputs(16'hCAFE, 1'b0, 1'b0);
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
        input [15:0] expected_data_read;
        input expected_empty;
        input expected_full;
        begin
            if (expected_data_read === (expected_data_read ^ data_read ^ expected_data_read) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: data_read=%h, empty=%b, full=%b",
                         data_read, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_read=%h, empty=%b, full=%b",
                         expected_data_read, expected_empty, expected_full);
                $display("  Got:      data_read=%h, empty=%b, full=%b",
                         data_read, empty, full);
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
        $dumpvars(0,clk, data_write, flush, read, rst, write, data_read, empty, full);
    end

endmodule
