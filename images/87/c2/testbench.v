`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg [2:0] op;
    reg reset;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .op(op),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 0;
            A = 0;
            B = 0;
            op = 0;
            @(posedge clk);
            #1 reset = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            A = 8'd45;
            B = 8'd55;
            op = 3'd0;
            @(posedge clk);
            #1;
            $display("Testcase 001: Addition (45 + 55)");
            #1;

            check_outputs(16'd100);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            A = 8'd100;
            B = 8'd40;
            op = 3'd1;
            @(posedge clk);
            #1;
            $display("Testcase 002: Subtraction (100 - 40)");
            #1;

            check_outputs(16'd60);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            A = 8'd12;
            B = 8'd10;
            op = 3'd2;
            @(posedge clk);
            #1;
            $display("Testcase 003: Multiplication (12 * 10)");
            #1;

            check_outputs(16'd120);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            A = 8'd144;
            B = 8'd12;
            op = 3'd3;
            @(posedge clk);
            #1;
            $display("Testcase 004: Division (144 / 12)");
            #1;

            check_outputs(16'd12);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            A = 8'hFF;
            B = 8'hFF;
            op = 3'd0;
            reset = 0;
            @(posedge clk);
            #1;
            $display("Testcase 005: Reset Initialization");
            #1;

            check_outputs(16'h0000);
            reset = 1;
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            A = 8'hFF;
            B = 8'hFF;
            op = 3'd2;
            @(posedge clk);
            #1;
            $display("Testcase 006: Max Multiplication (255 * 255)");
            #1;

            check_outputs(16'd65025);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            A = 8'd200;
            B = 8'd200;
            op = 3'd0;
            @(posedge clk);
            #1;
            $display("Testcase 007: Addition Carry (200 + 200)");
            #1;

            check_outputs(16'd400);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            A = 8'd10;
            B = 8'd20;
            op = 3'd1;
            @(posedge clk);
            #1;
            $display("Testcase 008: Negative Subtraction (10 - 20)");
            #1;

            check_outputs(16'hFFF6);
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
        input [15:0] expected_out;
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
        $dumpvars(0,A, B, clk, op, reset, out);
    end

endmodule
