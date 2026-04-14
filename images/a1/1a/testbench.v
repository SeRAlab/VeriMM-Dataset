`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] din;
    reg rst;
    reg wr_clk;
    reg wr_en;
    wire [31:0] dout;
    wire empty;
    wire full;
    wire prog_empty;
    wire prog_full;
    wire rd_clk;
    wire [4:0] rd_data_count;
    wire rd_en;
    wire [4:0] wr_data_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din(din),
        .rst(rst),
        .wr_clk(wr_clk),
        .wr_en(wr_en),
        .dout(dout),
        .empty(empty),
        .full(full),
        .prog_empty(prog_empty),
        .prog_full(prog_full),
        .rd_clk(rd_clk),
        .rd_data_count(rd_data_count),
        .rd_en(rd_en),
        .wr_data_count(wr_data_count)
    );

    // Clock generation (10ns period)
    initial begin
        wr_clk = 0;
        forever #5 wr_clk = ~wr_clk;
    end

        task reset_dut;

        begin
            rst = 1;
            wr_en = 0;
            din = 0;
            repeat(5) @(posedge wr_clk);
            #1;
            rst = 0;
            repeat(2) @(posedge wr_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset State Check...");
            reset_dut();



            #1;




            check_outputs(
                32'h0,
                1'b1,
                1'b0,
                1'b1,
                1'b0,
                wr_clk,
                5'd0,
                1'b0,
                5'd0
            );
            test_num = test_num + 1;
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Write...");
            reset_dut();

            @(posedge wr_clk);
            #1;
            wr_en = 1;
            din = 32'hDEADBEEF;
            @(posedge wr_clk);
            #1;
            wr_en = 0;
            repeat(2) @(posedge wr_clk);


            #1;



            check_outputs(
                32'h0,
                1'b0,
                1'b0,
                1'b1,
                1'b0,
                wr_clk,
                5'd1,
                rd_en,
                5'd1
            );
            test_num = test_num + 1;
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Running testcase003: Fill Halfway (8 Entries)...");
            reset_dut();

            for(i=0; i<8; i=i+1) begin
                @(posedge wr_clk);
                #1;
                wr_en = 1;
                din = i + 1;
            end
            @(posedge wr_clk);
            #1;
            wr_en = 0;
            repeat(2) @(posedge wr_clk);


            #1;



            check_outputs(
                dout,
                1'b0,
                1'b0,
                prog_empty,
                1'b0,
                wr_clk,
                5'd8,
                rd_en,
                5'd8
            );
            test_num = test_num + 1;
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Running testcase004: Fill to Full (16 Entries)...");
            reset_dut();

            for(i=0; i<16; i=i+1) begin
                @(posedge wr_clk);
                #1;
                wr_en = 1;
                din = 32'hA0 + i;
            end
            @(posedge wr_clk);
            #1;
            wr_en = 0;
            repeat(2) @(posedge wr_clk);


            #1;



            check_outputs(
                dout,
                1'b0,
                1'b1,
                1'b0,
                1'b1,
                wr_clk,
                5'd16,
                rd_en,
                5'd16
            );
            test_num = test_num + 1;
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Running testcase005: Overflow Attempt...");
            reset_dut();


            for(i=0; i<20; i=i+1) begin
                @(posedge wr_clk);
                #1;
                wr_en = 1;
                din = i;
            end
            @(posedge wr_clk);
            #1;
            wr_en = 0;
            repeat(2) @(posedge wr_clk);


            #1;



            check_outputs(
                dout,
                1'b0,
                1'b1,
                1'b0,
                1'b1,
                wr_clk,
                5'd16,
                rd_en,
                5'd16
            );
            test_num = test_num + 1;
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
        input [31:0] expected_dout;
        input expected_empty;
        input expected_full;
        input expected_prog_empty;
        input expected_prog_full;
        input expected_rd_clk;
        input [4:0] expected_rd_data_count;
        input expected_rd_en;
        input [4:0] expected_wr_data_count;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_prog_empty === (expected_prog_empty ^ prog_empty ^ expected_prog_empty) &&
                expected_prog_full === (expected_prog_full ^ prog_full ^ expected_prog_full) &&
                expected_rd_clk === (expected_rd_clk ^ rd_clk ^ expected_rd_clk) &&
                expected_rd_data_count === (expected_rd_data_count ^ rd_data_count ^ expected_rd_data_count) &&
                expected_rd_en === (expected_rd_en ^ rd_en ^ expected_rd_en) &&
                expected_wr_data_count === (expected_wr_data_count ^ wr_data_count ^ expected_wr_data_count)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, empty=%b, full=%b, prog_empty=%b, prog_full=%b, rd_clk=%b, rd_data_count=%h, rd_en=%b, wr_data_count=%h",
                         dout, empty, full, prog_empty, prog_full, rd_clk, rd_data_count, rd_en, wr_data_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, empty=%b, full=%b, prog_empty=%b, prog_full=%b, rd_clk=%b, rd_data_count=%h, rd_en=%b, wr_data_count=%h",
                         expected_dout, expected_empty, expected_full, expected_prog_empty, expected_prog_full, expected_rd_clk, expected_rd_data_count, expected_rd_en, expected_wr_data_count);
                $display("  Got:      dout=%h, empty=%b, full=%b, prog_empty=%b, prog_full=%b, rd_clk=%b, rd_data_count=%h, rd_en=%b, wr_data_count=%h",
                         dout, empty, full, prog_empty, prog_full, rd_clk, rd_data_count, rd_en, wr_data_count);
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
        $dumpvars(0,din, rst, wr_clk, wr_en, dout, empty, full, prog_empty, prog_full, rd_clk, rd_data_count, rd_en, wr_data_count);
    end

endmodule
