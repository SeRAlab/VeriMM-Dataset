`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] in;
    wire out_even_ones;
    wire [2:0] out_ones_count;
    wire out_palindrome;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_even_ones(out_even_ones),
        .out_ones_count(out_ones_count),
        .out_palindrome(out_palindrome)
    );
    task testcase001;

        begin
            test_num = 1;
            in = 6'b000000;
            $display("Test %0d: in=%b", test_num, in);
            #1;

            check_outputs(1'b1, 3'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 6'b111111;
            $display("Test %0d: in=%b", test_num, in);
            #1;

            check_outputs(1'b1, 3'd6, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 6'b100001;
            $display("Test %0d: in=%b", test_num, in);
            #1;

            check_outputs(1'b1, 3'd2, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 6'b011110;
            $display("Test %0d: in=%b", test_num, in);
            #1;

            check_outputs(1'b1, 3'd4, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 6'b001100;
            $display("Test %0d: in=%b", test_num, in);
            #1;

            check_outputs(1'b1, 3'd2, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 6'b101101;
            $display("Test %0d: in=%b", test_num, in);
            #1;

            check_outputs(1'b1, 3'd4, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in = 6'b110011;
            $display("Test %0d: in=%b", test_num, in);
            #1;

            check_outputs(1'b1, 3'd4, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in = 6'b111000;
            $display("Test %0d: in=%b", test_num, in);
            #1;

            check_outputs(1'b0, 3'd3, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in = 6'b101010;
            $display("Test %0d: in=%b", test_num, in);
            #1;

            check_outputs(1'b0, 3'd3, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            in = 6'b100000;
            $display("Test %0d: in=%b", test_num, in);
            #1;

            check_outputs(1'b0, 3'd1, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            in = 6'b111110;
            $display("Test %0d: in=%b", test_num, in);
            #1;

            check_outputs(1'b0, 3'd5, 1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            in = 6'b010010;
            $display("Test %0d: in=%b", test_num, in);
            #1;

            check_outputs(1'b1, 3'd2, 1'b1);
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
        testcase011();
        testcase012();
        
        
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
        input expected_out_even_ones;
        input [2:0] expected_out_ones_count;
        input expected_out_palindrome;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_even_ones === (expected_out_even_ones ^ out_even_ones ^ expected_out_even_ones) &&
                expected_out_ones_count === (expected_out_ones_count ^ out_ones_count ^ expected_out_ones_count) &&
                expected_out_palindrome === (expected_out_palindrome ^ out_palindrome ^ expected_out_palindrome)) begin
                $display("PASS");
                $display("  Outputs: out_even_ones=%b, out_ones_count=%h, out_palindrome=%b",
                         out_even_ones, out_ones_count, out_palindrome);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_even_ones=%b, out_ones_count=%h, out_palindrome=%b",
                         expected_out_even_ones, expected_out_ones_count, expected_out_palindrome);
                $display("  Got:      out_even_ones=%b, out_ones_count=%h, out_palindrome=%b",
                         out_even_ones, out_ones_count, out_palindrome);
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
