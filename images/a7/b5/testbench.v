`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg rst;
    reg wen;
    wire [7:0] dout;
    wire empty;
    wire full;
    wire ren;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .rst(rst),
        .wen(wen),
        .dout(dout),
        .empty(empty),
        .full(full),
        .ren(ren)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        wen = 0;
        din = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Reset State Check", test_num);
        reset_dut();

        #1;


        check_outputs(8'h00, 1, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Single Write", test_num);
        reset_dut();
        @(posedge clk);
        wen = 1;
        din = 8'hA5;
        @(posedge clk);
        wen = 0;
        #2;

        #1;


        check_outputs(8'hA5, 0, 0, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Fill to Full (16 entries)", test_num);
        reset_dut();
        @(posedge clk);
        wen = 1;
        for (i = 0; i < 16; i = i + 1) begin
            din = i[7:0];
            @(posedge clk);
        end
        wen = 0;
        #2;

        #1;


        check_outputs(8'h00, 0, 1, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Overflow Check (17 writes)", test_num);
        reset_dut();
        @(posedge clk);
        wen = 1;
        for (i = 0; i < 17; i = i + 1) begin
            din = i[7:0];
            @(posedge clk);
        end
        wen = 0;
        #2;

        #1;


        check_outputs(8'h00, 0, 1, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Partial Fill Check", test_num);
        reset_dut();
        @(posedge clk);
        wen = 1;
        for (i = 0; i < 8; i = i + 1) begin
            din = 8'h10 + i[7:0];
            @(posedge clk);
        end
        wen = 0;
        #2;

        #1;


        check_outputs(8'h10, 0, 0, 1);
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
        input [7:0] expected_dout;
        input expected_empty;
        input expected_full;
        input expected_ren;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_ren === (expected_ren ^ ren ^ expected_ren)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, empty=%b, full=%b, ren=%b",
                         dout, empty, full, ren);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, empty=%b, full=%b, ren=%b",
                         expected_dout, expected_empty, expected_full, expected_ren);
                $display("  Got:      dout=%h, empty=%b, full=%b, ren=%b",
                         dout, empty, full, ren);
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
        $dumpvars(0,clk, din, rst, wen, dout, empty, full, ren);
    end

endmodule
