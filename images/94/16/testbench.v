`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg bitA;
    reg bitB;
    reg bitC;
    reg bitD;
    wire seg_a;
    wire seg_b;
    wire seg_c;
    wire seg_d;
    wire seg_e;
    wire seg_f;
    wire seg_g;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bitA(bitA),
        .bitB(bitB),
        .bitC(bitC),
        .bitD(bitD),
        .seg_a(seg_a),
        .seg_b(seg_b),
        .seg_c(seg_c),
        .seg_d(seg_d),
        .seg_e(seg_e),
        .seg_f(seg_f),
        .seg_g(seg_g)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Binary 0000 (Hex 0)", test_num);
            {bitA, bitB, bitC, bitD} = 4'b0000;
            #1;

            check_outputs(1, 1, 1, 1, 1, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Binary 0001 (Hex 1)", test_num);
            {bitA, bitB, bitC, bitD} = 4'b0001;
            #1;

            check_outputs(0, 1, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Binary 0010 (Hex 2)", test_num);
            {bitA, bitB, bitC, bitD} = 4'b0010;
            #1;

            check_outputs(1, 1, 0, 1, 1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Binary 0011 (Hex 3)", test_num);
            {bitA, bitB, bitC, bitD} = 4'b0011;
            #1;

            check_outputs(1, 1, 1, 1, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Binary 0100 (Hex 4)", test_num);
            {bitA, bitB, bitC, bitD} = 4'b0100;
            #1;

            check_outputs(0, 1, 1, 0, 0, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Binary 0101 (Hex 5)", test_num);
            {bitA, bitB, bitC, bitD} = 4'b0101;
            #1;

            check_outputs(1, 0, 1, 1, 0, 1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Binary 0110 (Hex 6)", test_num);
            {bitA, bitB, bitC, bitD} = 4'b0110;
            #1;

            check_outputs(1, 0, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Binary 0111 (Hex 7)", test_num);
            {bitA, bitB, bitC, bitD} = 4'b0111;
            #1;

            check_outputs(1, 1, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Binary 1000 (Hex 8)", test_num);
            {bitA, bitB, bitC, bitD} = 4'b1000;
            #1;

            check_outputs(1, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Binary 1001 (Hex 9)", test_num);
            {bitA, bitB, bitC, bitD} = 4'b1001;
            #1;

            check_outputs(1, 1, 1, 1, 0, 1, 1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test %0d: Binary 1010 (Hex A)", test_num);
            {bitA, bitB, bitC, bitD} = 4'b1010;
            #1;

            check_outputs(1, 1, 1, 0, 1, 1, 1);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test %0d: Binary 1011 (Hex B)", test_num);
            {bitA, bitB, bitC, bitD} = 4'b1011;
            #1;

            check_outputs(0, 0, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            $display("Test %0d: Binary 1100 (Hex C)", test_num);
            {bitA, bitB, bitC, bitD} = 4'b1100;
            #1;

            check_outputs(1, 0, 0, 1, 1, 1, 0);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            $display("Test %0d: Binary 1101 (Hex D)", test_num);
            {bitA, bitB, bitC, bitD} = 4'b1101;
            #1;

            check_outputs(0, 1, 1, 1, 1, 0, 1);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            $display("Test %0d: Binary 1110 (Hex E)", test_num);
            {bitA, bitB, bitC, bitD} = 4'b1110;
            #1;

            check_outputs(1, 0, 0, 1, 1, 1, 1);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            $display("Test %0d: Binary 1111 (Hex F)", test_num);
            {bitA, bitB, bitC, bitD} = 4'b1111;
            #1;

            check_outputs(1, 0, 0, 0, 1, 1, 1);
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
        input expected_seg_a;
        input expected_seg_b;
        input expected_seg_c;
        input expected_seg_d;
        input expected_seg_e;
        input expected_seg_f;
        input expected_seg_g;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seg_a === (expected_seg_a ^ seg_a ^ expected_seg_a) &&
                expected_seg_b === (expected_seg_b ^ seg_b ^ expected_seg_b) &&
                expected_seg_c === (expected_seg_c ^ seg_c ^ expected_seg_c) &&
                expected_seg_d === (expected_seg_d ^ seg_d ^ expected_seg_d) &&
                expected_seg_e === (expected_seg_e ^ seg_e ^ expected_seg_e) &&
                expected_seg_f === (expected_seg_f ^ seg_f ^ expected_seg_f) &&
                expected_seg_g === (expected_seg_g ^ seg_g ^ expected_seg_g)) begin
                $display("PASS");
                $display("  Outputs: seg_a=%b, seg_b=%b, seg_c=%b, seg_d=%b, seg_e=%b, seg_f=%b, seg_g=%b",
                         seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg_a=%b, seg_b=%b, seg_c=%b, seg_d=%b, seg_e=%b, seg_f=%b, seg_g=%b",
                         expected_seg_a, expected_seg_b, expected_seg_c, expected_seg_d, expected_seg_e, expected_seg_f, expected_seg_g);
                $display("  Got:      seg_a=%b, seg_b=%b, seg_c=%b, seg_d=%b, seg_e=%b, seg_f=%b, seg_g=%b",
                         seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g);
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
