`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg Sign;
    reg op;
    wire N;
    wire [31:0] S;
    wire V;
    wire Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Sign(Sign),
        .op(op),
        .N(N),
        .S(S),
        .V(V),
        .Z(Z)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Unsigned Addition (No Overflow)", test_num);
        A = 32'h00000005;
        B = 32'h0000000A;
        op = 0;
        Sign = 0;

        #1;


        check_outputs(1'b0, 32'h0000000F, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Unsigned Addition (With Overflow/Carry)", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        op = 0;
        Sign = 0;

        #1;


        check_outputs(1'b0, 32'h00000000, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Unsigned Subtraction (No Borrow)", test_num);
        A = 32'h00000010;
        B = 32'h00000004;
        op = 1;
        Sign = 0;

        #1;


        check_outputs(1'b0, 32'h0000000C, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Unsigned Subtraction (With Borrow)", test_num);
        A = 32'h00000000;
        B = 32'h00000001;
        op = 1;
        Sign = 0;

        #1;


        check_outputs(1'b1, 32'hFFFFFFFF, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Signed Addition Overflow (Pos + Pos)", test_num);
        A = 32'h7FFFFFFF;
        B = 32'h00000001;
        op = 0;
        Sign = 1;

        #1;


        check_outputs(1'b1, 32'h80000000, 1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Signed Addition Overflow (Neg + Neg)", test_num);
        A = 32'h80000000;
        B = 32'hFFFFFFFF;
        op = 0;
        Sign = 1;

        #1;


        check_outputs(1'b0, 32'h7FFFFFFF, 1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Signed Subtraction (Negative Result)", test_num);
        A = 32'h00000005;
        B = 32'h0000000A;
        op = 1;
        Sign = 1;

        #1;


        check_outputs(1'b1, 32'hFFFFFFFB, 1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Signed Subtraction Overflow (Pos - Neg)", test_num);
        A = 32'h7FFFFFFF;
        B = 32'hFFFFFFFF;
        op = 1;
        Sign = 1;

        #1;


        check_outputs(1'b1, 32'h80000000, 1'b1, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Result Check", test_num);
        A = 32'h12345678;
        B = 32'h12345678;
        op = 1;
        Sign = 0;

        #1;


        check_outputs(1'b0, 32'h00000000, 1'b0, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Signed Addition (Mixed Signs)", test_num);
        A = 32'hFFFFFFFF;
        B = 32'h00000001;
        op = 0;
        Sign = 1;

        #1;


        check_outputs(1'b0, 32'h00000000, 1'b0, 1'b1);
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
        input expected_N;
        input [31:0] expected_S;
        input expected_V;
        input expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_N === (expected_N ^ N ^ expected_N) &&
                expected_S === (expected_S ^ S ^ expected_S) &&
                expected_V === (expected_V ^ V ^ expected_V) &&
                expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: N=%b, S=%h, V=%b, Z=%b",
                         N, S, V, Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: N=%b, S=%h, V=%b, Z=%b",
                         expected_N, expected_S, expected_V, expected_Z);
                $display("  Got:      N=%b, S=%h, V=%b, Z=%b",
                         N, S, V, Z);
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
