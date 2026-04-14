`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data1;
    reg [3:0] data2;
    reg [1:0] op;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data1(data1),
        .data2(data2),
        .op(op),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        data1 = 0;
        data2 = 0;
        op = 0;
        @(posedge clk);
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Addition (5 + 3)", test_num);
        reset_dut();
        data1 = 4'd5;
        data2 = 4'd3;
        op = 2'b00;

        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Subtraction (10 - 4)", test_num);
        reset_dut();
        data1 = 4'd10;
        data2 = 4'd4;
        op = 2'b01;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Bitwise AND (12 & 7)", test_num);
        reset_dut();
        data1 = 4'b1100;
        data2 = 4'b0111;
        op = 2'b10;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Bitwise OR (10 | 5)", test_num);
        reset_dut();
        data1 = 4'b1010;
        data2 = 4'b0101;
        op = 2'b11;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Addition Overflow (15 + 1)", test_num);
        reset_dut();
        data1 = 4'd15;
        data2 = 4'd1;
        op = 2'b00;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Subtraction Underflow (0 - 1)", test_num);
        reset_dut();
        data1 = 4'd0;
        data2 = 4'd1;
        op = 2'b01;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(4'd15);
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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data1, data2, op, q);
    end

endmodule
