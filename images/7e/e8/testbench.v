`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] in;
    wire a;
    wire b;
    wire c;
    wire d;
    wire e;
    wire f;
    wire g;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g)
    );
    task testcase001;

        begin
            $display("Test Case 001: Input 000 (Digit 0)");
            in = 3'b000;
            #1;

            check_outputs(1, 1, 1, 1, 1, 1, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Input 001 (Digit 1)");
            in = 3'b001;
            #1;

            check_outputs(0, 1, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Input 010 (Digit 2)");
            in = 3'b010;
            #1;

            check_outputs(1, 1, 0, 1, 1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Input 011 (Digit 3)");
            in = 3'b011;
            #1;

            check_outputs(1, 1, 1, 1, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Input 100 (Digit 4)");
            in = 3'b100;
            #1;

            check_outputs(0, 1, 1, 0, 0, 1, 1);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Input 101 (Digit 5)");
            in = 3'b101;
            #1;

            check_outputs(1, 0, 1, 1, 0, 1, 1);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Input 110 (Digit 6)");
            in = 3'b110;
            #1;

            check_outputs(1, 0, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Input 111 (Digit 7)");
            in = 3'b111;
            #1;

            check_outputs(1, 1, 1, 0, 0, 0, 0);
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
        input expected_a;
        input expected_b;
        input expected_c;
        input expected_d;
        input expected_e;
        input expected_f;
        input expected_g;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a === (expected_a ^ a ^ expected_a) &&
                expected_b === (expected_b ^ b ^ expected_b) &&
                expected_c === (expected_c ^ c ^ expected_c) &&
                expected_d === (expected_d ^ d ^ expected_d) &&
                expected_e === (expected_e ^ e ^ expected_e) &&
                expected_f === (expected_f ^ f ^ expected_f) &&
                expected_g === (expected_g ^ g ^ expected_g)) begin
                $display("PASS");
                $display("  Outputs: a=%b, b=%b, c=%b, d=%b, e=%b, f=%b, g=%b",
                         a, b, c, d, e, f, g);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a=%b, b=%b, c=%b, d=%b, e=%b, f=%b, g=%b",
                         expected_a, expected_b, expected_c, expected_d, expected_e, expected_f, expected_g);
                $display("  Got:      a=%b, b=%b, c=%b, d=%b, e=%b, f=%b, g=%b",
                         a, b, c, d, e, f, g);
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
