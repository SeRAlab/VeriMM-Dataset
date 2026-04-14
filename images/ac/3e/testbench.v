`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] adder_in1;
    reg [3:0] adder_in2;
    reg cin;
    reg clk;
    reg reset;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adder_in1(adder_in1),
        .adder_in2(adder_in2),
        .cin(cin),
        .clk(clk),
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
            reset = 1;
            adder_in1 = 0;
            adder_in2 = 0;
            cin = 0;
            @(negedge clk);
            reset = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            adder_in1 = 4'd5; adder_in2 = 4'd2; cin = 1'b0;
            #1;
            $display("Test Case 001: Adder 5+2+0, Counter 0");
            #1;

            check_outputs(4'h7 ^ 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge clk);
            adder_in1 = 4'd3; adder_in2 = 4'd4; cin = 1'b1;
            #1;
            $display("Test Case 002: Adder 3+4+1, Counter 1");
            #1;

            check_outputs(4'h8 ^ 4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            repeat(2) @(negedge clk);
            adder_in1 = 4'd10; adder_in2 = 4'd5; cin = 1'b0;
            #1;
            $display("Test Case 003: Adder 10+5+0, Counter 3");
            #1;

            check_outputs(4'hF ^ 4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            repeat(3) @(negedge clk);
            adder_in1 = 4'd8; adder_in2 = 4'd8; cin = 1'b1;
            #1;
            $display("Test Case 004: Adder 8+8+1, Counter 7");
            #1;

            check_outputs(4'h1 ^ 4'h7);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            repeat(4) @(negedge clk);
            adder_in1 = 4'd1; adder_in2 = 4'd1; cin = 1'b1;
            #1;
            $display("Test Case 005: Adder 1+1+1, Counter 15");
            #1;

            check_outputs(4'h3 ^ 4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            repeat(5) @(negedge clk);
            adder_in1 = 4'd12; adder_in2 = 4'd3; cin = 1'b1;
            #1;
            $display("Test Case 006: Adder 12+3+1, Counter 0 (Wrap)");
            #1;

            check_outputs(4'h0 ^ 4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            repeat(2) @(negedge clk);
            adder_in1 = 4'hA; adder_in2 = 4'h5; cin = 1'b1;
            #1;
            $display("Test Case 007: Adder A+5+1, Counter 3");
            #1;

            check_outputs(4'h0 ^ 4'h3);
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
        $dumpvars(0,adder_in1, adder_in2, cin, clk, reset, out);
    end

endmodule
