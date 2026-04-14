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
    wire EQ;
    wire GT;

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
        .EQ(EQ),
        .GT(GT)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input1=0000, Input2=0000 (EQ Expected)", test_num);
        {A, B, C, D} = 4'b0000;
        {E, F, G, H} = 4'b0000;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input1=1111, Input2=1111 (EQ Expected)", test_num);
        {A, B, C, D} = 4'b1111;
        {E, F, G, H} = 4'b1111;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input1=1000, Input2=0111 (GT Expected)", test_num);
        {A, B, C, D} = 4'b1000;
        {E, F, G, H} = 4'b0111;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input1=0111, Input2=1000 (Neither EQ nor GT)", test_num);
        {A, B, C, D} = 4'b0111;
        {E, F, G, H} = 4'b1000;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input1=1011, Input2=1010 (GT Expected)", test_num);
        {A, B, C, D} = 4'b1011;
        {E, F, G, H} = 4'b1010;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input1=1001, Input2=1101 (Neither EQ nor GT)", test_num);
        {A, B, C, D} = 4'b1001;
        {E, F, G, H} = 4'b1101;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input1=1111, Input2=0000 (GT Expected)", test_num);
        {A, B, C, D} = 4'b1111;
        {E, F, G, H} = 4'b0000;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input1=0000, Input2=1111 (Neither EQ nor GT)", test_num);
        {A, B, C, D} = 4'b0000;
        {E, F, G, H} = 4'b1111;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input1=1010, Input2=1010 (EQ Expected)", test_num);
        {A, B, C, D} = 4'b1010;
        {E, F, G, H} = 4'b1010;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input1=1100, Input2=1011 (GT Expected)", test_num);
        {A, B, C, D} = 4'b1100;
        {E, F, G, H} = 4'b1011;
        #1;

        check_outputs(1'b0, 1'b1);
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
        input expected_EQ;
        input expected_GT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EQ === (expected_EQ ^ EQ ^ expected_EQ) &&
                expected_GT === (expected_GT ^ GT ^ expected_GT)) begin
                $display("PASS");
                $display("  Outputs: EQ=%b, GT=%b",
                         EQ, GT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EQ=%b, GT=%b",
                         expected_EQ, expected_GT);
                $display("  Got:      EQ=%b, GT=%b",
                         EQ, GT);
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
