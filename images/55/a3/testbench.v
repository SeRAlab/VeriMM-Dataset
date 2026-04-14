`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A0;
    reg A1;
    reg A2;
    reg A3;
    reg nBI;
    reg nLT;
    reg nRBI;
    wire nA;
    wire nB;
    wire nC;
    wire nD;
    wire nE;
    wire nF;
    wire nG;
    wire nRBO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .nBI(nBI),
        .nLT(nLT),
        .nRBI(nRBI),
        .nA(nA),
        .nB(nB),
        .nC(nC),
        .nD(nD),
        .nE(nE),
        .nF(nF),
        .nG(nG),
        .nRBO(nRBO)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: BCD 0 (Normal)", test_num);

            nLT = 1; nRBI = 1; nBI = 1; A3 = 0; A2 = 0; A1 = 0; A0 = 0;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: BCD 1", test_num);
            nLT = 1; nRBI = 1; nBI = 1; A3 = 0; A2 = 0; A1 = 0; A0 = 1;

            #1;


            check_outputs(1, 0, 0, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: BCD 4", test_num);
            nLT = 1; nRBI = 1; nBI = 1; A3 = 0; A2 = 1; A1 = 0; A0 = 0;

            #1;


            check_outputs(1, 0, 0, 1, 1, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: BCD 8", test_num);
            nLT = 1; nRBI = 1; nBI = 1; A3 = 1; A2 = 0; A1 = 0; A0 = 0;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: BCD 9", test_num);
            nLT = 1; nRBI = 1; nBI = 1; A3 = 1; A2 = 0; A1 = 0; A0 = 1;

            #1;


            check_outputs(0, 0, 0, 0, 1, 0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Error Indication ('F')", test_num);
            nLT = 1; nRBI = 1; nBI = 1; A3 = 1; A2 = 1; A1 = 0; A0 = 1;

            #1;


            check_outputs(0, 1, 1, 1, 0, 0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Lamp Test Active", test_num);
            nLT = 0; nRBI = 1; nBI = 1; A3 = 0; A2 = 0; A1 = 0; A0 = 1;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Blanking Input Active", test_num);
            nLT = 0; nRBI = 0; nBI = 0; A3 = 1; A2 = 0; A1 = 0; A0 = 0;

            #1;


            check_outputs(1, 1, 1, 1, 1, 1, 1, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Ripple Blanking on Zero", test_num);
            nLT = 1; nRBI = 0; nBI = 1; A3 = 0; A2 = 0; A1 = 0; A0 = 0;

            #1;


            check_outputs(1, 1, 1, 1, 1, 1, 1, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Ripple Blanking on Non-Zero", test_num);
            nLT = 1; nRBI = 0; nBI = 1; A3 = 0; A2 = 1; A1 = 0; A0 = 1;


            #1;



            check_outputs(0, 1, 0, 0, 1, 0, 0, 1);
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
        input expected_nA;
        input expected_nB;
        input expected_nC;
        input expected_nD;
        input expected_nE;
        input expected_nF;
        input expected_nG;
        input expected_nRBO;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_nA === (expected_nA ^ nA ^ expected_nA) &&
                expected_nB === (expected_nB ^ nB ^ expected_nB) &&
                expected_nC === (expected_nC ^ nC ^ expected_nC) &&
                expected_nD === (expected_nD ^ nD ^ expected_nD) &&
                expected_nE === (expected_nE ^ nE ^ expected_nE) &&
                expected_nF === (expected_nF ^ nF ^ expected_nF) &&
                expected_nG === (expected_nG ^ nG ^ expected_nG) &&
                expected_nRBO === (expected_nRBO ^ nRBO ^ expected_nRBO)) begin
                $display("PASS");
                $display("  Outputs: nA=%b, nB=%b, nC=%b, nD=%b, nE=%b, nF=%b, nG=%b, nRBO=%b",
                         nA, nB, nC, nD, nE, nF, nG, nRBO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nA=%b, nB=%b, nC=%b, nD=%b, nE=%b, nF=%b, nG=%b, nRBO=%b",
                         expected_nA, expected_nB, expected_nC, expected_nD, expected_nE, expected_nF, expected_nG, expected_nRBO);
                $display("  Got:      nA=%b, nB=%b, nC=%b, nD=%b, nE=%b, nF=%b, nG=%b, nRBO=%b",
                         nA, nB, nC, nD, nE, nF, nG, nRBO);
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
