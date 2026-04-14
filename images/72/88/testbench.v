`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in_a;
    reg [3:0] in_b;
    reg mode;
    wire [3:0] out;
    wire overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_a(in_a),
        .in_b(in_b),
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
            in_a = 4'b0;
            in_b = 4'b0;
            mode = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            in_a = 4'sd2;
            in_b = 4'sd3;
            mode = 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: Simple Addition (2 + 3)", test_num);
            #1;

            check_outputs(4'sd5, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            in_a = 4'sd5;
            in_b = 4'sd2;
            mode = 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: Simple Subtraction (5 - 2)", test_num);
            #1;

            check_outputs(4'sd3, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            in_a = 4'sd5;
            in_b = 4'sd4;
            mode = 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: Positive Addition Overflow (5 + 4)", test_num);
            #1;

            check_outputs(4'b1001, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            in_a = 4'b1011;
            in_b = 4'b1100;
            mode = 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: Negative Addition Overflow (-5 + -4)", test_num);
            #1;

            check_outputs(4'b0111, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            in_a = 4'sd4;
            in_b = 4'b1011;
            mode = 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: Subtraction Overflow (4 - (-5))", test_num);
            #1;

            check_outputs(4'b1001, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            in_a = 4'b1011;
            in_b = 4'sd4;
            mode = 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: Subtraction Overflow (-5 - 4)", test_num);
            #1;

            check_outputs(4'b0111, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            in_a = 4'b1000;
            in_b = 4'sd1;
            mode = 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: Boundary Subtraction (-8 - 1)", test_num);
            #1;

            check_outputs(4'b0111, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            in_a = 4'b1111;
            in_b = 4'b0001;
            mode = 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: Zero result (-1 + 1)", test_num);
            #1;

            check_outputs(4'b0000, 1'b0);
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
        $dumpvars(0,clk, in_a, in_b, mode, out, overflow);
    end

endmodule
