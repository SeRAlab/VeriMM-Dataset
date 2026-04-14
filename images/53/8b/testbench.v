`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    wire a;
    wire b;
    wire c;
    wire com;
    wire d;
    wire e;
    wire f;
    wire g;
    wire test;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .a(a),
        .b(b),
        .c(c),
        .com(com),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .test(test)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        {A, B, C, D} = 4'b0000;
        #1;

        check_outputs(1, 1, 1, 0, 1, 1, 1, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        {A, B, C, D} = 4'b0001;
        #1;

        check_outputs(0, 1, 1, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        {A, B, C, D} = 4'b0010;
        #1;

        check_outputs(1, 1, 0, 0, 1, 1, 0, 1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        {A, B, C, D} = 4'b0011;
        #1;

        check_outputs(1, 1, 1, 0, 1, 0, 0, 1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        {A, B, C, D} = 4'b0100;
        #1;

        check_outputs(0, 1, 1, 0, 0, 0, 1, 1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        {A, B, C, D} = 4'b0101;
        #1;

        check_outputs(1, 0, 1, 0, 1, 0, 1, 1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        {A, B, C, D} = 4'b0110;
        #1;

        check_outputs(1, 0, 1, 0, 1, 1, 1, 1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        {A, B, C, D} = 4'b0111;
        #1;

        check_outputs(1, 1, 1, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        {A, B, C, D} = 4'b1000;
        #1;

        check_outputs(1, 1, 1, 0, 1, 1, 1, 1, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        {A, B, C, D} = 4'b1001;
        #1;

        check_outputs(1, 1, 1, 0, 1, 0, 1, 1, 0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        {A, B, C, D} = 4'b1010;
        #1;

        check_outputs(1, 1, 1, 0, 0, 1, 1, 1, 0);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        {A, B, C, D} = 4'b1011;
        #1;

        check_outputs(0, 0, 1, 0, 1, 1, 1, 1, 0);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        {A, B, C, D} = 4'b1100;
        #1;

        check_outputs(1, 0, 0, 0, 1, 1, 1, 0, 0);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        {A, B, C, D} = 4'b1101;
        #1;

        check_outputs(0, 1, 1, 0, 1, 1, 0, 1, 0);
    end
        endtask

    task testcase015;

    begin
        test_num = test_num + 1;
        {A, B, C, D} = 4'b1110;
        #1;

        check_outputs(1, 0, 0, 0, 1, 1, 1, 1, 0);
    end
        endtask

    task testcase016;

    begin
        test_num = test_num + 1;
        {A, B, C, D} = 4'b1111;
        #1;

        check_outputs(1, 0, 0, 0, 0, 1, 1, 1, 0);
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_a;
        input expected_b;
        input expected_c;
        input expected_com;
        input expected_d;
        input expected_e;
        input expected_f;
        input expected_g;
        input expected_test;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a === (expected_a ^ a ^ expected_a) &&
                expected_b === (expected_b ^ b ^ expected_b) &&
                expected_c === (expected_c ^ c ^ expected_c) &&
                expected_com === (expected_com ^ com ^ expected_com) &&
                expected_d === (expected_d ^ d ^ expected_d) &&
                expected_e === (expected_e ^ e ^ expected_e) &&
                expected_f === (expected_f ^ f ^ expected_f) &&
                expected_g === (expected_g ^ g ^ expected_g) &&
                expected_test === (expected_test ^ test ^ expected_test)) begin
                $display("PASS");
                $display("  Outputs: a=%b, b=%b, c=%b, com=%b, d=%b, e=%b, f=%b, g=%b, test=%b",
                         a, b, c, com, d, e, f, g, test);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a=%b, b=%b, c=%b, com=%b, d=%b, e=%b, f=%b, g=%b, test=%b",
                         expected_a, expected_b, expected_c, expected_com, expected_d, expected_e, expected_f, expected_g, expected_test);
                $display("  Got:      a=%b, b=%b, c=%b, com=%b, d=%b, e=%b, f=%b, g=%b, test=%b",
                         a, b, c, com, d, e, f, g, test);
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
