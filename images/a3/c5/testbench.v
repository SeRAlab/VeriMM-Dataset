`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] din;
    reg rd_en;
    reg rst;
    reg wr_en;
    wire [6:0] data_count;
    wire [127:0] dout;
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
        .data_count(data_count),
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
            $display("Testcase 001: Initial Reset State");
            reset_dut();

            #1;


            check_outputs(7'd0, dout, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Write Operation");
            reset_dut();
            din = 128'hA1A2A3A4A5A6A7A8B1B2B3B4B5B6B7B8;
            wr_en = 1;
            @(posedge clk);
            #1 wr_en = 0;

            #1;


            check_outputs(7'd1, dout, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        reg [127:0] target_data;
        begin
            $display("Testcase 003: Single Write and Single Read (Data Integrity)");
            reset_dut();
            target_data = 128'hFEEDFACE_CAFEBABE_DEADBEEF_00001111;


            din = target_data;
            wr_en = 1;
            @(posedge clk);
            #1 wr_en = 0;


            rd_en = 1;
            @(posedge clk);
            #1 rd_en = 0;


            #1;



            check_outputs(7'd0, target_data, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        reg [127:0] data_val [0:2];
        begin
            $display("Testcase 004: Multiple Writes and Reads (FIFO Order)");
            reset_dut();
            data_val[0] = 128'h1; data_val[1] = 128'h2; data_val[2] = 128'h3;


            for(i=0; i<3; i=i+1) begin
                din = data_val[i];
                wr_en = 1;
                @(posedge clk);
            end
            #1 wr_en = 0;


            rd_en = 1;
            for(i=0; i<3; i=i+1) begin
                @(posedge clk);
                #1;
            end
            rd_en = 0;


            #1;



            check_outputs(7'd0, data_val[2], 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Testcase 005: Fill FIFO to check Full flag");
            reset_dut();
            wr_en = 1;
            for(i=0; i<64; i=i+1) begin
                din = i;
                @(posedge clk);
            end
            #1 wr_en = 0;



            #1;




            check_outputs(7'd64, dout, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Simultaneous Read and Write");
            reset_dut();


            din = 128'hAAAA;
            wr_en = 1;
            @(posedge clk);
            #1 wr_en = 0;


            din = 128'hBBBB;
            wr_en = 1;
            rd_en = 1;
            @(posedge clk);
            #1 wr_en = 0;
            rd_en = 0;


            #1;



            check_outputs(7'd1, 128'hAAAA, 1'b0, 1'b0);
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
        input [6:0] expected_data_count;
        input [127:0] expected_dout;
        input expected_empty;
        input expected_full;
        begin
            if (expected_data_count === (expected_data_count ^ data_count ^ expected_data_count) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: data_count=%h, dout=%h, empty=%b, full=%b",
                         data_count, dout, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_count=%h, dout=%h, empty=%b, full=%b",
                         expected_data_count, expected_dout, expected_empty, expected_full);
                $display("  Got:      data_count=%h, dout=%h, empty=%b, full=%b",
                         data_count, dout, empty, full);
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
        $dumpvars(0,clk, din, rd_en, rst, wr_en, data_count, dout, empty, full);
    end

endmodule
