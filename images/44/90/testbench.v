`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg SUB;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .SUB(SUB),
        .Q(Q)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'd0;
        B = 4'd0;
        SUB = 1'b0;
        $display("Test %0d: Simple Addition (0 + 0)", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'd5;
        B = 4'd3;
        SUB = 1'b0;
        $display("Test %0d: Simple Addition (5 + 3)", test_num);
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'd10;
        B = 4'd5;
        SUB = 1'b0;
        $display("Test %0d: Addition with max value (10 + 5)", test_num);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'd15;
        B = 4'd1;
        SUB = 1'b0;
        $display("Test %0d: Addition with overflow (15 + 1)", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'd10;
        B = 4'd4;
        SUB = 1'b1;
        $display("Test %0d: Simple Subtraction (10 - 4)", test_num);
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'd5;
        B = 4'd10;
        SUB = 1'b1;
        $display("Test %0d: Subtraction with negative result (5 - 10)", test_num);

        #1;


        check_outputs(4'd11);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'd0;
        B = 4'd1;
        SUB = 1'b1;
        $display("Test %0d: Subtraction underflow (0 - 1)", test_num);

        #1;


        check_outputs(4'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'd15;
        B = 4'd15;
        SUB = 1'b1;
        $display("Test %0d: Subtraction to zero (15 - 15)", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'd8;
        B = 4'd8;
        SUB = 1'b0;
        $display("Test %0d: Addition overflow (8 + 8)", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'd7;
        B = 4'd2;
        SUB = 1'b1;
        $display("Test %0d: Subtraction (7 - 2)", test_num);
        #1;

        check_outputs(4'd5);
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
        input [3:0] expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
