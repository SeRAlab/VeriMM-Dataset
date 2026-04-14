`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [1:0] op;
    reg rst;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .in1(in1),
        .in2(in2),
        .op(op),
        .rst(rst),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            clr = 0;
            in1 = 0;
            in2 = 0;
            op = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Addition (15 + 25)");
            reset_dut();
            in1 = 8'd15;
            in2 = 8'd25;
            op = 2'b00;
            clr = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd40);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Subtraction (50 - 20)");
            reset_dut();
            in1 = 8'd50;
            in2 = 8'd20;
            op = 2'b01;
            clr = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Multiplication (12 * 4)");
            reset_dut();
            in1 = 8'd12;
            in2 = 8'd4;
            op = 2'b10;
            clr = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd48);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Division (100 / 5)");
            reset_dut();
            in1 = 8'd100;
            in2 = 8'd5;
            op = 2'b11;
            clr = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd20);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Addition Overflow (200 + 100)");
            reset_dut();
            in1 = 8'd200;
            in2 = 8'd100;
            op = 2'b00;
            clr = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'd44);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Subtraction Underflow (10 - 20)");
            reset_dut();
            in1 = 8'd10;
            in2 = 8'd20;
            op = 2'b01;
            clr = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'd246);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Multiplication Overflow (64 * 5)");
            reset_dut();
            in1 = 8'd64;
            in2 = 8'd5;
            op = 2'b10;
            clr = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'd64);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Clear Signal (Output should be 0)");
            reset_dut();
            in1 = 8'd50;
            in2 = 8'd50;
            op = 2'b00;
            clr = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Division (0 / 10)");
            reset_dut();
            in1 = 8'd0;
            in2 = 8'd10;
            op = 2'b11;
            clr = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Reset during operation");
            reset_dut();
            in1 = 8'd255;
            in2 = 8'd1;
            op = 2'b00;
            @(posedge clk);
            rst = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd0);
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
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, clr, in1, in2, op, rst, out);
    end

endmodule
