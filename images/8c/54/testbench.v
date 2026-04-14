`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [23:0] din;
    reg rd_en;
    reg rst;
    reg wr_en;
    wire [11:0] data_count;
    wire [23:0] dout;
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
            test_num = 1;
            reset_dut();


            $display("Testcase %0d: Initial Reset State", test_num);
            #1;

            check_outputs(12'h0, dout, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            wr_en = 1;
            din = 24'hAABBCC;
            @(posedge clk);
            #1 wr_en = 0;
            @(posedge clk);
            $display("Testcase %0d: Single Write", test_num);

            #1;


            check_outputs(12'h1, dout, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            wr_en = 1; din = 24'h111111;
            @(posedge clk);

            din = 24'h222222;
            @(posedge clk);
            #1 wr_en = 0;

            rd_en = 1;
            @(posedge clk);
            #1 rd_en = 0;
            @(posedge clk);
            $display("Testcase %0d: FIFO Data Order (Write 2, Read 1)", test_num);

            #1;


            check_outputs(12'h1, 24'h111111, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();
            wr_en = 1;
            for (i = 0; i < 4096; i = i + 1) begin
                din = i[23:0];
                @(posedge clk);
            end
            #1 wr_en = 0;
            @(posedge clk);
            $display("Testcase %0d: Fill to Capacity", test_num);

            #1;


            check_outputs(12'h0, dout, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();

            wr_en = 1;
            for (i = 0; i < 4096; i = i + 1) begin
                din = 24'hFFFFFF - i;
                @(posedge clk);
            end
            #1 wr_en = 0;

            rd_en = 1;
            for (i = 0; i < 4096; i = i + 1) begin
                @(posedge clk);
            end
            #1 rd_en = 0;
            @(posedge clk);
            $display("Testcase %0d: Fill and then Empty", test_num);

            #1;


            check_outputs(12'h0, 24'hFFF001, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            wr_en = 1;
            repeat(5) @(posedge clk);
            #1 wr_en = 0;

            wr_en = 1; rd_en = 1;
            din = 24'hDEADBE;
            @(posedge clk);
            #1 wr_en = 0; rd_en = 0;
            @(posedge clk);
            $display("Testcase %0d: Simultaneous Read/Write", test_num);
            #1;

            check_outputs(12'h5, dout, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            reset_dut();

            wr_en = 1;
            for (i = 0; i < 4096; i = i + 1) begin
                din = i;
                @(posedge clk);
            end

            din = 24'hEEEEEE;
            @(posedge clk);
            #1 wr_en = 0;
            @(posedge clk);
            $display("Testcase %0d: Overflow Protection (Write while full)", test_num);

            #1;


            check_outputs(12'h0, dout, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();

            rd_en = 1;
            repeat(3) @(posedge clk);
            #1 rd_en = 0;
            @(posedge clk);
            $display("Testcase %0d: Underflow Protection (Read while empty)", test_num);

            #1;


            check_outputs(12'h0, dout, 1'b1, 1'b0);
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
        input [11:0] expected_data_count;
        input [23:0] expected_dout;
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
