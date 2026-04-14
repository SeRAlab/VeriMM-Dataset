`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg [15:0] dividend;
    reg [15:0] divisor;
    wire [7:0] Y;
    wire divide_by_zero;
    wire [15:0] quotient;
    wire [15:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .dividend(dividend),
        .divisor(divisor),
        .Y(Y),
        .divide_by_zero(divide_by_zero),
        .quotient(quotient),
        .remainder(remainder)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        {A, B, C} = 3'b000;
        dividend = 16'sd100;
        divisor = 16'sd10;
        #1;

        check_outputs(8'h01, 1'b0, 16'sd10, 16'sd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        {A, B, C} = 3'b001;
        dividend = 16'sd-100;
        divisor = 16'sd10;
        #1;

        check_outputs(8'h02, 1'b0, 16'sd-10, 16'sd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        {A, B, C} = 3'b010;
        dividend = 16'sd100;
        divisor = 16'sd-10;
        #1;

        check_outputs(8'h04, 1'b0, 16'sd-10, 16'sd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        {A, B, C} = 3'b011;
        dividend = 16'sd-100;
        divisor = 16'sd-10;
        #1;

        check_outputs(8'h08, 1'b0, 16'sd10, 16'sd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        {A, B, C} = 3'b100;
        dividend = 16'sd7;
        divisor = 16'sd3;
        #1;

        check_outputs(8'h10, 1'b0, 16'sd2, 16'sd1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        {A, B, C} = 3'b101;
        dividend = 16'sd-7;
        divisor = 16'sd3;
        #1;

        check_outputs(8'h20, 1'b0, 16'sd-2, 16'sd-1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        {A, B, C} = 3'b110;
        dividend = 16'sd7;
        divisor = 16'sd-3;
        #1;

        check_outputs(8'h40, 1'b0, 16'sd-2, 16'sd1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        {A, B, C} = 3'b111;
        dividend = 16'sd50;
        divisor = 16'sd0;

        #1;


        check_outputs(8'h80, 1'b1, 16'hxxxx, 16'hxxxx);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        {A, B, C} = 3'b000;
        dividend = 16'sd0;
        divisor = 16'sd25;
        #1;

        check_outputs(8'h01, 1'b0, 16'sd0, 16'sd0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        {A, B, C} = 3'b001;
        dividend = 16'sd32767;
        divisor = 16'sd1;
        #1;

        check_outputs(8'h02, 1'b0, 16'sd32767, 16'sd0);
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
        input [7:0] expected_Y;
        input expected_divide_by_zero;
        input [15:0] expected_quotient;
        input [15:0] expected_remainder;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y) &&
                expected_divide_by_zero === (expected_divide_by_zero ^ divide_by_zero ^ expected_divide_by_zero) &&
                expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: Y=%h, divide_by_zero=%b, quotient=%h, remainder=%h",
                         Y, divide_by_zero, quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h, divide_by_zero=%b, quotient=%h, remainder=%h",
                         expected_Y, expected_divide_by_zero, expected_quotient, expected_remainder);
                $display("  Got:      Y=%h, divide_by_zero=%b, quotient=%h, remainder=%h",
                         Y, divide_by_zero, quotient, remainder);
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
