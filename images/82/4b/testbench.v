`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ctrl;
    reg [3:0] num_a;
    reg [3:0] num_b;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ctrl(ctrl),
        .num_a(num_a),
        .num_b(num_b),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            ctrl = 0;
            num_a = 0;
            num_b = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            num_a = 4'd5;
            num_b = 4'd3;
            ctrl = 1'b0;
            @(posedge clk);
            #2;
            $display("Test Case 001: Addition 5 + 3");
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            num_a = 4'd12;
            num_b = 4'd7;
            ctrl = 1'b0;
            @(posedge clk);
            #2;
            $display("Test Case 002: Addition 12 + 7 (Overflow)");
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            num_a = 4'd10;
            num_b = 4'd4;
            ctrl = 1'b1;
            @(posedge clk);
            #2;
            $display("Test Case 003: Subtraction 10 - 4");
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            num_a = 4'd2;
            num_b = 4'd5;
            ctrl = 1'b1;
            @(posedge clk);
            #2;
            $display("Test Case 004: Subtraction 2 - 5 (Underflow)");
            #1;

            check_outputs(4'd13);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            num_a = 4'd15;
            num_b = 4'd15;
            ctrl = 1'b0;
            @(posedge clk);
            #2;
            $display("Test Case 005: Addition 15 + 15");
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            num_a = 4'd0;
            num_b = 4'd1;
            ctrl = 1'b1;
            @(posedge clk);
            #2;
            $display("Test Case 006: Subtraction 0 - 1");
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
        $dumpvars(0,clk, ctrl, num_a, num_b, out);
    end

endmodule
