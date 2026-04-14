`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg op;
    reg rst;
    wire [7:0] out;
    wire valid;

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
        .valid(valid)
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
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic Addition (10 + 20)", test_num);
            reset_dut();
            a = 8'd10;
            b = 8'd20;
            op = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd30, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Basic Subtraction (50 - 20)", test_num);
            reset_dut();
            a = 8'd50;
            b = 8'd20;
            op = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd30, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Addition with Overflow (255 + 1)", test_num);
            reset_dut();
            a = 8'hFF;
            b = 8'h01;
            op = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Subtraction with Underflow (0 - 1)", test_num);
            reset_dut();
            a = 8'h00;
            b = 8'h01;
            op = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Subtraction resulting in Zero (100 - 100)", test_num);
            reset_dut();
            a = 8'd100;
            b = 8'd100;
            op = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Max values Addition (255 + 255)", test_num);
            reset_dut();
            a = 8'hFF;
            b = 8'hFF;
            op = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFE, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Verify Reset State", test_num);

            a = 8'hAA;
            b = 8'h55;
            op = 1'b0;
            rst = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 1'b0);
            rst = 0;
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
        input [7:0] expected_out;
        input expected_valid;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: out=%h, valid=%b",
                         out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, valid=%b",
                         expected_out, expected_valid);
                $display("  Got:      out=%h, valid=%b",
                         out, valid);
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
        $dumpvars(0,a, b, clk, op, rst, out, valid);
    end

endmodule
