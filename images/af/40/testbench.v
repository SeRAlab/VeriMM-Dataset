`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg [1:0] op;
    reg rst;
    wire [7:0] out;
    wire overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .op(op),
        .rst(rst),
        .out(out),
        .overflow(overflow)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        a = 0;
        b = 0;
        op = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = 8'sd15; b = 8'sd25; op = 2'b00;
        @(posedge clk);
        #1 #1;
 check_outputs(8'sd40, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = 8'sd100; b = 8'sd50; op = 2'b00;
        @(posedge clk);
        #1 #1;
 check_outputs(8'sd100 + 8'sd50, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = -8'sd100; b = -8'sd50; op = 2'b00;
        @(posedge clk);
        #1 #1;
 check_outputs(-8'sd100 + -8'sd50, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = 8'sd50; b = 8'sd20; op = 2'b01;
        @(posedge clk);
        #1 #1;
 check_outputs(8'sd30, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = 8'sd100; b = -8'sd40; op = 2'b01;
        @(posedge clk);
        #1 #1;
 check_outputs(8'sd100 - (-8'sd40), 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = 8'sd10; b = 8'sd12; op = 2'b10;
        @(posedge clk);
        #1 #1;
 check_outputs(8'sd120, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = 8'sd20; b = 8'sd10; op = 2'b10;
        @(posedge clk);
        #1 #1;
 check_outputs(8'sd200, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = -8'sd20; b = 8'sd10; op = 2'b10;
        @(posedge clk);
        #1 #1;
 check_outputs(-8'sd200, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = 8'sd100; b = 8'sd4; op = 2'b11;
        @(posedge clk);
        #1 #1;
 check_outputs(8'sd25, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = 8'sd50; b = 8'sd0; op = 2'b11;
        @(posedge clk);
        #1 #1;
 check_outputs(out, 1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = -8'sd80; b = 8'sd2; op = 2'b11;
        @(posedge clk);
        #1 #1;
 check_outputs(-8'sd40, 1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        reset_dut();
        a = -8'sd128; b = -8'sd1; op = 2'b11;
        @(posedge clk);
        #1 #1;
 check_outputs(out, 1'b1);
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [7:0] expected_out;
        input expected_overflow;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow)) begin
                $display("PASS");
                $display("  Outputs: out=%h, overflow=%b",
                         out, overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, overflow=%b",
                         expected_out, expected_overflow);
                $display("  Got:      out=%h, overflow=%b",
                         out, overflow);
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
        $dumpvars(0,a, b, clk, op, rst, out, overflow);
    end

endmodule
