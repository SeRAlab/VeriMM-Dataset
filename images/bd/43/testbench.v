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
    task clear_inputs;

    begin
        {A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q} = 17'b0;
    end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        clear_inputs();
        $display("Test %0d: All inputs zero (Value=0, Weight=0, Volume=0)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        clear_inputs();
        {A, B, C, D} = 4'b1111;
        $display("Test %0d: Insufficient Value (100 < 120)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        clear_inputs();
        {C, D, E} = 3'b111;
        $display("Test %0d: Boundary Pass (Val=120, W=60, Vol=60)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        clear_inputs();
        {C, D, E, P} = 4'b1111;
        $display("Test %0d: Excessive Weight/Volume (W=62, Vol=63)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        clear_inputs();
        {G, H, J} = 3'b111;
        $display("Test %0d: Excessive Volume (Vol=65)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        clear_inputs();
        {D, H, M, Q} = 4'b1111;
        $display("Test %0d: Valid Mix (Val=125, W=59, Vol=59)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        clear_inputs();
        {O, C, K, Q, P} = 5'b11111;
        $display("Test %0d: Valid Mix Boundary Val (Val=120, W=59, Vol=49)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        {A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q} = 17'h1FFFF;
        $display("Test %0d: All inputs one (Excessive everything)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        clear_inputs();
        {J, I, A} = 3'b111;
        $display("Test %0d: Volume Boundary Fail Value (Val=110, Vol=60)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        clear_inputs();
        {O, N, E} = 3'b111;
        $display("Test %0d: High Value but Overweight (Val=144, W=75)", test_num);
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
