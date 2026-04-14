`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] flag;
    wire [11:0] carry;
    wire [11:0] negative;
    wire [11:0] overflow;
    wire [11:0] zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .flag(flag),
        .carry(carry),
        .negative(negative),
        .overflow(overflow),
        .zero(zero)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All flags zero", test_num);
        flag = 4'b0000;

        #1;


        check_outputs(12'h000, 12'h000, 12'h000, 12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Negative flag only (bit 0)", test_num);
        flag = 4'b0001;
        #1;

        check_outputs(12'h000, 12'h0F0, 12'h000, 12'h000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Zero flag only (bit 1)", test_num);
        flag = 4'b0010;
        #1;

        check_outputs(12'h000, 12'h000, 12'h000, 12'h0F0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Carry flag only (bit 2)", test_num);
        flag = 4'b0100;
        #1;

        check_outputs(12'h0F0, 12'h000, 12'h000, 12'h000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Overflow flag only (bit 3)", test_num);
        flag = 4'b1000;
        #1;

        check_outputs(12'h000, 12'h000, 12'h0F0, 12'h000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: All flags set", test_num);
        flag = 4'b1111;
        #1;

        check_outputs(12'h0F0, 12'h0F0, 12'h0F0, 12'h0F0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Alternating flags (Overflow and Zero)", test_num);
        flag = 4'b1010;
        #1;

        check_outputs(12'h000, 12'h000, 12'h0F0, 12'h0F0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Alternating flags (Carry and Negative)", test_num);
        flag = 4'b0101;
        #1;

        check_outputs(12'h0F0, 12'h0F0, 12'h000, 12'h000);
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
        input [11:0] expected_carry;
        input [11:0] expected_negative;
        input [11:0] expected_overflow;
        input [11:0] expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_negative === (expected_negative ^ negative ^ expected_negative) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: carry=%h, negative=%h, overflow=%h, zero=%h",
                         carry, negative, overflow, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%h, negative=%h, overflow=%h, zero=%h",
                         expected_carry, expected_negative, expected_overflow, expected_zero);
                $display("  Got:      carry=%h, negative=%h, overflow=%h, zero=%h",
                         carry, negative, overflow, zero);
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
