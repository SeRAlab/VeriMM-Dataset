`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg alu_carry;
    reg alu_negative;
    reg alu_overflow;
    reg alu_zero;
    reg bs_carry;
    reg bs_negative;
    reg bs_zero;
    reg clock;
    reg enable;
    reg reset;
    reg [3:0] update_mode;
    wire carry_flag;
    wire is_bios;
    wire mode_flag;
    wire negative_flag;
    wire overflow_flag;
    wire zero_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_carry(alu_carry),
        .alu_negative(alu_negative),
        .alu_overflow(alu_overflow),
        .alu_zero(alu_zero),
        .bs_carry(bs_carry),
        .bs_negative(bs_negative),
        .bs_zero(bs_zero),
        .clock(clock),
        .enable(enable),
        .reset(reset),
        .update_mode(update_mode),
        .carry_flag(carry_flag),
        .is_bios(is_bios),
        .mode_flag(mode_flag),
        .negative_flag(negative_flag),
        .overflow_flag(overflow_flag),
        .zero_flag(zero_flag)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 1;
        enable = 0;
        update_mode = 4'b0;
        alu_negative = 0; alu_zero = 0; alu_carry = 0; alu_overflow = 0;
        bs_negative = 0; bs_zero = 0; bs_carry = 0;
        @(posedge clock);
        #1 reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: System Reset State", test_num);
        reset_dut();
        @(posedge clock);
        #1 #1;
 check_outputs(0, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: ALU Status Update", test_num);
        reset_dut();
        @(posedge clock);
        enable = 1;
        update_mode = 4'h1;
        alu_negative = 1;
        alu_zero = 0;
        alu_carry = 1;
        alu_overflow = 0;
        @(posedge clock);
        #1 #1;
 check_outputs(1, 1, 0, 1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: BIOS Status Update", test_num);
        reset_dut();
        @(posedge clock);
        enable = 1;
        update_mode = 4'h2;
        bs_negative = 0;
        bs_zero = 1;
        bs_carry = 1;
        @(posedge clock);
        #1 #1;
 check_outputs(1, 1, 0, 0, 0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mode Flag Toggle", test_num);
        reset_dut();
        @(posedge clock);
        enable = 1;
        update_mode = 4'h3;
        @(posedge clock);
        #1;
        update_mode = 4'h3;
        @(posedge clock);
        #1 #1;
 check_outputs(0, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Enable Signal Logic Check", test_num);
        reset_dut();
        @(posedge clock);
        enable = 0;
        update_mode = 4'h1;
        alu_negative = 1; alu_zero = 1; alu_carry = 1; alu_overflow = 1;
        @(posedge clock);
        #1 #1;
 check_outputs(0, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sequential ALU and BIOS Updates", test_num);
        reset_dut();
        @(posedge clock);
        enable = 1;
        update_mode = 4'h1;
        alu_negative = 1; alu_zero = 1; alu_carry = 0; alu_overflow = 1;
        @(posedge clock);
        #1;
        update_mode = 4'h2;
        bs_negative = 0; bs_zero = 0; bs_carry = 1;
        @(posedge clock);
        #1 #1;
 check_outputs(1, 1, 0, 0, 1, 0);
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
        input expected_carry_flag;
        input expected_is_bios;
        input expected_mode_flag;
        input expected_negative_flag;
        input expected_overflow_flag;
        input expected_zero_flag;
        begin
            if (expected_carry_flag === (expected_carry_flag ^ carry_flag ^ expected_carry_flag) &&
                expected_is_bios === (expected_is_bios ^ is_bios ^ expected_is_bios) &&
                expected_mode_flag === (expected_mode_flag ^ mode_flag ^ expected_mode_flag) &&
                expected_negative_flag === (expected_negative_flag ^ negative_flag ^ expected_negative_flag) &&
                expected_overflow_flag === (expected_overflow_flag ^ overflow_flag ^ expected_overflow_flag) &&
                expected_zero_flag === (expected_zero_flag ^ zero_flag ^ expected_zero_flag)) begin
                $display("PASS");
                $display("  Outputs: carry_flag=%b, is_bios=%b, mode_flag=%b, negative_flag=%b, overflow_flag=%b, zero_flag=%b",
                         carry_flag, is_bios, mode_flag, negative_flag, overflow_flag, zero_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_flag=%b, is_bios=%b, mode_flag=%b, negative_flag=%b, overflow_flag=%b, zero_flag=%b",
                         expected_carry_flag, expected_is_bios, expected_mode_flag, expected_negative_flag, expected_overflow_flag, expected_zero_flag);
                $display("  Got:      carry_flag=%b, is_bios=%b, mode_flag=%b, negative_flag=%b, overflow_flag=%b, zero_flag=%b",
                         carry_flag, is_bios, mode_flag, negative_flag, overflow_flag, zero_flag);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,alu_carry, alu_negative, alu_overflow, alu_zero, bs_carry, bs_negative, bs_zero, clock, enable, reset, update_mode, carry_flag, is_bios, mode_flag, negative_flag, overflow_flag, zero_flag);
    end

endmodule
