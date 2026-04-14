`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [30:0] din;
    reg rd_clk;
    reg rd_en;
    reg rst;
    reg wr_clk;
    reg wr_en;
    wire [30:0] dout;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din(din),
        .rd_clk(rd_clk),
        .rd_en(rd_en),
        .rst(rst),
        .wr_clk(wr_clk),
        .wr_en(wr_en),
        .dout(dout),
        .empty(empty),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        rd_clk = 0;
        forever #5 rd_clk = ~rd_clk;
    end

        task reset_dut;

        begin
            rst = 1;
            wr_en = 0;
            rd_en = 0;
            din = 0;
            repeat(5) @(posedge wr_clk);
            rst = 0;
            repeat(5) @(posedge wr_clk);
            repeat(5) @(posedge rd_clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Initial State Check");
            reset_dut();

            #1;


            check_outputs(dout, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Single Write/Read Integrity");
            reset_dut();


            @(posedge wr_clk);
            wr_en = 1;
            din = 31'h7FFFFFFF;
            @(posedge wr_clk);
            wr_en = 0;


            repeat(10) @(posedge rd_clk);


            rd_en = 1;
            @(posedge rd_clk);
            rd_en = 0;
            @(posedge rd_clk);

            #1;


            check_outputs(31'h7FFFFFFF, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Fill to Full Flag");
            reset_dut();

            wr_en = 1;
            for (i = 0; i < 16; i = i + 1) begin
                din = i;
                @(posedge wr_clk);
            end
            wr_en = 0;


            repeat(5) @(posedge wr_clk);

            #1;


            check_outputs(dout, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Empty from Full Check");
            reset_dut();


            wr_en = 1;
            for (i = 0; i < 16; i = i + 1) begin
                din = i + 10;
                @(posedge wr_clk);
            end
            wr_en = 0;

            repeat(5) @(posedge rd_clk);


            rd_en = 1;
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge rd_clk);
            end
            rd_en = 0;


            repeat(10) @(posedge rd_clk);


            #1;



            check_outputs(31'd25, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Overflow Check");
            reset_dut();


            wr_en = 1;
            for (i = 0; i < 20; i = i + 1) begin
                din = i + 100;
                @(posedge wr_clk);
            end
            wr_en = 0;

            repeat(5) @(posedge wr_clk);


            #1;



            check_outputs(dout, 1'b0, 1'b1);
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
        input [30:0] expected_dout;
        input expected_empty;
        input expected_full;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, empty=%b, full=%b",
                         dout, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, empty=%b, full=%b",
                         expected_dout, expected_empty, expected_full);
                $display("  Got:      dout=%h, empty=%b, full=%b",
                         dout, empty, full);
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
        $dumpvars(0,din, rd_clk, rd_en, rst, wr_clk, wr_en, dout, empty, full);
    end

endmodule
