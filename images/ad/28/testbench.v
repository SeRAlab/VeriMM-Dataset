`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [68:0] data_in;
    reg rd_en;
    reg rst;
    reg wr_en;
    wire [68:0] data_out;
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
            #15;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(69'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Write/Read", test_num);
            reset_dut();


            @(posedge clk);
            wr_en = 1;
            data_in = 69'h1ABCDEF0123456789;
            @(posedge clk);
            wr_en = 0;


            @(posedge clk);
            rd_en = 1;
            @(posedge clk);
            rd_en = 0;
            #1;


            #1;



            check_outputs(69'h1ABCDEF0123456789, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Fill to Capacity", test_num);
            reset_dut();

            @(posedge clk);
            wr_en = 1;
            for (i = 0; i < 32; i = i + 1) begin
                data_in = i + 69'h500;
                @(posedge clk);
            end
            wr_en = 0;
            #1;


            #1;



            check_outputs(69'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Fill and Empty", test_num);
            reset_dut();


            @(posedge clk);
            wr_en = 1;
            for (i = 0; i < 32; i = i + 1) begin
                data_in = i + 69'hA00;
                @(posedge clk);
            end
            wr_en = 0;


            @(posedge clk);
            rd_en = 1;
            for (i = 0; i < 31; i = i + 1) begin
                @(posedge clk);
            end

            @(posedge clk);
            rd_en = 0;
            #1;


            #1;



            check_outputs(69'hA00 + 31, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: FIFO Data Integrity", test_num);
            reset_dut();


            @(posedge clk);
            wr_en = 1;
            data_in = 69'h111; @(posedge clk);
            data_in = 69'h222; @(posedge clk);
            data_in = 69'h333; @(posedge clk);
            wr_en = 0;


            @(posedge clk);
            rd_en = 1;
            @(posedge clk);

            if (data_out !== 69'h111) fail_count = fail_count + 1;
            else pass_count = pass_count + 1;


            @(posedge clk);

            if (data_out !== 69'h222) fail_count = fail_count + 1;
            else pass_count = pass_count + 1;


            @(posedge clk);
            rd_en = 0;
            #1;


            #1;



            check_outputs(69'h333, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Simultaneous Read/Write", test_num);
            reset_dut();


            wr_en = 1;
            for (i = 0; i < 5; i = i + 1) begin
                data_in = i + 1;
                @(posedge clk);
            end


            rd_en = 1;
            data_in = 69'h999;
            @(posedge clk);
            wr_en = 0;
            rd_en = 0;
            #1;



            #1;




            check_outputs(69'h1, 1'b0, 1'b0);
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
        input [68:0] expected_data_out;
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
