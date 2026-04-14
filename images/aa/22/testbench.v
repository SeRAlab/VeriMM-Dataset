`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] ctrl;
    wire carry_out;
    wire [31:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ctrl(ctrl),
        .carry_out(carry_out),
        .result(result),
        .zero(zero)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 32'd100;
        b = 32'd250;
        ctrl = 4'b0000;
        $display("Test %0d: Addition (100 + 250)", test_num);
        #1;

        check_outputs(1'b0, 32'd350, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 32'hFFFFFFFF;
        b = 32'h00000001;
        ctrl = 4'b0000;
        $display("Test %0d: Addition (Max + 1) -> Carry and Zero", test_num);
        #1;

        check_outputs(1'b1, 32'h00000000, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 32'd500;
        b = 32'd100;
        ctrl = 4'b0001;
        $display("Test %0d: Subtraction (500 - 100)", test_num);
        #1;

        check_outputs(1'b0, 32'd400, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 32'h00000005;
        b = 32'h0000000A;
        ctrl = 4'b0001;
        $display("Test %0d: Subtraction (5 - 10) -> Borrow", test_num);


        #1;



        check_outputs(1'b1, 32'hFFFFFFFB, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 32'hF0F0F0F0;
        b = 32'h0F0F0F0F;
        ctrl = 4'b0010;
        $display("Test %0d: Bitwise AND", test_num);
        #1;

        check_outputs(1'b0, 32'h00000000, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 32'hAAAA0000;
        b = 32'h00005555;
        ctrl = 4'b0011;
        $display("Test %0d: Bitwise OR", test_num);
        #1;

        check_outputs(1'b0, 32'hAAAA5555, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 32'hF0F0F0F0;
        b = 32'hFFFF0000;
        ctrl = 4'b0100;
        $display("Test %0d: Bitwise XOR", test_num);
        #1;

        check_outputs(1'b0, 32'h0F0FF0F0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 32'h00000001;
        b = 32'd4;
        ctrl = 4'b0101;
        $display("Test %0d: Left Shift (1 << 4)", test_num);
        #1;

        check_outputs(1'b0, 32'h00000010, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 32'h80000000;
        b = 32'd1;
        ctrl = 4'b0110;
        $display("Test %0d: Right Shift (0x80... >> 1)", test_num);
        #1;

        check_outputs(1'b0, 32'h40000000, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 32'hDEADBEEF;
        b = 32'hDEADBEEF;
        ctrl = 4'b0001;
        $display("Test %0d: Subtraction Resulting in Zero", test_num);
        #1;

        check_outputs(1'b0, 32'h00000000, 1'b1);
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
        input expected_carry_out;
        input [31:0] expected_result;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, result=%h, zero=%b",
                         carry_out, result, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, result=%h, zero=%b",
                         expected_carry_out, expected_result, expected_zero);
                $display("  Got:      carry_out=%b, result=%h, zero=%b",
                         carry_out, result, zero);
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
