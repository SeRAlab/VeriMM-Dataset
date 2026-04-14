`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [1:0] op;
    reg rst;
    wire [7:0] out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in1(in1),
        .in2(in2),
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
            in1 = 0;
            in2 = 0;
            op = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Check");
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Addition (15 + 25)");
            reset_dut();
            in1 = 8'd15;
            in2 = 8'd25;
            op = 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd40, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Subtraction (100 - 40)");
            reset_dut();
            in1 = 8'd100;
            in2 = 8'd40;
            op = 2'b01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd60, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Multiplication (12 * 10)");
            reset_dut();
            in1 = 8'd12;
            in2 = 8'd10;
            op = 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd120, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Division (80 / 4)");
            reset_dut();
            in1 = 8'd80;
            in2 = 8'd4;
            op = 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd20, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Subtraction Wrap-around (10 - 20)");
            reset_dut();
            in1 = 8'd10;
            in2 = 8'd20;
            op = 2'b01;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hF6, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Multiplication Overflow (100 * 3)");
            reset_dut();
            in1 = 8'd100;
            in2 = 8'd3;
            op = 2'b10;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'd44, 1'b1);
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
        $dumpvars(0,clk, in1, in2, op, rst, out, valid);
    end

endmodule
