`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    reg mode;
    wire [3:0] out;
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
        .mode(mode),
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
            a = 0;
            b = 0;
            mode = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            a = 4'd2; b = 4'd3; mode = 0;
            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: Addition 2 + 3", test_num);
            #1;

            check_outputs(4'd5, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            a = 4'b0111; b = 4'b0001; mode = 0;
            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: Addition 7 + 1 (Overflow)", test_num);
            #1;

            check_outputs(4'b1000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            a = 4'd5; b = 4'd2; mode = 1;
            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: Subtraction 5 - 2", test_num);
            #1;

            check_outputs(4'd3, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            a = 4'b1001; b = 4'b0010; mode = 1;
            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: Subtraction -7 - 2 (Overflow)", test_num);
            #1;

            check_outputs(4'b0111, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            a = 4'b1110; b = 4'b1101; mode = 0;
            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: Addition -2 + -3", test_num);
            #1;

            check_outputs(4'b1011, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            a = 4'd2; b = 4'd5; mode = 1;
            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: Subtraction 2 - 5", test_num);
            #1;

            check_outputs(4'b1101, 1'b0);
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
        $dumpvars(0,a, b, clk, mode, out, overflow);
    end

endmodule
