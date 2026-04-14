`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [3:0] operation;
    reg [2:0] shift_amount;
    wire negative;
    wire overflow;
    wire [7:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .operation(operation),
        .shift_amount(shift_amount),
        .negative(negative),
        .overflow(overflow),
        .result(result),
        .zero(zero)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 8'd10; b = 8'd20; operation = 4'd0; shift_amount = 0;
        $display("Test %0d: Addition (10 + 20)", test_num);
        #1;

        check_outputs(1'b0, 1'b0, 8'd30, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 8'd0; b = 8'd0; operation = 4'd0; shift_amount = 0;
        $display("Test %0d: Addition (0 + 0)", test_num);
        #1;

        check_outputs(1'b0, 1'b0, 8'd0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 8'h7F; b = 8'h01; operation = 4'd0; shift_amount = 0;
        $display("Test %0d: Addition Overflow (127 + 1)", test_num);
        #1;

        check_outputs(1'b1, 1'b1, 8'h80, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 8'd50; b = 8'd20; operation = 4'd1; shift_amount = 0;
        $display("Test %0d: Subtraction (50 - 20)", test_num);
        #1;

        check_outputs(1'b0, 1'b0, 8'd30, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 8'd10; b = 8'd20; operation = 4'd1; shift_amount = 0;
        $display("Test %0d: Subtraction Negative (10 - 20)", test_num);
        #1;

        check_outputs(1'b1, 1'b0, 8'hF6, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 8'h80; b = 8'h01; operation = 4'd1; shift_amount = 0;
        $display("Test %0d: Subtraction Overflow (-128 - 1)", test_num);
        #1;

        check_outputs(1'b0, 1'b1, 8'h7F, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 8'b10101010; b = 8'b11110000; operation = 4'd2; shift_amount = 0;
        $display("Test %0d: Bitwise AND", test_num);
        #1;

        check_outputs(1'b1, 1'b0, 8'b10100000, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 8'hFF; b = 8'hAA; operation = 4'd4; shift_amount = 0;
        $display("Test %0d: Bitwise XOR", test_num);
        #1;

        check_outputs(1'b0, 1'b0, 8'h55, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 8'h01; b = 0; operation = 4'd5; shift_amount = 3'd4;
        $display("Test %0d: SLL (1 << 4)", test_num);
        #1;

        check_outputs(1'b0, 1'b0, 8'h10, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 8'h80; b = 0; operation = 4'd6; shift_amount = 3'd1;
        $display("Test %0d: SRL (80 >> 1)", test_num);
        #1;

        check_outputs(1'b0, 1'b0, 8'h40, 1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        a = 8'hF0; b = 0; operation = 4'd7; shift_amount = 3'd2;
        $display("Test %0d: SRA (F0 >>> 2)", test_num);
        #1;

        check_outputs(1'b1, 1'b0, 8'hFC, 1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        a = 8'h40; b = 0; operation = 4'd7; shift_amount = 3'd2;
        $display("Test %0d: SRA (40 >>> 2)", test_num);
        #1;

        check_outputs(1'b0, 1'b0, 8'h10, 1'b0);
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
        input expected_negative;
        input expected_overflow;
        input [7:0] expected_result;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_negative === (expected_negative ^ negative ^ expected_negative) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: negative=%b, overflow=%b, result=%h, zero=%b",
                         negative, overflow, result, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: negative=%b, overflow=%b, result=%h, zero=%b",
                         expected_negative, expected_overflow, expected_result, expected_zero);
                $display("  Got:      negative=%b, overflow=%b, result=%h, zero=%b",
                         negative, overflow, result, zero);
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
