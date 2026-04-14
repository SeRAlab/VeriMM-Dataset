`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg C_in;
    wire carry_out;
    wire [3:0] out;
    wire overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C_in(C_in),
        .carry_out(carry_out),
        .out(out),
        .overflow(overflow)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple addition (2 + 3)", test_num);
            A = 4'd2; B = 4'd3; C_in = 1'b0;

            #1;


            check_outputs(1'b0, 4'd5, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition with C_in (1 + 1 + 1)", test_num);
            A = 4'd1; B = 4'd1; C_in = 1'b1;

            #1;


            check_outputs(1'b0, 4'd3, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry Out check (15 + 1)", test_num);
            A = 4'b1111; B = 4'b0001; C_in = 1'b0;

            #1;


            check_outputs(1'b1, 4'b0000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive signed overflow (7 + 1)", test_num);
            A = 4'b0111; B = 4'b0001; C_in = 1'b0;

            #1;


            check_outputs(1'b0, 4'b1000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative signed overflow (-8 + -8)", test_num);
            A = 4'b1000; B = 4'b1000; C_in = 1'b0;

            #1;


            check_outputs(1'b1, 4'b0000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry Out and Overflow (-8 + -1)", test_num);
            A = 4'b1000; B = 4'b1111; C_in = 1'b0;

            #1;


            check_outputs(1'b1, 4'b0111, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero addition", test_num);
            A = 4'b0000; B = 4'b0000; C_in = 1'b0;
            #1;

            check_outputs(1'b0, 4'b0000, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max values (15 + 15 + 1)", test_num);
            A = 4'b1111; B = 4'b1111; C_in = 1'b1;

            #1;


            check_outputs(1'b1, 4'b1111, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative addition no overflow (-1 + -1)", test_num);
            A = 4'b1111; B = 4'b1111; C_in = 1'b0;

            #1;


            check_outputs(1'b1, 4'b1110, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Overflow (7 + 7 + 1)", test_num);
            A = 4'b0111; B = 4'b0111; C_in = 1'b1;

            #1;


            check_outputs(1'b0, 4'b1111, 1'b1);
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
        input expected_carry_out;
        input [3:0] expected_out;
        input expected_overflow;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, out=%h, overflow=%b",
                         carry_out, out, overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, out=%h, overflow=%b",
                         expected_carry_out, expected_out, expected_overflow);
                $display("  Got:      carry_out=%b, out=%h, overflow=%b",
                         carry_out, out, overflow);
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
