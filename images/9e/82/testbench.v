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
    reg Q;
    wire valid;

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
        .Q(Q),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All inputs zero", test_num);
            {A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q} = 17'b00000_00000_00000_00;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: All inputs one", test_num);
            {A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q} = 17'b11111_11111_11111_11;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: First half selection", test_num);
            {A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q} = 17'b11111_11110_00000_00;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Second half selection", test_num);
            {A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q} = 17'b00000_00001_11111_11;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Sparse selection (Every 3rd item)", test_num);
            {A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q} = 17'b10010_01001_00100_10;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Alternating bits (Pattern A)", test_num);
            {A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q} = 17'b10101_01010_10101_01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Alternating bits (Pattern B)", test_num);
            {A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q} = 17'b01010_10101_01010_10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Single item (A)", test_num);
            {A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q} = 17'b10000_00000_00000_00;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Single item (Q)", test_num);
            {A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q} = 17'b00000_00000_00000_01;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Dense selection excluding ends", test_num);
            {A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q} = 17'b01111_11111_11111_10;

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
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: valid=%b",
                         valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid=%b",
                         expected_valid);
                $display("  Got:      valid=%b",
                         valid);
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
