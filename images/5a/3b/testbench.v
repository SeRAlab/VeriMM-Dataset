`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg carry;
    reg [31:0] x;
    reg [31:0] y;
    wire [31:0] ashiftl;
    wire [31:0] ashiftr;
    wire [31:0] lshiftl;
    wire [31:0] lshiftr;
    wire [31:0] mult_h;
    wire [31:0] mult_l;
    wire ocarry;
    wire [31:0] revers;
    wire [31:0] sub;
    wire [31:0] summ;
    wire [31:0] zand;
    wire [31:0] znot;
    wire [31:0] zor;
    wire [31:0] zxor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .carry(carry),
        .x(x),
        .y(y),
        .ashiftl(ashiftl),
        .ashiftr(ashiftr),
        .lshiftl(lshiftl),
        .lshiftr(lshiftr),
        .mult_h(mult_h),
        .mult_l(mult_l),
        .ocarry(ocarry),
        .revers(revers),
        .sub(sub),
        .summ(summ),
        .zand(zand),
        .znot(znot),
        .zor(zor),
        .zxor(zxor)
    );
    task testcase001;

        begin
            test_num = 1;
            x = 32'h0000000A;
            y = 32'h00000005;
            carry = 1'b0;
            #1;

            check_outputs(
                x << 5, x >>> 5, x << 5, x >> 5,
                32'h0, 32'd50, 1'b0, reverse_bits(x),
                32'd5, 32'd15, (x & y), ~x, (x | y), (x ^ y)
            );
        end
        endtask

    task testcase002;

        reg [63:0] full_mult;
        begin
            test_num = 2;
            x = 32'hFFFFFFFF;
            y = 32'h00000001;
            carry = 1'b1;


            full_mult = $signed(x) * $signed(y);
            #1;

            check_outputs(
                x << 1, x >>> 1, x << 1, x >> 1,
                full_mult[63:32], full_mult[31:0], 1'b1, reverse_bits(x),
                32'hFFFFFFFE, 32'h00000001, (x & y), ~x, (x | y), (x ^ y)
            );
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            x = 32'h80000000;
            y = 32'h00000004;
            carry = 1'b0;
            #1;

            check_outputs(
                x << 4, x >>> 4, x << 4, x >> 4,
                32'hE0000000, 32'h0, 1'b0, reverse_bits(x),
                32'h7FFFFFFC, 32'h80000004, (x & y), ~x, (x | y), (x ^ y)
            );
        end
        endtask

    task testcase004;

        reg [63:0] full_mult;
        begin
            test_num = 4;
            x = 32'h7FFFFFFF;
            y = 32'h00000002;
            carry = 1'b0;
            full_mult = $signed(x) * $signed(y);
            #1;

            check_outputs(
                x << 2, x >>> 2, x << 2, x >> 2,
                full_mult[63:32], full_mult[31:0], 1'b0, reverse_bits(x),
                32'h7FFFFFFD, 32'hFFFFFFFE, (x & y), ~x, (x | y), (x ^ y)
            );
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            x = 32'hA5A5A5A5;
            y = 32'h00000000;
            carry = 1'b0;
            #1;

            check_outputs(
                x, x, x, x,
                32'h0, 32'h0, 1'b0, 32'hA5A5A5A5,
                x, x, (x & y), ~x, (x | y), (x ^ y)
            );
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
        input [31:0] expected_ashiftl;
        input [31:0] expected_ashiftr;
        input [31:0] expected_lshiftl;
        input [31:0] expected_lshiftr;
        input [31:0] expected_mult_h;
        input [31:0] expected_mult_l;
        input expected_ocarry;
        input [31:0] expected_revers;
        input [31:0] expected_sub;
        input [31:0] expected_summ;
        input [31:0] expected_zand;
        input [31:0] expected_znot;
        input [31:0] expected_zor;
        input [31:0] expected_zxor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ashiftl === (expected_ashiftl ^ ashiftl ^ expected_ashiftl) &&
                expected_ashiftr === (expected_ashiftr ^ ashiftr ^ expected_ashiftr) &&
                expected_lshiftl === (expected_lshiftl ^ lshiftl ^ expected_lshiftl) &&
                expected_lshiftr === (expected_lshiftr ^ lshiftr ^ expected_lshiftr) &&
                expected_mult_h === (expected_mult_h ^ mult_h ^ expected_mult_h) &&
                expected_mult_l === (expected_mult_l ^ mult_l ^ expected_mult_l) &&
                expected_ocarry === (expected_ocarry ^ ocarry ^ expected_ocarry) &&
                expected_revers === (expected_revers ^ revers ^ expected_revers) &&
                expected_sub === (expected_sub ^ sub ^ expected_sub) &&
                expected_summ === (expected_summ ^ summ ^ expected_summ) &&
                expected_zand === (expected_zand ^ zand ^ expected_zand) &&
                expected_znot === (expected_znot ^ znot ^ expected_znot) &&
                expected_zor === (expected_zor ^ zor ^ expected_zor) &&
                expected_zxor === (expected_zxor ^ zxor ^ expected_zxor)) begin
                $display("PASS");
                $display("  Outputs: ashiftl=%h, ashiftr=%h, lshiftl=%h, lshiftr=%h, mult_h=%h, mult_l=%h, ocarry=%b, revers=%h, sub=%h, summ=%h, zand=%h, znot=%h, zor=%h, zxor=%h",
                         ashiftl, ashiftr, lshiftl, lshiftr, mult_h, mult_l, ocarry, revers, sub, summ, zand, znot, zor, zxor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ashiftl=%h, ashiftr=%h, lshiftl=%h, lshiftr=%h, mult_h=%h, mult_l=%h, ocarry=%b, revers=%h, sub=%h, summ=%h, zand=%h, znot=%h, zor=%h, zxor=%h",
                         expected_ashiftl, expected_ashiftr, expected_lshiftl, expected_lshiftr, expected_mult_h, expected_mult_l, expected_ocarry, expected_revers, expected_sub, expected_summ, expected_zand, expected_znot, expected_zor, expected_zxor);
                $display("  Got:      ashiftl=%h, ashiftr=%h, lshiftl=%h, lshiftr=%h, mult_h=%h, mult_l=%h, ocarry=%b, revers=%h, sub=%h, summ=%h, zand=%h, znot=%h, zor=%h, zxor=%h",
                         ashiftl, ashiftr, lshiftl, lshiftr, mult_h, mult_l, ocarry, revers, sub, summ, zand, znot, zor, zxor);
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
