`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg rd_en;
    reg rst;
    reg wr_en;
    wire [3:0] count;
    wire [15:0] data_out;
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
            rst = 1;
            wr_en = 0;
            rd_en = 0;
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Initial State after Reset", test_num);
            reset_dut();

            #1;


            check_outputs(4'd0, 16'h0000, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Single Write", test_num);
            reset_dut();
            wr_en = 1;
            data_in = 16'hABCD;
            @(posedge clk);
            #1 wr_en = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd1, 16'hABCD, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Write then Read", test_num);
            reset_dut();

            wr_en = 1;
            data_in = 16'h1234;
            @(posedge clk);
            #1 wr_en = 0;

            rd_en = 1;
            @(posedge clk);
            #1 rd_en = 0;
            @(posedge clk);

            #1;


            check_outputs(4'd0, 16'h1234, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("\nTestcase %0d: Fill FIFO to 15 entries", test_num);
            reset_dut();
            wr_en = 1;
            for (i = 0; i < 15; i = i + 1) begin
                data_in = i;
                @(posedge clk);
            end
            #1 wr_en = 0;
            @(posedge clk);


            #1;



            check_outputs(4'd15, 16'h0000, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("\nTestcase %0d: Fill FIFO to 16 entries (Full)", test_num);
            reset_dut();
            wr_en = 1;
            for (i = 0; i < 16; i = i + 1) begin
                data_in = i + 16'hA000;
                @(posedge clk);
            end
            #1 wr_en = 0;
            @(posedge clk);



            #1;




            check_outputs(count, 16'hA000, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Sequential Writes and Reads", test_num);
            reset_dut();


            wr_en = 1;
            data_in = 16'h1111; @(posedge clk);
            data_in = 16'h2222; @(posedge clk);
            data_in = 16'h3333; @(posedge clk);
            #1 wr_en = 0;


            rd_en = 1; @(posedge clk);
            #1 rd_en = 0;
            @(posedge clk);


            #1;



            check_outputs(4'd2, 16'h1111, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Simultaneous Read and Write", test_num);
            reset_dut();


            wr_en = 1;
            data_in = 16'hAAAA; @(posedge clk);
            data_in = 16'hBBBB; @(posedge clk);
            #1 wr_en = 0;


            wr_en = 1;
            rd_en = 1;
            data_in = 16'hCCCC;
            @(posedge clk);
            #1 wr_en = 0; rd_en = 0;
            @(posedge clk);


            #1;



            check_outputs(4'd2, 16'hAAAA, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        integer i;
        begin
            test_num = 8;
            $display("\nTestcase %0d: Emptying after Full", test_num);
            reset_dut();


            wr_en = 1;
            for(i=0; i<16; i=i+1) begin
                data_in = i;
                @(posedge clk);
            end
            #1 wr_en = 0;


            rd_en = 1;
            for(i=0; i<16; i=i+1) begin
                @(posedge clk);
            end
            #1 rd_en = 0;
            @(posedge clk);


            #1;



            check_outputs(4'd0, 16'h000f, 1'b1, 1'b0);
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, rd_en, rst, wr_en, count, data_out, empty, full);
    end

endmodule
