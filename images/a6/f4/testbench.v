`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] x;
    wire [3:0] r0;
    wire [3:0] r1;
    wire [3:0] r2;
    wire [3:0] r3;
    wire [3:0] r4;
    wire [3:0] r5;
    wire [3:0] r6;
    wire [3:0] r7;
    wire [3:0] r8;
    wire [3:0] r9;
    wire [3:0] rA;
    wire [3:0] rB;
    wire [3:0] rC;
    wire [3:0] rD;
    wire [3:0] rE;
    wire [3:0] rF;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .r0(r0),
        .r1(r1),
        .r2(r2),
        .r3(r3),
        .r4(r4),
        .r5(r5),
        .r6(r6),
        .r7(r7),
        .r8(r8),
        .r9(r9),
        .rA(rA),
        .rB(rB),
        .rC(rC),
        .rD(rD),
        .rE(rE),
        .rF(rF)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        x = 64'h0000_0000_0000_0000;
        #1;

        check_outputs(4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones", test_num);
        x = 64'hFFFF_FFFF_FFFF_FFFF;
        #1;

        check_outputs(4'hF, 4'hF, 4'hF, 4'hF, 4'hF, 4'hF, 4'hF, 4'hF, 4'hF, 4'hF, 4'hF, 4'hF, 4'hF, 4'hF, 4'hF, 4'hF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sequential Nibbles 0 to F", test_num);

        x = 64'hFEDC_BA98_7654_3210;
        #1;

        check_outputs(4'h0, 4'h1, 4'h2, 4'h3, 4'h4, 4'h5, 4'h6, 4'h7, 4'h8, 4'h9, 4'hA, 4'hB, 4'hC, 4'hD, 4'hE, 4'hF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sequential Nibbles F to 0", test_num);

        x = 64'h0123_4567_89AB_CDEF;
        #1;

        check_outputs(4'hF, 4'hE, 4'hD, 4'hC, 4'hB, 4'hA, 4'h9, 4'h8, 4'h7, 4'h6, 4'h5, 4'h4, 4'h3, 4'h2, 4'h1, 4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating A and 5", test_num);
        x = 64'hA5A5_A5A5_A5A5_A5A5;
        #1;

        check_outputs(4'h5, 4'hA, 4'h5, 4'hA, 4'h5, 4'hA, 4'h5, 4'hA, 4'h5, 4'hA, 4'h5, 4'hA, 4'h5, 4'hA, 4'h5, 4'hA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single bit per nibble (Power of 2)", test_num);
        x = 64'h8421_8421_8421_8421;
        #1;

        check_outputs(4'h1, 4'h2, 4'h4, 4'h8, 4'h1, 4'h2, 4'h4, 4'h8, 4'h1, 4'h2, 4'h4, 4'h8, 4'h1, 4'h2, 4'h4, 4'h8);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Prime-like/Arbitrary pattern", test_num);
        x = 64'hBADA_55AD_C0DE_FEED;
        #1;

        check_outputs(4'hD, 4'hE, 4'hE, 4'hF, 4'hE, 4'hD, 4'h0, 4'hC, 4'hD, 4'hA, 4'h5, 4'h5, 4'hA, 4'hD, 4'hA, 4'hB);
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
        input [3:0] expected_r0;
        input [3:0] expected_r1;
        input [3:0] expected_r2;
        input [3:0] expected_r3;
        input [3:0] expected_r4;
        input [3:0] expected_r5;
        input [3:0] expected_r6;
        input [3:0] expected_r7;
        input [3:0] expected_r8;
        input [3:0] expected_r9;
        input [3:0] expected_rA;
        input [3:0] expected_rB;
        input [3:0] expected_rC;
        input [3:0] expected_rD;
        input [3:0] expected_rE;
        input [3:0] expected_rF;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_r0 === (expected_r0 ^ r0 ^ expected_r0) &&
                expected_r1 === (expected_r1 ^ r1 ^ expected_r1) &&
                expected_r2 === (expected_r2 ^ r2 ^ expected_r2) &&
                expected_r3 === (expected_r3 ^ r3 ^ expected_r3) &&
                expected_r4 === (expected_r4 ^ r4 ^ expected_r4) &&
                expected_r5 === (expected_r5 ^ r5 ^ expected_r5) &&
                expected_r6 === (expected_r6 ^ r6 ^ expected_r6) &&
                expected_r7 === (expected_r7 ^ r7 ^ expected_r7) &&
                expected_r8 === (expected_r8 ^ r8 ^ expected_r8) &&
                expected_r9 === (expected_r9 ^ r9 ^ expected_r9) &&
                expected_rA === (expected_rA ^ rA ^ expected_rA) &&
                expected_rB === (expected_rB ^ rB ^ expected_rB) &&
                expected_rC === (expected_rC ^ rC ^ expected_rC) &&
                expected_rD === (expected_rD ^ rD ^ expected_rD) &&
                expected_rE === (expected_rE ^ rE ^ expected_rE) &&
                expected_rF === (expected_rF ^ rF ^ expected_rF)) begin
                $display("PASS");
                $display("  Outputs: r0=%h, r1=%h, r2=%h, r3=%h, r4=%h, r5=%h, r6=%h, r7=%h, r8=%h, r9=%h, rA=%h, rB=%h, rC=%h, rD=%h, rE=%h, rF=%h",
                         r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, rA, rB, rC, rD, rE, rF);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r0=%h, r1=%h, r2=%h, r3=%h, r4=%h, r5=%h, r6=%h, r7=%h, r8=%h, r9=%h, rA=%h, rB=%h, rC=%h, rD=%h, rE=%h, rF=%h",
                         expected_r0, expected_r1, expected_r2, expected_r3, expected_r4, expected_r5, expected_r6, expected_r7, expected_r8, expected_r9, expected_rA, expected_rB, expected_rC, expected_rD, expected_rE, expected_rF);
                $display("  Got:      r0=%h, r1=%h, r2=%h, r3=%h, r4=%h, r5=%h, r6=%h, r7=%h, r8=%h, r9=%h, rA=%h, rB=%h, rC=%h, rD=%h, rE=%h, rF=%h",
                         r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, rA, rB, rC, rD, rE, rF);
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
