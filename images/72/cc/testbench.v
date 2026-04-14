`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg carry_in;
    wire [3:0] S;
    wire carry_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .carry_in(carry_in),
        .S(S),
        .carry_out(carry_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Zero addition (0 + 0 + 0)", test_num);
            A = 4'b0000;
            B = 4'b0000;
            carry_in = 1'b0;
            #1;

            check_outputs(4'b0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Basic addition (5 + 3 + 0)", test_num);
            A = 4'd5;
            B = 4'd3;
            carry_in = 1'b0;
            #1;

            check_outputs(4'd8, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Carry-in effect (1 + 1 + 1)", test_num);
            A = 4'd1;
            B = 4'd1;
            carry_in = 1'b1;
            #1;

            check_outputs(4'd3, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Maximum sum without carry_out (7 + 8 + 0)", test_num);
            A = 4'h7;
            B = 4'h8;
            carry_in = 1'b0;
            #1;

            check_outputs(4'hf, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Generate carry_out from MSB (8 + 8 + 0)", test_num);
            A = 4'h8;
            B = 4'h8;
            carry_in = 1'b0;
            #1;

            check_outputs(4'h0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Carry ripples through all bits (15 + 1 + 0)", test_num);
            A = 4'hf;
            B = 4'h1;
            carry_in = 1'b0;
            #1;

            check_outputs(4'h0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Maximum possible values (15 + 15 + 1)", test_num);
            A = 4'hf;
            B = 4'hf;
            carry_in = 1'b1;
            #1;

            check_outputs(4'hf, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Carry_in causes carry_out (15 + 0 + 1)", test_num);
            A = 4'hf;
            B = 4'h0;
            carry_in = 1'b1;
            #1;

            check_outputs(4'h0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Alternating bits (10 + 5 + 0)", test_num);
            A = 4'b1010;
            B = 4'b0101;
            carry_in = 1'b0;
            #1;

            check_outputs(4'b1111, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Alternating bits with carry_in (10 + 5 + 1)", test_num);
            A = 4'b1010;
            B = 4'b0101;
            carry_in = 1'b1;
            #1;

            check_outputs(4'b0000, 1'b1);
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
        input [3:0] expected_S;
        input expected_carry_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S) &&
                expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out)) begin
                $display("PASS");
                $display("  Outputs: S=%h, carry_out=%b",
                         S, carry_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h, carry_out=%b",
                         expected_S, expected_carry_out);
                $display("  Got:      S=%h, carry_out=%b",
                         S, carry_out);
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
