`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    reg ctrl;
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
        .ctrl(ctrl),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a <= 0;
            b <= 0;
            ctrl <= 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            a <= 4'd5;
            b <= 4'd3;
            ctrl <= 1'b0;
            @(posedge clk);
            #1;
            $display("Test %0d: Addition (5 + 3)", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            a <= 4'd12;
            b <= 4'd6;
            ctrl <= 1'b0;
            @(posedge clk);
            #1;
            $display("Test %0d: Addition with Overflow (12 + 6 = 18 -> 2)", test_num);
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            a <= 4'd10;
            b <= 4'd4;
            ctrl <= 1'b1;
            @(posedge clk);
            #1;
            $display("Test %0d: Subtraction (10 - 4)", test_num);
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            a <= 4'd2;
            b <= 4'd5;
            ctrl <= 1'b1;
            @(posedge clk);
            #1;
            $display("Test %0d: Subtraction Underflow (2 - 5 = -3 -> 13)", test_num);
            #1;

            check_outputs(4'd13);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            a <= 4'hF;
            b <= 4'hF;
            ctrl <= 1'b0;
            @(posedge clk);
            #1;
            $display("Test %0d: Addition (15 + 15 = 30 -> 14)", test_num);
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            a <= 4'd7;
            b <= 4'd7;
            ctrl <= 1'b1;
            @(posedge clk);
            #1;
            $display("Test %0d: Subtraction (7 - 7)", test_num);
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
        $dumpvars(0,a, b, clk, ctrl, out);
    end

endmodule
