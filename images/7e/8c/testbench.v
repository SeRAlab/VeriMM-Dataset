`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    reg E;
    reg F;
    reg G;
    reg H;
    reg I;
    reg J;
    reg K;
    reg L;
    reg M;
    reg N;
    reg O;
    reg P;
    reg S;
    reg T;
    reg U;
    reg V;
    wire Y;

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
        .E(E),
        .F(F),
        .G(G),
        .H(H),
        .I(I),
        .J(J),
        .K(K),
        .L(L),
        .M(M),
        .N(N),
        .O(O),
        .P(P),
        .S(S),
        .T(T),
        .U(U),
        .V(V),
        .Y(Y)
    );
    task reset_inputs;

    begin
        A = 0; B = 0; C = 0; D = 0;
        E = 0; F = 0; G = 0; H = 0;
        I = 0; J = 0; K = 0; L = 0;
        M = 0; N = 0; O = 0; P = 0;
        S = 0; T = 0; U = 0; V = 0;
    end
        endtask

    task testcase001;

    begin
        test_num = 1;
        reset_inputs();
        V = 0; U = 0; T = 0; S = 0;
        A = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_inputs();
        V = 0; U = 0; T = 0; S = 1;
        B = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_inputs();
        V = 0; U = 0; T = 1; S = 0;
        C = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_inputs();
        V = 0; U = 0; T = 1; S = 1;
        D = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_inputs();
        V = 0; U = 1; T = 0; S = 0;
        E = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_inputs();
        V = 0; U = 1; T = 0; S = 1;
        F = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_inputs();
        V = 0; U = 1; T = 1; S = 0;
        G = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_inputs();
        V = 0; U = 1; T = 1; S = 1;
        H = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        reset_inputs();
        V = 1; U = 0; T = 0; S = 0;
        I = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        reset_inputs();
        V = 1; U = 0; T = 0; S = 1;
        J = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        reset_inputs();
        V = 1; U = 0; T = 1; S = 0;
        K = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        reset_inputs();
        V = 1; U = 0; T = 1; S = 1;
        L = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        reset_inputs();
        V = 1; U = 1; T = 0; S = 0;
        M = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        reset_inputs();
        V = 1; U = 1; T = 0; S = 1;
        N = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        reset_inputs();
        V = 1; U = 1; T = 1; S = 0;
        O = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        reset_inputs();
        V = 1; U = 1; T = 1; S = 1;
        P = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase017;

    begin
        test_num = 17;
        reset_inputs();
        V = 0; U = 0; T = 0; S = 0;
        A = 0;
        #1;

        check_outputs(1'b0);
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
        testcase017();
        
        
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
