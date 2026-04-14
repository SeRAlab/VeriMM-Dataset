`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg sub;
    wire carry;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .sub(sub),
        .carry(carry),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'h5;
        B = 4'h3;
        sub = 1'b0;
        $display("Test %0d: Addition (No Carry) - A=%h, B=%h, sub=%b", test_num, A, B, sub);
        #1;

        check_outputs(1'b0, 4'h8);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'hA;
        B = 4'h8;
        sub = 1'b0;
        $display("Test %0d: Addition (With Carry) - A=%h, B=%h, sub=%b", test_num, A, B, sub);
        #1;

        check_outputs(1'b1, 4'h2);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'hF;
        B = 4'h1;
        sub = 1'b0;
        $display("Test %0d: Addition (Boundary Max) - A=%h, B=%h, sub=%b", test_num, A, B, sub);
        #1;

        check_outputs(1'b1, 4'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'h0;
        B = 4'h0;
        sub = 1'b0;
        $display("Test %0d: Addition (Zero) - A=%h, B=%h, sub=%b", test_num, A, B, sub);
        #1;

        check_outputs(1'b0, 4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'hA;
        B = 4'h4;
        sub = 1'b1;
        $display("Test %0d: Subtraction (No Borrow) - A=%h, B=%h, sub=%b", test_num, A, B, sub);
        #1;

        check_outputs(1'b0, 4'h6);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'h4;
        B = 4'hA;
        sub = 1'b1;
        $display("Test %0d: Subtraction (With Borrow) - A=%h, B=%h, sub=%b", test_num, A, B, sub);
        #1;

        check_outputs(1'b1, 4'hA);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'h0;
        B = 4'h1;
        sub = 1'b1;
        $display("Test %0d: Subtraction (Boundary Zero) - A=%h, B=%h, sub=%b", test_num, A, B, sub);
        #1;

        check_outputs(1'b1, 4'hF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'hF;
        B = 4'hF;
        sub = 1'b1;
        $display("Test %0d: Subtraction (Equal Values) - A=%h, B=%h, sub=%b", test_num, A, B, sub);
        #1;

        check_outputs(1'b0, 4'h0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'h8;
        B = 4'h0;
        sub = 1'b1;
        $display("Test %0d: Subtraction (Identity) - A=%h, B=%h, sub=%b", test_num, A, B, sub);
        #1;

        check_outputs(1'b0, 4'h8);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'hF;
        B = 4'hF;
        sub = 1'b0;
        $display("Test %0d: Addition (All Ones) - A=%h, B=%h, sub=%b", test_num, A, B, sub);
        #1;

        check_outputs(1'b1, 4'hE);
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
        input expected_carry;
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, sum=%h",
                         carry, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, sum=%h",
                         expected_carry, expected_sum);
                $display("  Got:      carry=%b, sum=%h",
                         carry, sum);
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
