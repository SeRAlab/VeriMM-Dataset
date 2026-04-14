`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] din;
    reg rd_en;
    reg rst;
    reg wr_en;
    wire [63:0] dout;
    wire empty;
    wire full;
    wire wr_rst_busy;

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
        .dout(dout),
        .empty(empty),
        .full(full),
        .wr_rst_busy(wr_rst_busy)
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
            repeat(2) @(posedge clk);
            #1;
            rst = 0;

            wait(wr_rst_busy == 0);
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial State", test_num);
            reset_dut();

            #1;


            check_outputs(64'bx, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Write/Read", test_num);
            reset_dut();


            wr_en = 1;
            din = 64'hAAAA_BBBB_CCCC_DDDD;
            @(posedge clk);
            #1;
            wr_en = 0;


            rd_en = 1;
            @(posedge clk);
            #1;
            rd_en = 0;


            #1;



            check_outputs(64'hAAAA_BBBB_CCCC_DDDD, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %03d: Fill to Capacity", test_num);
            reset_dut();

            wr_en = 1;
            for (i = 0; i < 12; i = i + 1) begin
                din = i + 1;
                @(posedge clk);
            end
            #1;
            wr_en = 0;


            #1;



            check_outputs(64'bx, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %03d: Fill and Drain", test_num);
            reset_dut();


            wr_en = 1;
            for (i = 0; i < 12; i = i + 1) begin
                din = 64'hF00D_0000 + i;
                @(posedge clk);
            end
            #1;
            wr_en = 0;


            rd_en = 1;
            for (i = 0; i < 11; i = i + 1) begin
                @(posedge clk);
            end
            #1;


            #1;



            check_outputs(64'hF00D_000B, 1'b1, 1'b0, 1'b0);
            rd_en = 0;
            @(posedge clk);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %03d: Overflow Handling", test_num);
            reset_dut();

            wr_en = 1;

            for (i = 0; i < 15; i = i + 1) begin
                din = i + 1;
                @(posedge clk);
            end
            #1;
            wr_en = 0;


            #1;



            check_outputs(64'bx, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Simultaneous Read/Write", test_num);
            reset_dut();


            wr_en = 1;
            din = 64'h1111_1111_1111_1111;
            @(posedge clk);
            #1;


            wr_en = 1;
            rd_en = 1;
            din = 64'h2222_2222_2222_2222;
            @(posedge clk);
            #1;
            wr_en = 0;
            rd_en = 0;



            #1;




            check_outputs(64'h1111_1111_1111_1111, 1'b0, 1'b0, 1'b0);
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
        input [63:0] expected_dout;
        input expected_empty;
        input expected_full;
        input expected_wr_rst_busy;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_wr_rst_busy === (expected_wr_rst_busy ^ wr_rst_busy ^ expected_wr_rst_busy)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, empty=%b, full=%b, wr_rst_busy=%b",
                         dout, empty, full, wr_rst_busy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, empty=%b, full=%b, wr_rst_busy=%b",
                         expected_dout, expected_empty, expected_full, expected_wr_rst_busy);
                $display("  Got:      dout=%h, empty=%b, full=%b, wr_rst_busy=%b",
                         dout, empty, full, wr_rst_busy);
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
        $dumpvars(0,clk, din, rd_en, rst, wr_en, dout, empty, full, wr_rst_busy);
    end

endmodule
