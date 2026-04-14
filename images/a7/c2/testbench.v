`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a_bus;
    reg [15:0] b_bus;
    reg [2:0] opcode;
    wire [15:0] accumulator;
    wire zero_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_bus(a_bus),
        .b_bus(b_bus),
        .opcode(opcode),
        .accumulator(accumulator),
        .zero_flag(zero_flag)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition Basic (5 + 10)", test_num);
        a_bus = 16'd5; b_bus = 16'd10; opcode = 3'b000;
        #1;

        check_outputs(16'd15, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition Zero (0 + 0)", test_num);
        a_bus = 16'd0; b_bus = 16'd0; opcode = 3'b000;
        #1;

        check_outputs(16'd0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition Overflow (0xFFFF + 1)", test_num);
        a_bus = 16'hFFFF; b_bus = 16'h0001; opcode = 3'b000;
        #1;

        check_outputs(16'h0000, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction Basic (20 - 5)", test_num);
        a_bus = 16'd20; b_bus = 16'd5; opcode = 3'b001;
        #1;

        check_outputs(16'd15, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction Zero (50 - 50)", test_num);
        a_bus = 16'd50; b_bus = 16'd50; opcode = 3'b001;
        #1;

        check_outputs(16'h0000, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction Underflow (0 - 1)", test_num);
        a_bus = 16'h0000; b_bus = 16'h0001; opcode = 3'b001;
        #1;

        check_outputs(16'hFFFF, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication Basic (12 * 10)", test_num);
        a_bus = 16'd12; b_bus = 16'd10; opcode = 3'b010;
        #1;

        check_outputs(16'd120, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication by Zero (255 * 0)", test_num);
        a_bus = 16'd255; b_bus = 16'd0; opcode = 3'b010;
        #1;

        check_outputs(16'h0000, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication Truncation (0x100 * 0x100)", test_num);

        a_bus = 16'h0100; b_bus = 16'h0100; opcode = 3'b010;
        #1;

        check_outputs(16'h0000, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication Max Range (0x7FFF * 2)", test_num);
        a_bus = 16'h7FFF; b_bus = 16'h0002; opcode = 3'b010;
        #1;

        check_outputs(16'hFFFE, 1'b0);
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
        input [15:0] expected_accumulator;
        input expected_zero_flag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_accumulator === (expected_accumulator ^ accumulator ^ expected_accumulator) &&
                expected_zero_flag === (expected_zero_flag ^ zero_flag ^ expected_zero_flag)) begin
                $display("PASS");
                $display("  Outputs: accumulator=%h, zero_flag=%b",
                         accumulator, zero_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: accumulator=%h, zero_flag=%b",
                         expected_accumulator, expected_zero_flag);
                $display("  Got:      accumulator=%h, zero_flag=%b",
                         accumulator, zero_flag);
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
