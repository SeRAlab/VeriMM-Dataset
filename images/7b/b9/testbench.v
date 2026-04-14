`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] ctl;
    wire [3:0] out;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ctl(ctl),
        .out(out),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (3 + 4)", test_num);
            ctl = 4'b0000; a = 4'd3; b = 4'd4;
            #1;

            check_outputs(4'd7, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition overflow (8 + 8)", test_num);
            ctl = 4'b0000; a = 4'd8; b = 4'd8;
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (10 - 4)", test_num);
            ctl = 4'b0001; a = 4'd10; b = 4'd4;
            #1;

            check_outputs(4'd6, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction result zero (5 - 5)", test_num);
            ctl = 4'b0001; a = 4'd5; b = 4'd5;
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND (1010 & 1100)", test_num);
            ctl = 4'b0010; a = 4'b1010; b = 4'b1100;
            #1;

            check_outputs(4'b1000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR (1010 | 1100)", test_num);
            ctl = 4'b0011; a = 4'b1010; b = 4'b1100;
            #1;

            check_outputs(4'b1110, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise XOR (1010 ^ 1100)", test_num);
            ctl = 4'b0100; a = 4'b1010; b = 4'b1100;
            #1;

            check_outputs(4'b0110, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise NOT (~1010)", test_num);
            ctl = 4'b0101; a = 4'b1010; b = 4'b0000;
            #1;

            check_outputs(4'b0101, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left Shift (0001 << 2)", test_num);
            ctl = 4'b0110; a = 4'b0001; b = 4'd2;
            #1;

            check_outputs(4'b0100, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right Shift (1000 >> 2)", test_num);
            ctl = 4'b0111; a = 4'b1000; b = 4'd2;
            #1;

            check_outputs(4'b0010, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition signed overflow (7 + 1)", test_num);
            ctl = 4'b0000; a = 4'd7; b = 4'd1;
            #1;

            check_outputs(4'b1000, 1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction result zero (15 - 15)", test_num);
            ctl = 4'b0001; a = 4'd15; b = 4'd15;
            #1;

            check_outputs(4'd0, 1'b1);
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
        input [3:0] expected_out;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: out=%h, zero=%b",
                         out, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, zero=%b",
                         expected_out, expected_zero);
                $display("  Got:      out=%h, zero=%b",
                         out, zero);
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
