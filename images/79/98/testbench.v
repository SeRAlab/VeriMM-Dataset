`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
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
        .mode(mode),
        .out(out),
        .overflow(overflow)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition - Small Positive (3 + 2 = 5)", test_num);
            a = 4'd3;
            b = 4'd2;
            mode = 1'b0;
            #1;

            check_outputs(4'd5, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition - Positive Overflow (5 + 4 = 9 -> -7 signed)", test_num);
            a = 4'd5;
            b = 4'd4;
            mode = 1'b0;
            #1;

            check_outputs(4'd9, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition - Negative ( -2 + -3 = -5)", test_num);
            a = 4'b1110;
            b = 4'b1101;
            mode = 1'b0;
            #1;

            check_outputs(4'b1011, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition - Negative Overflow (-5 + -4 = -9 -> 7 signed)", test_num);
            a = 4'b1011;
            b = 4'b1100;
            mode = 1'b0;
            #1;

            check_outputs(4'b0111, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction - Simple (7 - 3 = 4)", test_num);
            a = 4'd7;
            b = 4'd3;
            mode = 1'b1;
            #1;

            check_outputs(4'd4, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction - Negative Result (2 - 5 = -3)", test_num);
            a = 4'd2;
            b = 4'd5;
            mode = 1'b1;
            #1;

            check_outputs(4'b1101, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction - Positive Overflow (5 - (-4) = 9)", test_num);
            a = 4'b0101;
            b = 4'b1100;
            mode = 1'b1;
            #1;

            check_outputs(4'b1001, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction - Negative Overflow (-6 - 3 = -9)", test_num);
            a = 4'b1010;
            b = 4'b0011;
            mode = 1'b1;
            #1;

            check_outputs(4'b0111, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Case (0 - 0 = 0)", test_num);
            a = 4'd0;
            b = 4'd0;
            mode = 1'b1;
            #1;

            check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Case (7 + 1 = 8 -> -8 signed)", test_num);
            a = 4'd7;
            b = 4'd1;
            mode = 1'b0;
            #1;

            check_outputs(4'b1000, 1'b1);
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
        input [3:0] expected_out;
        input expected_overflow;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
