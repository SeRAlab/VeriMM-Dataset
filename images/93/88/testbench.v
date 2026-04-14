`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
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
        .in_a(in_a),
        .in_b(in_b),
        .mode(mode),
        .out(out),
        .overflow(overflow)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (2 + 3)", test_num);
            in_a = 4'd2;
            in_b = 4'd3;
            mode = 1'b0;
            #1;

            check_outputs(4'd5, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (-1 + -2)", test_num);
            in_a = 4'b1111;
            in_b = 4'b1110;
            mode = 1'b0;
            #1;

            check_outputs(4'b1101, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition Overflow (5 + 4)", test_num);
            in_a = 4'd5;
            in_b = 4'd4;
            mode = 1'b0;

            #1;


            check_outputs(4'b1001, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition Overflow (-5 + -4)", test_num);
            in_a = 4'b1011;
            in_b = 4'b1100;
            mode = 1'b0;

            #1;


            check_outputs(4'b0111, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (7 - 2)", test_num);
            in_a = 4'd7;
            in_b = 4'd2;
            mode = 1'b1;
            #1;

            check_outputs(4'd5, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (-4 - (-2))", test_num);
            in_a = 4'b1100;
            in_b = 4'b1110;
            mode = 1'b1;
            #1;

            check_outputs(4'b1110, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction Overflow (5 - (-4))", test_num);
            in_a = 4'd5;
            in_b = 4'b1100;
            mode = 1'b1;

            #1;


            check_outputs(4'b1001, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction Overflow (-5 - 4)", test_num);
            in_a = 4'b1011;
            in_b = 4'd4;
            mode = 1'b1;

            #1;


            check_outputs(4'b0111, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Addition (-8 + 0)", test_num);
            in_a = 4'b1000;
            in_b = 4'd0;
            mode = 1'b0;
            #1;

            check_outputs(4'b1000, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Subtraction (-8 - 1)", test_num);
            in_a = 4'b1000;
            in_b = 4'd1;
            mode = 1'b1;

            #1;


            check_outputs(4'b0111, 1'b1);
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
