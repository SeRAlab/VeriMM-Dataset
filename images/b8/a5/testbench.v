`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg mode;
    wire [7:0] Y;
    wire carry_out;
    wire overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .mode(mode),
        .Y(Y),
        .carry_out(carry_out),
        .overflow(overflow)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Addition (5 + 3)", test_num);
            A = 8'd5; B = 8'd3; mode = 1'b1;
            #1;

            check_outputs(8'd8, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with Carry-out (250 + 10)", test_num);
            A = 8'd250; B = 8'd10; mode = 1'b1;

            #1;


            check_outputs(8'd4, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with Signed Overflow Positive (120 + 10)", test_num);
            A = 8'd120; B = 8'd10; mode = 1'b1;

            #1;


            check_outputs(8'h82, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with Signed Overflow Negative (-120 + -10)", test_num);
            A = 8'h88; B = 8'hF6; mode = 1'b1;


            #1;



            check_outputs(8'h7E, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Subtraction (50 - 20)", test_num);
            A = 8'd50; B = 8'd20; mode = 1'b0;

            #1;


            check_outputs(8'd30, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Resulting in Negative (20 - 50)", test_num);
            A = 8'd20; B = 8'd50; mode = 1'b0;


            #1;



            check_outputs(8'hE2, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction with Signed Overflow (100 - -50)", test_num);
            A = 8'd100; B = 8'hCE; mode = 1'b0;


            #1;



            check_outputs(8'h96, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction with Signed Overflow (-100 - 50)", test_num);
            A = 8'h9C; B = 8'd50; mode = 1'b0;


            #1;



            check_outputs(8'h6A, 1'b1, 1'b1);
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
        input [7:0] expected_Y;
        input expected_carry_out;
        input expected_overflow;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y) &&
                expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow)) begin
                $display("PASS");
                $display("  Outputs: Y=%h, carry_out=%b, overflow=%b",
                         Y, carry_out, overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h, carry_out=%b, overflow=%b",
                         expected_Y, expected_carry_out, expected_overflow);
                $display("  Got:      Y=%h, carry_out=%b, overflow=%b",
                         Y, carry_out, overflow);
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
