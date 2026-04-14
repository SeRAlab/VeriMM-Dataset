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
            din = 0;
            mode = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(20'h0, 1'b1, 1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk);
            en = 1;
            mode = 2'b00;
            we = 1;
            din = 32'hABCDE123;
            @(posedge clk);
            we = 0;
            re = 1;
            @(posedge clk);
            re = 0;


            #1;



            check_outputs(20'hABCDE, 1'b1, 1'b0, 2'b00);
        end
        endtask

    task testcase003;

        integer i;
        begin
            reset_dut();
            en = 1;
            we = 1;
            for (i = 0; i < 8; i = i + 1) begin
                din = i;
                @(posedge clk);
            end
            we = 0;

            #1;


            check_outputs(dout, 1'b0, 1'b1, status);
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();
            en = 1;
            we = 1;
            for (i = 1; i <= 8; i = i + 1) begin
                din = {i[15:0], 16'hFFFF};
                @(posedge clk);
            end
            we = 0;
            re = 1;
            for (i = 1; i <= 7; i = i + 1) begin
                @(posedge clk);
            end

            @(posedge clk);
            re = 0;

            #1;


            check_outputs(20'h0008F, 1'b1, 1'b0, 2'b00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            en = 0;
            we = 1;
            din = 32'hFFFFFFFF;
            repeat (2) @(posedge clk);
            we = 0;

            #1;


            check_outputs(20'h0, 1'b1, 1'b0, 2'b00);
        end
        endtask

    task testcase006;

        integer i;
        begin
            reset_dut();
            en = 1;
            we = 1;
            for (i = 0; i < 12; i = i + 1) begin
                din = i;
                @(posedge clk);
            end
            we = 0;

            #1;


            check_outputs(dout, 1'b0, 1'b1, status);
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
