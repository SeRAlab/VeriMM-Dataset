`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg bitA;
    reg bitB;
    reg bitC;
    reg bitD;
    wire s_seg1;
    wire s_seg2;
    wire s_seg3;
    wire s_seg4;
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
        .s_seg1(s_seg1),
        .s_seg2(s_seg2),
        .s_seg3(s_seg3),
        .s_seg4(s_seg4),
        .seg_a(seg_a),
        .seg_b(seg_b),
        .seg_c(seg_c),
        .seg_d(seg_d),
        .seg_e(seg_e),
        .seg_f(seg_f),
        .seg_g(seg_g)
    );
    task testcase000;

        begin
            test_num = 0;
            {bitA, bitB, bitC, bitD} = 4'b0000;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            {bitA, bitB, bitC, bitD} = 4'b0001;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            {bitA, bitB, bitC, bitD} = 4'b0010;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            {bitA, bitB, bitC, bitD} = 4'b0011;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            {bitA, bitB, bitC, bitD} = 4'b0100;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            {bitA, bitB, bitC, bitD} = 4'b0101;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            {bitA, bitB, bitC, bitD} = 4'b0110;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            {bitA, bitB, bitC, bitD} = 4'b0111;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            {bitA, bitB, bitC, bitD} = 4'b1000;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            {bitA, bitB, bitC, bitD} = 4'b1001;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            {bitA, bitB, bitC, bitD} = 4'b1010;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            {bitA, bitB, bitC, bitD} = 4'b1011;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            {bitA, bitB, bitC, bitD} = 4'b1100;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            {bitA, bitB, bitC, bitD} = 4'b1101;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            {bitA, bitB, bitC, bitD} = 4'b1110;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            {bitA, bitB, bitC, bitD} = 4'b1111;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1);
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


        testcase000();
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
        input expected_s_seg1;
        input expected_s_seg2;
        input expected_s_seg3;
        input expected_s_seg4;
        input expected_seg_a;
        input expected_seg_b;
        input expected_seg_c;
        input expected_seg_d;
        input expected_seg_e;
        input expected_seg_f;
        input expected_seg_g;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s_seg1 === (expected_s_seg1 ^ s_seg1 ^ expected_s_seg1) &&
                expected_s_seg2 === (expected_s_seg2 ^ s_seg2 ^ expected_s_seg2) &&
                expected_s_seg3 === (expected_s_seg3 ^ s_seg3 ^ expected_s_seg3) &&
                expected_s_seg4 === (expected_s_seg4 ^ s_seg4 ^ expected_s_seg4) &&
                expected_seg_a === (expected_seg_a ^ seg_a ^ expected_seg_a) &&
                expected_seg_b === (expected_seg_b ^ seg_b ^ expected_seg_b) &&
                expected_seg_c === (expected_seg_c ^ seg_c ^ expected_seg_c) &&
                expected_seg_d === (expected_seg_d ^ seg_d ^ expected_seg_d) &&
                expected_seg_e === (expected_seg_e ^ seg_e ^ expected_seg_e) &&
                expected_seg_f === (expected_seg_f ^ seg_f ^ expected_seg_f) &&
                expected_seg_g === (expected_seg_g ^ seg_g ^ expected_seg_g)) begin
                $display("PASS");
                $display("  Outputs: s_seg1=%b, s_seg2=%b, s_seg3=%b, s_seg4=%b, seg_a=%b, seg_b=%b, seg_c=%b, seg_d=%b, seg_e=%b, seg_f=%b, seg_g=%b",
                         s_seg1, s_seg2, s_seg3, s_seg4, seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s_seg1=%b, s_seg2=%b, s_seg3=%b, s_seg4=%b, seg_a=%b, seg_b=%b, seg_c=%b, seg_d=%b, seg_e=%b, seg_f=%b, seg_g=%b",
                         expected_s_seg1, expected_s_seg2, expected_s_seg3, expected_s_seg4, expected_seg_a, expected_seg_b, expected_seg_c, expected_seg_d, expected_seg_e, expected_seg_f, expected_seg_g);
                $display("  Got:      s_seg1=%b, s_seg2=%b, s_seg3=%b, s_seg4=%b, seg_a=%b, seg_b=%b, seg_c=%b, seg_d=%b, seg_e=%b, seg_f=%b, seg_g=%b",
                         s_seg1, s_seg2, s_seg3, s_seg4, seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g);
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
