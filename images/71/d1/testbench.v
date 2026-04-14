`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [64:0] din;
    reg rd_en;
    reg rst;
    reg wr_en;
    wire almost_full;
    wire [64:0] dout;
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
        .almost_full(almost_full),
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
            din = 0;
            wr_en = 0;
            rd_en = 0;
            repeat(10) @(posedge clk);
            rst = 0;

            repeat(5) @(posedge clk);
            while (wr_rst_busy) @(posedge clk);
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial State Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 65'bz, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Word Write/Read", test_num);
            reset_dut();


            @(posedge clk);
            wr_en = 1;
            din = 65'h1AAAA_BBBB_CCCC_DDDD;
            @(posedge clk);
            wr_en = 0;


            @(posedge clk);
            rd_en = 1;
            @(posedge clk);
            rd_en = 0;
            @(posedge clk);



            #1;




            check_outputs(1'b0, 65'h1AAAA_BBBB_CCCC_DDDD, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill to Full Status", test_num);
            reset_dut();

            @(posedge clk);
            wr_en = 1;

            for (i = 0; i < 16; i = i + 1) begin
                din = i;
                @(posedge clk);
            end
            wr_en = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b1, 65'bz, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        reg [64:0] last_val;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Integrity Sequence", test_num);
            reset_dut();


            @(posedge clk);
            wr_en = 1;
            for (i = 1; i <= 5; i = i + 1) begin
                din = (65'hA << i) | i;
                @(posedge clk);
            end
            wr_en = 0;


            @(posedge clk);
            rd_en = 1;
            for (i = 1; i <= 5; i = i + 1) begin
                last_val = (65'hA << i) | i;
                @(posedge clk);
            end
            rd_en = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0, last_val, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Almost Full Transition", test_num);
            reset_dut();

            @(posedge clk);
            wr_en = 1;


            for (i = 0; i < 14; i = i + 1) begin
                din = i;
                @(posedge clk);
            end
            wr_en = 0;
            repeat(2) @(posedge clk);



            #1;




            check_outputs(1'b1, 65'bz, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Read and Write", test_num);
            reset_dut();


            @(posedge clk);
            wr_en = 1;
            din = 65'h5555;
            @(posedge clk);



            rd_en = 1;
            din = 65'hAAAA;
            @(posedge clk);
            wr_en = 0;
            rd_en = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0, 65'h5555, 1'b0, 1'b0, 1'b0);
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
        input expected_almost_full;
        input [64:0] expected_dout;
        input expected_empty;
        input expected_full;
        input expected_wr_rst_busy;
        begin
            if (expected_almost_full === (expected_almost_full ^ almost_full ^ expected_almost_full) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_wr_rst_busy === (expected_wr_rst_busy ^ wr_rst_busy ^ expected_wr_rst_busy)) begin
                $display("PASS");
                $display("  Outputs: almost_full=%b, dout=%h, empty=%b, full=%b, wr_rst_busy=%b",
                         almost_full, dout, empty, full, wr_rst_busy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: almost_full=%b, dout=%h, empty=%b, full=%b, wr_rst_busy=%b",
                         expected_almost_full, expected_dout, expected_empty, expected_full, expected_wr_rst_busy);
                $display("  Got:      almost_full=%b, dout=%h, empty=%b, full=%b, wr_rst_busy=%b",
                         almost_full, dout, empty, full, wr_rst_busy);
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
        $dumpvars(0,clk, din, rd_en, rst, wr_en, almost_full, dout, empty, full, wr_rst_busy);
    end

endmodule
