`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [2:0] op;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 4'd5;
            b = 4'd3;
            op = 3'd0;
            $display("Testcase %0d: Addition (5 + 3)", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 4'd12;
            b = 4'd6;
            op = 3'd0;
            $display("Testcase %0d: Addition Overflow (12 + 6 = 18 -> 2)", test_num);
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 4'd10;
            b = 4'd4;
            op = 3'd1;
            $display("Testcase %0d: Subtraction (10 - 4)", test_num);
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 4'd2;
            b = 4'd5;
            op = 3'd1;
            $display("Testcase %0d: Subtraction Underflow (2 - 5 = -3 -> 13)", test_num);
            #1;

            check_outputs(4'd13);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 4'b1100;
            b = 4'b1010;
            op = 3'd2;
            $display("Testcase %0d: Bitwise AND (1100 & 1010)", test_num);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 4'b1100;
            b = 4'b1010;
            op = 3'd3;
            $display("Testcase %0d: Bitwise OR (1100 | 1010)", test_num);
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a = 4'b1100;
            b = 4'b1010;
            op = 3'd4;
            $display("Testcase %0d: Bitwise XOR (1100 ^ 1010)", test_num);
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            a = 4'b0101;
            b = 4'b0000;
            op = 3'd5;
            $display("Testcase %0d: Left Shift a (0101 << 1)", test_num);
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            a = 4'b1011;
            b = 4'b0000;
            op = 3'd5;
            $display("Testcase %0d: Left Shift a with overflow (1011 << 1)", test_num);
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            a = 4'hF;
            b = 4'hF;
            op = 3'd6;
            $display("Testcase %0d: Unsupported op (6)", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            a = 4'hA;
            b = 4'h5;
            op = 3'd7;
            $display("Testcase %0d: Unsupported op (7)", test_num);
            #1;

            check_outputs(4'h0);
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
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
