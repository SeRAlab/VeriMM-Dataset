`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg fifo_rd;
    reg fifo_wr;
    reg rst_n;
    wire [3:0] count;
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
        .fifo_rd(fifo_rd),
        .fifo_wr(fifo_wr),
        .rst_n(rst_n),
        .count(count),
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
            rst_n = 0;
            fifo_rd = 0;
            fifo_wr = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial State", test_num);
            reset_dut();

            #1;


            check_outputs(4'd0, 8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Write/Read", test_num);
            reset_dut();


            fifo_wr = 1;
            data_in = 8'hA5;
            @(posedge clk);
            #1;
            fifo_wr = 0;


            fifo_rd = 1;
            @(posedge clk);
            #1;
            fifo_rd = 0;


            #1;



            check_outputs(4'd0, 8'hA5, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill FIFO to Full", test_num);
            reset_dut();

            fifo_wr = 1;
            for (i = 0; i < 16; i = i + 1) begin
                data_in = i[7:0];
                @(posedge clk);
                #1;
            end
            fifo_wr = 0;


            #1;



            check_outputs(4'd0, 8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill and then Empty", test_num);
            reset_dut();


            fifo_wr = 1;
            for (i = 0; i < 16; i = i + 1) begin
                data_in = i[7:0] + 8'h10;
                @(posedge clk);
                #1;
            end
            fifo_wr = 0;


            fifo_rd = 1;
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            fifo_rd = 0;


            #1;



            check_outputs(4'd0, 8'h1F, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow Test", test_num);
            reset_dut();


            fifo_wr = 1;
            for (i = 0; i < 16; i = i + 1) begin
                data_in = i[7:0];
                @(posedge clk);
                #1;
            end


            data_in = 8'hFF;
            @(posedge clk);
            #1;
            fifo_wr = 0;


            #1;



            check_outputs(4'd0, 8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Underflow Test", test_num);
            reset_dut();


            fifo_rd = 1;
            @(posedge clk);
            #1;
            fifo_rd = 0;


            #1;



            check_outputs(4'd0, 8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Read/Write", test_num);
            reset_dut();


            fifo_wr = 1;
            data_in = 8'h55;
            @(posedge clk);
            #1;



            fifo_wr = 1;
            fifo_rd = 1;
            data_in = 8'h66;
            @(posedge clk);
            #1;
            fifo_wr = 0;
            fifo_rd = 0;


            #1;



            check_outputs(4'd1, 8'h55, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Half-Full Count Check", test_num);
            reset_dut();

            fifo_wr = 1;
            for (i = 0; i < 8; i = i + 1) begin
                data_in = i[7:0];
                @(posedge clk);
                #1;
            end
            fifo_wr = 0;


            #1;



            check_outputs(4'd8, 8'h00, 1'b0, 1'b0);
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
        input [3:0] expected_count;
        input [7:0] expected_data_out;
        input expected_empty;
        input expected_full;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: count=%h, data_out=%h, empty=%b, full=%b",
                         count, data_out, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, data_out=%h, empty=%b, full=%b",
                         expected_count, expected_data_out, expected_empty, expected_full);
                $display("  Got:      count=%h, data_out=%h, empty=%b, full=%b",
                         count, data_out, empty, full);
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
        $dumpvars(0,clk, data_in, fifo_rd, fifo_wr, rst_n, count, data_out, empty, full);
    end

endmodule
