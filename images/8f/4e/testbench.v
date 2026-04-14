`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [1:0] OP;
    wire [3:0] RESULT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .OP(OP),
        .RESULT(RESULT)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'd5;
        B = 4'd3;
        OP = 2'b00;
        $display("Test %0d: Addition - %d + %d", test_num, A, B);
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'd12;
        B = 4'd7;
        OP = 2'b00;
        $display("Test %0d: Addition with Overflow - %d + %d", test_num, A, B);
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'd10;
        B = 4'd4;
        OP = 2'b01;
        $display("Test %0d: Subtraction - %d - %d", test_num, A, B);
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'd3;
        B = 4'd8;
        OP = 2'b01;
        $display("Test %0d: Subtraction with Wrap - %d - %d", test_num, A, B);
        #1;

        check_outputs(4'd11);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'd3;
        B = 4'd4;
        OP = 2'b10;
        $display("Test %0d: Multiplication - %d * %d", test_num, A, B);
        #1;

        check_outputs(4'd12);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'd5;
        B = 4'd4;
        OP = 2'b10;
        $display("Test %0d: Multiplication with Overflow - %d * %d", test_num, A, B);
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'd15;
        B = 4'd3;
        OP = 2'b11;
        $display("Test %0d: Division - %d / %d", test_num, A, B);
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'd7;
        B = 4'd2;
        OP = 2'b11;
        $display("Test %0d: Division with Truncation - %d / %d", test_num, A, B);
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'd0;
        B = 4'd15;
        OP = 2'b00;
        $display("Test %0d: Addition with Zero - %d + %d", test_num, A, B);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'd15;
        B = 4'd15;
        OP = 2'b01;
        $display("Test %0d: Subtraction to Zero - %d - %d", test_num, A, B);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        A = 4'd15;
        B = 4'd0;
        OP = 2'b10;
        $display("Test %0d: Multiplication by Zero - %d * %d", test_num, A, B);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        A = 4'd0;
        B = 4'd5;
        OP = 2'b11;
        $display("Test %0d: Division of Zero - %d / %d", test_num, A, B);
        #1;

        check_outputs(4'd0);
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
        input [3:0] expected_RESULT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RESULT === (expected_RESULT ^ RESULT ^ expected_RESULT)) begin
                $display("PASS");
                $display("  Outputs: RESULT=%h",
                         RESULT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RESULT=%h",
                         expected_RESULT);
                $display("  Got:      RESULT=%h",
                         RESULT);
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
