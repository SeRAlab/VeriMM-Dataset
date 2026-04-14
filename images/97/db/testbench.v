`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a0;
    reg a1;
    reg a10;
    reg a11;
    reg a12;
    reg a13;
    reg a14;
    reg a15;
    reg a2;
    reg a3;
    reg a4;
    reg a5;
    reg a6;
    reg a7;
    reg a8;
    reg a9;
    reg b0;
    reg b1;
    reg b10;
    reg b11;
    reg b12;
    reg b13;
    reg b14;
    reg b15;
    reg b2;
    reg b3;
    reg b4;
    reg b5;
    reg b6;
    reg b7;
    reg b8;
    reg b9;
    wire cout;
    wire s0;
    wire s1;
    wire s10;
    wire s11;
    wire s12;
    wire s13;
    wire s14;
    wire s15;
    wire s2;
    wire s3;
    wire s4;
    wire s5;
    wire s6;
    wire s7;
    wire s8;
    wire s9;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a0(a0),
        .a1(a1),
        .a10(a10),
        .a11(a11),
        .a12(a12),
        .a13(a13),
        .a14(a14),
        .a15(a15),
        .a2(a2),
        .a3(a3),
        .a4(a4),
        .a5(a5),
        .a6(a6),
        .a7(a7),
        .a8(a8),
        .a9(a9),
        .b0(b0),
        .b1(b1),
        .b10(b10),
        .b11(b11),
        .b12(b12),
        .b13(b13),
        .b14(b14),
        .b15(b15),
        .b2(b2),
        .b3(b3),
        .b4(b4),
        .b5(b5),
        .b6(b6),
        .b7(b7),
        .b8(b8),
        .b9(b9),
        .cout(cout),
        .s0(s0),
        .s1(s1),
        .s10(s10),
        .s11(s11),
        .s12(s12),
        .s13(s13),
        .s14(s14),
        .s15(s15),
        .s2(s2),
        .s3(s3),
        .s4(s4),
        .s5(s5),
        .s6(s6),
        .s7(s7),
        .s8(s8),
        .s9(s9)
    );
    task testcase001;

    begin
        test_num = 1;
        {a15,a14,a13,a12,a11,a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0} = 16'h0000;
        {b15,b14,b13,b12,b11,b10,b9,b8,b7,b6,b5,b4,b3,b2,b1,b0} = 16'h0000;

        #1;


        check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        {a15,a14,a13,a12,a11,a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0} = 16'h0001;
        {b15,b14,b13,b12,b11,b10,b9,b8,b7,b6,b5,b4,b3,b2,b1,b0} = 16'h0001;

        #1;


        check_outputs(0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        {a15,a14,a13,a12,a11,a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0} = 16'hFFFF;
        {b15,b14,b13,b12,b11,b10,b9,b8,b7,b6,b5,b4,b3,b2,b1,b0} = 16'h0001;

        #1;


        check_outputs(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        {a15,a14,a13,a12,a11,a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0} = 16'hAAAA;
        {b15,b14,b13,b12,b11,b10,b9,b8,b7,b6,b5,b4,b3,b2,b1,b0} = 16'h5555;

        #1;


        check_outputs(0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        {a15,a14,a13,a12,a11,a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0} = 16'h8000;
        {b15,b14,b13,b12,b11,b10,b9,b8,b7,b6,b5,b4,b3,b2,b1,b0} = 16'h8000;

        #1;


        check_outputs(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        {a15,a14,a13,a12,a11,a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0} = 16'h1234;
        {b15,b14,b13,b12,b11,b10,b9,b8,b7,b6,b5,b4,b3,b2,b1,b0} = 16'hABCD;



        #1;




        check_outputs(0, 1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        {a15,a14,a13,a12,a11,a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0} = 16'hFFFF;
        {b15,b14,b13,b12,b11,b10,b9,b8,b7,b6,b5,b4,b3,b2,b1,b0} = 16'hFFFF;

        #1;


        check_outputs(1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
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
        input expected_cout;
        input expected_s0;
        input expected_s1;
        input expected_s10;
        input expected_s11;
        input expected_s12;
        input expected_s13;
        input expected_s14;
        input expected_s15;
        input expected_s2;
        input expected_s3;
        input expected_s4;
        input expected_s5;
        input expected_s6;
        input expected_s7;
        input expected_s8;
        input expected_s9;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_s0 === (expected_s0 ^ s0 ^ expected_s0) &&
                expected_s1 === (expected_s1 ^ s1 ^ expected_s1) &&
                expected_s10 === (expected_s10 ^ s10 ^ expected_s10) &&
                expected_s11 === (expected_s11 ^ s11 ^ expected_s11) &&
                expected_s12 === (expected_s12 ^ s12 ^ expected_s12) &&
                expected_s13 === (expected_s13 ^ s13 ^ expected_s13) &&
                expected_s14 === (expected_s14 ^ s14 ^ expected_s14) &&
                expected_s15 === (expected_s15 ^ s15 ^ expected_s15) &&
                expected_s2 === (expected_s2 ^ s2 ^ expected_s2) &&
                expected_s3 === (expected_s3 ^ s3 ^ expected_s3) &&
                expected_s4 === (expected_s4 ^ s4 ^ expected_s4) &&
                expected_s5 === (expected_s5 ^ s5 ^ expected_s5) &&
                expected_s6 === (expected_s6 ^ s6 ^ expected_s6) &&
                expected_s7 === (expected_s7 ^ s7 ^ expected_s7) &&
                expected_s8 === (expected_s8 ^ s8 ^ expected_s8) &&
                expected_s9 === (expected_s9 ^ s9 ^ expected_s9)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, s0=%b, s1=%b, s10=%b, s11=%b, s12=%b, s13=%b, s14=%b, s15=%b, s2=%b, s3=%b, s4=%b, s5=%b, s6=%b, s7=%b, s8=%b, s9=%b",
                         cout, s0, s1, s10, s11, s12, s13, s14, s15, s2, s3, s4, s5, s6, s7, s8, s9);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, s0=%b, s1=%b, s10=%b, s11=%b, s12=%b, s13=%b, s14=%b, s15=%b, s2=%b, s3=%b, s4=%b, s5=%b, s6=%b, s7=%b, s8=%b, s9=%b",
                         expected_cout, expected_s0, expected_s1, expected_s10, expected_s11, expected_s12, expected_s13, expected_s14, expected_s15, expected_s2, expected_s3, expected_s4, expected_s5, expected_s6, expected_s7, expected_s8, expected_s9);
                $display("  Got:      cout=%b, s0=%b, s1=%b, s10=%b, s11=%b, s12=%b, s13=%b, s14=%b, s15=%b, s2=%b, s3=%b, s4=%b, s5=%b, s6=%b, s7=%b, s8=%b, s9=%b",
                         cout, s0, s1, s10, s11, s12, s13, s14, s15, s2, s3, s4, s5, s6, s7, s8, s9);
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
