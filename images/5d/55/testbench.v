`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg rd_en;
    reg rst;
    reg wr_en;
    wire [7:0] dout;
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
            test_num = test_num + 1;
            $display("Test %0d: Initial Reset State", test_num);
            reset_dut();

            #1 #1;
 check_outputs(dout, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Write then Read", test_num);
            reset_dut();


            din = 8'hA5; wr_en = 1;
            @(posedge clk);
            #1 wr_en = 0;


            rd_en = 1;
            @(posedge clk);
            #1 rd_en = 0;


            #1;



            check_outputs(8'hA5, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Fill to Full (16 entries)", test_num);
            reset_dut();

            wr_en = 1;
            for (i = 0; i < 16; i = i + 1) begin
                din = i[7:0];
                @(posedge clk);
            end
            #1 wr_en = 0;


            #1;



            check_outputs(dout, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data Integrity (First-In-First-Out)", test_num);
            reset_dut();


            @(posedge clk);
            din = 8'h11; wr_en = 1; @(posedge clk);
            din = 8'h22; wr_en = 1; @(posedge clk);
            din = 8'h33; wr_en = 1; @(posedge clk);
            #1 wr_en = 0;


            rd_en = 1; @(posedge clk); #1;

            @(posedge clk); #1;

            @(posedge clk); #1;
            rd_en = 0;

            #1;


            check_outputs(8'h33, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow handling", test_num);
            reset_dut();

            wr_en = 1;

            for (i = 0; i < 17; i = i + 1) begin
                din = i[7:0];
                @(posedge clk);
            end
            #1 wr_en = 0;


            rd_en = 1;
            for (i = 0; i < 15; i = i + 1) begin
                @(posedge clk);
            end
            @(posedge clk);
            #1 rd_en = 0;


            #1;



            check_outputs(8'h0F, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full to Empty transition", test_num);
            reset_dut();


            wr_en = 1;
            for (i = 0; i < 16; i = i + 1) begin
                din = i; @(posedge clk);
            end
            #1 wr_en = 0;


            rd_en = 1;
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
            end
            #1 rd_en = 0;

            #1;


            check_outputs(8'h0F, 1'b1, 1'b0);
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
        input [7:0] expected_dout;
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
        $dumpvars(0,clk, din, rd_en, rst, wr_en, dout, empty, full);
    end

endmodule
