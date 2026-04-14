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
            test_num = 1;
            $display("Test %0d: Simple Addition (2 + 3 = 5)", test_num);
            a = 4'b0010;
            b = 4'b0011;
            mode = 1'b0;
            #1;

            check_outputs(4'b0101, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Addition Positive Overflow (7 + 1 = -8)", test_num);
            a = 4'b0111;
            b = 4'b0001;
            mode = 1'b0;
            #1;

            check_outputs(4'b1000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Addition Negative Numbers (-2 + -3 = -5)", test_num);
            a = 4'b1110;
            b = 4'b1101;
            mode = 1'b0;
            #1;

            check_outputs(4'b1011, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Addition Negative Overflow (-8 + -1 = 7)", test_num);
            a = 4'b1000;
            b = 4'b1111;
            mode = 1'b0;
            #1;

            check_outputs(4'b0111, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Simple Subtraction (5 - 3 = 2)", test_num);
            a = 4'b0101;
            b = 4'b0011;
            mode = 1'b1;
            #1;

            check_outputs(4'b0010, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Subtraction Positive to Negative Overflow (7 - (-1) = -8)", test_num);
            a = 4'b0111;
            b = 4'b1111;
            mode = 1'b1;
            #1;

            check_outputs(4'b1000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Subtraction Resulting in Negative (2 - 5 = -3)", test_num);
            a = 4'b0010;
            b = 4'b0101;
            mode = 1'b1;
            #1;

            check_outputs(4'b1101, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Subtraction Negative Overflow (-8 - 1 = 7)", test_num);
            a = 4'b1000;
            b = 4'b0001;
            mode = 1'b1;
            #1;

            check_outputs(4'b0111, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Subtraction Identical Numbers (-4 - (-4) = 0)", test_num);
            a = 4'b1100;
            b = 4'b1100;
            mode = 1'b1;
            #1;

            check_outputs(4'b0000, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Addition Resulting in Zero (-7 + 7 = 0)", test_num);
            a = 4'b1001;
            b = 4'b0111;
            mode = 1'b0;
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
