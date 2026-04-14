`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    reg rst;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
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
            a = 0;
            b = 0;
            @(posedge clk);
            #1 rst = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            a = 4'd5;
            b = 4'd3;
            @(posedge clk);
            #1;
            $display("Test %0d: Basic Addition (5+3)", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            a = 4'd10;
            b = 4'd10;
            @(posedge clk);
            #1;
            $display("Test %0d: Wrap-around Addition (10+10=20 mod 16)", test_num);
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            a = 4'd15;
            b = 4'd1;
            @(posedge clk);
            #1;
            $display("Test %0d: Boundary Wrap (15+1=16 mod 16)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            a = 4'hF;
            b = 4'hF;
            @(posedge clk);
            #1;
            $display("Test %0d: Maximum Values (15+15=30 mod 16)", test_num);
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            a = 4'd7;
            b = 4'd0;
            @(posedge clk);
            #1;
            $display("Test %0d: Identity Addition (7+0)", test_num);
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            rst = 1;
            a = 4'd9;
            b = 4'd9;
            @(posedge clk);
            #1;
            $display("Test %0d: Reset persistence check", test_num);
            #1;

            check_outputs(4'd0);
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
        input [3:0] expected_out;
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
        $dumpvars(0,a, b, clk, rst, out);
    end

endmodule
