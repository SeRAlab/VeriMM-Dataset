`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg addsub_fn;
    reg [3:0] in_a;
    reg [3:0] in_b;
    reg in_c;
    reg [1:0] logic_fn;
    reg [1:0] shift_fn;
    wire a_b_not_eq;
    wire carry_out;
    wire [3:0] fn_out;
    wire [3:0] sum_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addsub_fn(addsub_fn),
        .in_a(in_a),
        .in_b(in_b),
        .in_c(in_c),
        .logic_fn(logic_fn),
        .shift_fn(shift_fn),
        .a_b_not_eq(a_b_not_eq),
        .carry_out(carry_out),
        .fn_out(fn_out),
        .sum_out(sum_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition (4 + 3, Cin=0)", test_num);
            in_a = 4'd4;
            in_b = 4'd3;
            in_c = 1'b0;
            addsub_fn = 1'b0;
            logic_fn = 2'b00;
            shift_fn = 2'b00;

            #1;


            check_outputs(1'b1, 1'b0, 4'h7, 4'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition with Carry Out (12 + 5, Cin=0)", test_num);
            in_a = 4'd12;
            in_b = 4'd5;
            in_c = 1'b0;
            addsub_fn = 1'b0;

            #1;


            check_outputs(1'b1, 1'b1, 4'h0, 4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition with Carry In (7 + 2 + 1)", test_num);
            in_a = 4'd7;
            in_b = 4'd2;
            in_c = 1'b1;
            addsub_fn = 1'b0;

            #1;


            check_outputs(1'b1, 1'b0, 4'h5, 4'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction (10 - 4)", test_num);
            in_a = 4'd10;
            in_b = 4'd4;
            in_c = 1'b1;
            addsub_fn = 1'b1;

            #1;


            check_outputs(1'b1, 1'b1, 4'hE, 4'd6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction (3 - 5)", test_num);
            in_a = 4'd3;
            in_b = 4'd5;
            in_c = 1'b1;
            addsub_fn = 1'b1;

            #1;


            check_outputs(1'b1, 1'b0, 4'h6, 4'd14);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logic XOR Function", test_num);
            in_a = 4'b1010;
            in_b = 4'b1100;
            logic_fn = 2'b00;

            #1;


            check_outputs(1'b1, 1'b1, 4'h6, 4'h7);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logic AND Function", test_num);
            in_a = 4'b1010;
            in_b = 4'b1100;
            logic_fn = 2'b01;

            #1;


            check_outputs(1'b1, 1'b1, 4'h8, 4'h7);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Logic OR Function", test_num);
            in_a = 4'b1010;
            in_b = 4'b1100;
            logic_fn = 2'b10;

            #1;


            check_outputs(1'b1, 1'b1, 4'hE, 4'h7);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Equality Check (A == B)", test_num);
            in_a = 4'd9;
            in_b = 4'd9;

            #1;


            check_outputs(1'b0, 1'b1, 4'h0, 4'd3);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Equality Check (A != B)", test_num);
            in_a = 4'd9;
            in_b = 4'd8;

            #1;


            check_outputs(1'b1, 1'b1, 4'h8, 4'd2);
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
        input expected_a_b_not_eq;
        input expected_carry_out;
        input [3:0] expected_fn_out;
        input [3:0] expected_sum_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a_b_not_eq === (expected_a_b_not_eq ^ a_b_not_eq ^ expected_a_b_not_eq) &&
                expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_fn_out === (expected_fn_out ^ fn_out ^ expected_fn_out) &&
                expected_sum_out === (expected_sum_out ^ sum_out ^ expected_sum_out)) begin
                $display("PASS");
                $display("  Outputs: a_b_not_eq=%b, carry_out=%b, fn_out=%h, sum_out=%h",
                         a_b_not_eq, carry_out, fn_out, sum_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_b_not_eq=%b, carry_out=%b, fn_out=%h, sum_out=%h",
                         expected_a_b_not_eq, expected_carry_out, expected_fn_out, expected_sum_out);
                $display("  Got:      a_b_not_eq=%b, carry_out=%b, fn_out=%h, sum_out=%h",
                         a_b_not_eq, carry_out, fn_out, sum_out);
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
