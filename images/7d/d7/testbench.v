`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg [1:0] op;
    reg rst;
    reg start;
    wire done;
    wire [7:0] result;

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
        .start(start),
        .done(done),
        .result(result)
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
            start = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Addition (15 + 27)", test_num);
            a = 8'd15;
            b = 8'd27;
            op = 2'b00;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd42);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Subtraction (100 - 45)", test_num);
            a = 8'd100;
            b = 8'd45;
            op = 2'b01;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Multiplication (12 * 8)", test_num);
            a = 8'd12;
            b = 8'd8;
            op = 2'b10;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd96);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Division (144 / 12)", test_num);
            a = 8'd144;
            b = 8'd12;
            op = 2'b11;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Addition Overflow (250 + 10)", test_num);
            a = 8'd250;
            b = 8'd10;
            op = 2'b00;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %0d: Subtraction Underflow (5 - 10)", test_num);
            a = 8'd5;
            b = 8'd10;
            op = 2'b01;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd251);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Testcase %0d: Multiplication Overflow (16 * 16)", test_num);
            a = 8'd16;
            b = 8'd16;
            op = 2'b10;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            $display("Testcase %0d: Division Truncation (10 / 3)", test_num);
            a = 8'd10;
            b = 8'd3;
            op = 2'b11;
            start = 1;
            @(posedge clk);
            #1 start = 0;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd3);
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
        input expected_done;
        input [7:0] expected_result;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: done=%b, result=%h",
                         done, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, result=%h",
                         expected_done, expected_result);
                $display("  Got:      done=%b, result=%h",
                         done, result);
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
        $dumpvars(0,a, b, clk, op, rst, start, done, result);
    end

endmodule
