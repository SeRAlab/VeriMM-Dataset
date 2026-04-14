`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg B1;
    reg C1;
    reg D2;
    reg E2;
    reg F1;
    reg F2;
    reg H1;
    reg J1;
    reg K2;
    reg L2;
    reg M1;
    reg M2;
    reg N1;
    reg P1;
    reg R2;
    reg S2;
    reg T2;
    wire D1;
    wire E1;
    wire H2;
    wire J2;
    wire K1;
    wire L1;
    wire N2;
    wire P2;
    wire R1;
    wire S1;
    wire U2;
    wire V2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1(A1),
        .B1(B1),
        .C1(C1),
        .D2(D2),
        .E2(E2),
        .F1(F1),
        .F2(F2),
        .H1(H1),
        .J1(J1),
        .K2(K2),
        .L2(L2),
        .M1(M1),
        .M2(M2),
        .N1(N1),
        .P1(P1),
        .R2(R2),
        .S2(S2),
        .T2(T2),
        .D1(D1),
        .E1(E1),
        .H2(H2),
        .J2(J2),
        .K1(K1),
        .L1(L1),
        .N2(N2),
        .P2(P2),
        .R1(R1),
        .S1(S1),
        .U2(U2),
        .V2(V2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs Low - All outputs High-Z", test_num);
            A1=0; B1=0; C1=0; D2=0; E2=0; F1=0; F2=0; H1=0; J1=0; K2=0; L2=0; M1=0; M2=0; N1=0; P1=0; R2=0; S2=0; T2=0;
            #1;

            check_outputs(1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Primary inputs High (A1, F1, M1, D2, K2, R2) - Specific outputs Low", test_num);

            A1=1; B1=0; C1=0; F1=1; H1=0; J1=0; M1=1; N1=0; P1=0; D2=1; E2=0; F2=0; K2=1; L2=0; M2=0; R2=1; S2=0; T2=0;

            #1;


            check_outputs(1'b0, 1'bz, 1'b0, 1'bz, 1'b0, 1'bz, 1'b0, 1'bz, 1'b0, 1'bz, 1'b0, 1'bz);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Secondary inputs High (B1, H1, N1, E2, L2, S2) - Specific outputs Low", test_num);

            A1=0; B1=1; C1=0; F1=0; H1=1; J1=0; M1=0; N1=1; P1=0; D2=0; E2=1; F2=0; K2=0; L2=1; M2=0; R2=0; S2=1; T2=0;

            #1;


            check_outputs(1'bz, 1'b0, 1'bz, 1'b0, 1'bz, 1'b0, 1'bz, 1'b0, 1'bz, 1'b0, 1'bz, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Common control inputs High (C1, J1, P1, F2, M2, T2) - All outputs Low", test_num);
            A1=0; B1=0; C1=1; F1=0; H1=0; J1=1; M1=0; N1=0; P1=1; D2=0; E2=0; F2=1; K2=0; L2=0; M2=1; R2=0; S2=0; T2=1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Partial control - Only Section 1 C1 and Section 2 F2 High", test_num);
            A1=0; B1=0; C1=1; D2=0; E2=0; F2=1; F1=0; H1=0; J1=0; K2=0; L2=0; M2=0; M1=0; N1=0; P1=0; R2=0; S2=0; T2=0;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overlapping inputs (A1 and C1 High) - D1 should be Low", test_num);
            A1=1; B1=0; C1=1; D2=0; E2=0; F2=0; F1=0; H1=0; J1=0; K2=0; L2=0; M2=0; M1=0; N1=0; P1=0; R2=0; S2=0; T2=0;

            #1;


            check_outputs(1'b0, 1'b0, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz, 1'bz);
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
        input expected_D1;
        input expected_E1;
        input expected_H2;
        input expected_J2;
        input expected_K1;
        input expected_L1;
        input expected_N2;
        input expected_P2;
        input expected_R1;
        input expected_S1;
        input expected_U2;
        input expected_V2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D1 === (expected_D1 ^ D1 ^ expected_D1) &&
                expected_E1 === (expected_E1 ^ E1 ^ expected_E1) &&
                expected_H2 === (expected_H2 ^ H2 ^ expected_H2) &&
                expected_J2 === (expected_J2 ^ J2 ^ expected_J2) &&
                expected_K1 === (expected_K1 ^ K1 ^ expected_K1) &&
                expected_L1 === (expected_L1 ^ L1 ^ expected_L1) &&
                expected_N2 === (expected_N2 ^ N2 ^ expected_N2) &&
                expected_P2 === (expected_P2 ^ P2 ^ expected_P2) &&
                expected_R1 === (expected_R1 ^ R1 ^ expected_R1) &&
                expected_S1 === (expected_S1 ^ S1 ^ expected_S1) &&
                expected_U2 === (expected_U2 ^ U2 ^ expected_U2) &&
                expected_V2 === (expected_V2 ^ V2 ^ expected_V2)) begin
                $display("PASS");
                $display("  Outputs: D1=%b, E1=%b, H2=%b, J2=%b, K1=%b, L1=%b, N2=%b, P2=%b, R1=%b, S1=%b, U2=%b, V2=%b",
                         D1, E1, H2, J2, K1, L1, N2, P2, R1, S1, U2, V2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D1=%b, E1=%b, H2=%b, J2=%b, K1=%b, L1=%b, N2=%b, P2=%b, R1=%b, S1=%b, U2=%b, V2=%b",
                         expected_D1, expected_E1, expected_H2, expected_J2, expected_K1, expected_L1, expected_N2, expected_P2, expected_R1, expected_S1, expected_U2, expected_V2);
                $display("  Got:      D1=%b, E1=%b, H2=%b, J2=%b, K1=%b, L1=%b, N2=%b, P2=%b, R1=%b, S1=%b, U2=%b, V2=%b",
                         D1, E1, H2, J2, K1, L1, N2, P2, R1, S1, U2, V2);
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
