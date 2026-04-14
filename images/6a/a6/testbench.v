`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] num1;
    reg [7:0] num2;
    reg [1:0] op;
    wire overflow;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .num1(num1),
        .num2(num2),
        .op(op),
        .overflow(overflow),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition without overflow (15 + 25)", test_num);
        num1 = 8'd15; num2 = 8'd25; op = 2'b00;
        #1;

        check_outputs(1'b0, 8'd40);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition with overflow (200 + 100)", test_num);
        num1 = 8'd200; num2 = 8'd100; op = 2'b00;

        #1;


        check_outputs(1'b1, 8'd255);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition at boundary (255 + 0)", test_num);
        num1 = 8'd255; num2 = 8'd0; op = 2'b00;
        #1;

        check_outputs(1'b0, 8'd255);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction without overflow (100 - 40)", test_num);
        num1 = 8'd100; num2 = 8'd40; op = 2'b01;
        #1;

        check_outputs(1'b0, 8'd60);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction with negative result/overflow (20 - 50)", test_num);
        num1 = 8'd20; num2 = 8'd50; op = 2'b01;

        #1;


        check_outputs(1'b1, 8'hE2);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication without overflow (12 * 10)", test_num);
        num1 = 8'd12; num2 = 8'd10; op = 2'b10;
        #1;

        check_outputs(1'b0, 8'd120);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication with overflow (20 * 20)", test_num);
        num1 = 8'd20; num2 = 8'd20; op = 2'b10;

        #1;


        check_outputs(1'b1, 8'd255);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication by zero (255 * 0)", test_num);
        num1 = 8'd255; num2 = 8'd0; op = 2'b10;
        #1;

        check_outputs(1'b0, 8'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division normal (100 / 4)", test_num);
        num1 = 8'd100; num2 = 8'd4; op = 2'b11;
        #1;

        check_outputs(1'b0, 8'd25);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division resulting in zero (5 / 10)", test_num);
        num1 = 8'd5; num2 = 8'd10; op = 2'b11;
        #1;

        check_outputs(1'b0, 8'd0);
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
        input expected_overflow;
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, result=%h",
                         overflow, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, result=%h",
                         expected_overflow, expected_result);
                $display("  Got:      overflow=%b, result=%h",
                         overflow, result);
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
