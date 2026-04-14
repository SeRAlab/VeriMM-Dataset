`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [103:0] din;
    reg rd_clk;
    reg rd_en;
    reg rst;
    reg wr_clk;
    reg wr_en;
    wire [103:0] dout;
    wire empty;
    wire full;
    wire prog_full;

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
        .full(full),
        .prog_full(prog_full)
    );
    task reset_system;

    begin
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        din = 0;
        repeat(5) @(posedge wr_clk);
        rst = 0;
        repeat(5) @(posedge wr_clk);
    end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Power-on Reset check", test_num);
        reset_system();



        #1;




        check_outputs(104'h0, 1, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Write check", test_num);
        reset_system();

        @(posedge wr_clk);
        wr_en = 1;
        din = 104'hA5A5A5A5A5A5A5A5A5A5A5A5A5;
        @(posedge wr_clk);
        wr_en = 0;


        repeat(10) @(posedge rd_clk);


        #1;



        check_outputs(104'h0, 1, 0, 0);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiple Writes check (Depth 16)", test_num);
        reset_system();

        @(posedge wr_clk);
        wr_en = 1;
        for (i = 0; i < 16; i = i + 1) begin
            din = i;
            @(posedge wr_clk);
        end
        wr_en = 0;

        repeat(10) @(posedge rd_clk);


        #1;



        check_outputs(104'h0, 1, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Read attempt check", test_num);
        reset_system();

        @(posedge rd_clk);
        rd_en = 1;
        repeat(5) @(posedge rd_clk);
        rd_en = 0;

        #1;


        check_outputs(104'h0, 1, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simultaneous WR/RD check", test_num);
        reset_system();

        fork
            begin
                @(posedge wr_clk);
                wr_en = 1;
                din = 104'hFFFFFFFFFFFFFFFFFFFFFFFFFF;
                repeat(5) @(posedge wr_clk);
                wr_en = 0;
            end
            begin
                @(posedge rd_clk);
                rd_en = 1;
                repeat(5) @(posedge rd_clk);
                rd_en = 0;
            end
        join

        repeat(5) @(posedge rd_clk);
        #1;

        check_outputs(104'h0, 1, 0, 0);
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
        input [103:0] expected_dout;
        input expected_empty;
        input expected_full;
        input expected_prog_full;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_prog_full === (expected_prog_full ^ prog_full ^ expected_prog_full)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, empty=%b, full=%b, prog_full=%b",
                         dout, empty, full, prog_full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, empty=%b, full=%b, prog_full=%b",
                         expected_dout, expected_empty, expected_full, expected_prog_full);
                $display("  Got:      dout=%h, empty=%b, full=%b, prog_full=%b",
                         dout, empty, full, prog_full);
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

endmodule
