`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rd_en;
    reg rst_n;
    reg wr_en;
    wire [5:0] count;
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
        .rst_n(rst_n),
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
        rst_n = 1'b0;
        wr_en = 1'b0;
        rd_en = 1'b0;
        data_in = 8'h00;
        #15;
        rst_n = 1'b1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Initial Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(6'd0, data_out, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Single Write", test_num);
        reset_dut();

        data_in = 8'hA5;
        wr_en = 1'b1;
        @(posedge clk);
        #1;
        wr_en = 1'b0;


        #1;



        check_outputs(6'd1, 8'hA5, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Write and Read Back", test_num);
        reset_dut();


        data_in = 8'hA5;
        wr_en = 1'b1;
        @(posedge clk);
        #1;
        wr_en = 1'b0;


        rd_en = 1'b1;
        @(posedge clk);
        #1;
        rd_en = 1'b0;


        #1;



        check_outputs(6'd0, data_out, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

        integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Fill FIFO to Full", test_num);
        reset_dut();

        wr_en = 1'b1;
        for (i = 0; i < 64; i = i + 1) begin
            data_in = i[7:0];
            @(posedge clk);
            #1;
        end
        wr_en = 1'b0;


        #1;



        check_outputs(6'd0, 8'h00, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

        integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Empty Full FIFO", test_num);
        reset_dut();


        wr_en = 1'b1;
        for (i = 0; i < 64; i = i + 1) begin
            data_in = i[7:0];
            @(posedge clk);
            #1;
        end
        wr_en = 1'b0;


        rd_en = 1'b1;
        for (i = 0; i < 64; i = i + 1) begin
            @(posedge clk);
            #1;
        end
        rd_en = 1'b0;


        #1;



        check_outputs(6'd0, data_out, 1'b1, 1'b0);
    end
        endtask

    task testcase006;

        integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Overflow Test", test_num);
        reset_dut();


        wr_en = 1'b1;
        for (i = 0; i < 65; i = i + 1) begin
            data_in = i[7:0];
            @(posedge clk);
            #1;
        end
        wr_en = 1'b0;



        #1;




        check_outputs(6'd0, 8'h00, 1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Underflow Test", test_num);
        reset_dut();


        rd_en = 1'b1;
        @(posedge clk);
        #1;
        rd_en = 1'b0;


        #1;



        check_outputs(6'd0, data_out, 1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Simultaneous Read/Write", test_num);
        reset_dut();


        data_in = 8'h11;
        wr_en = 1'b1;
        @(posedge clk);
        #1;


        data_in = 8'h22;
        wr_en = 1'b1;
        rd_en = 1'b1;
        @(posedge clk);
        #1;
        wr_en = 1'b0;
        rd_en = 1'b0;


        #1;



        check_outputs(6'd1, 8'h22, 1'b0, 1'b0);
    end
        endtask

    task testcase009;

        integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Pointer Wrap-around", test_num);
        reset_dut();


        wr_en = 1'b1;
        for (i = 0; i < 40; i = i + 1) begin
            data_in = i[7:0];
            @(posedge clk);
            #1;
        end
        wr_en = 1'b0;


        rd_en = 1'b1;
        for (i = 0; i < 30; i = i + 1) begin
            @(posedge clk);
            #1;
        end
        rd_en = 1'b0;


        wr_en = 1'b1;
        for (i = 0; i < 40; i = i + 1) begin
            data_in = 8'hFF;
            @(posedge clk);
            #1;
        end
        wr_en = 1'b0;


        #1;



        check_outputs(6'd0, 8'h1E, 1'b0, 1'b1);
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
        testcase009();
        
        
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
        input [5:0] expected_count;
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
        $dumpvars(0,clk, data_in, rd_en, rst_n, wr_en, count, data_out, empty, full);
    end

endmodule
