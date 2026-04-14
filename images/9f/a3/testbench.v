`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] din;
    reg en;
    reg [1:0] mode;
    reg re;
    reg rst;
    reg we;
    wire [19:0] dout;
    wire empty;
    wire full;
    wire [1:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .en(en),
        .mode(mode),
        .re(re),
        .rst(rst),
        .we(we),
        .dout(dout),
        .empty(empty),
        .full(full),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            we = 0;
            re = 0;
            mode = 0;
            din = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(20'hx, 1'b1, 1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            en = 1;
            mode = 2'b10;
            din = 32'h000ABCDE;
            we = 1;
            @(posedge clk);
            we = 0;
            @(posedge clk);
            re = 1;
            @(posedge clk);
            re = 0;

            #1;


            check_outputs(20'hABCDE, 1'b1, 1'b0, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            en = 1;
            mode = 2'b01;
            din = 32'h12345678;
            we = 1;
            @(posedge clk);
            we = 0;

            re = 1;
            @(posedge clk);

            @(posedge clk);
            re = 0;

            #1;


            check_outputs(20'h56780, 1'b1, 1'b0, 2'b00);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();
            en = 1;
            mode = 2'b10;
            we = 1;
            for (i = 0; i < 16; i = i + 1) begin
                din = i;
                @(posedge clk);
            end
            we = 0;

            #1;


            check_outputs(20'hx, 1'b0, 1'b1, 2'b11);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();
            en = 1;
            mode = 2'b10;
            we = 1;
            for (i = 0; i < 16; i = i + 1) begin
                din = i;
                @(posedge clk);
            end
            we = 0;
            re = 1;
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
            end
            re = 0;

            #1;


            check_outputs(20'h0000F, 1'b1, 1'b0, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            en = 0;
            we = 1;
            din = 32'hFFFFF;
            @(posedge clk);
            we = 0;

            #1;


            check_outputs(20'hx, 1'b1, 1'b0, 2'b00);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            reset_dut();
            en = 1;
            mode = 2'b10;
            we = 1;
            for (i = 0; i < 8; i = i + 1) begin
                din = i;
                @(posedge clk);
            end
            we = 0;

            #1;


            check_outputs(20'hx, 1'b0, 1'b0, 2'b10);
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
        input [19:0] expected_dout;
        input expected_empty;
        input expected_full;
        input [1:0] expected_status;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, empty=%b, full=%b, status=%h",
                         dout, empty, full, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, empty=%b, full=%b, status=%h",
                         expected_dout, expected_empty, expected_full, expected_status);
                $display("  Got:      dout=%h, empty=%b, full=%b, status=%h",
                         dout, empty, full, status);
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
        $dumpvars(0,clk, din, en, mode, re, rst, we, dout, empty, full, status);
    end

endmodule
