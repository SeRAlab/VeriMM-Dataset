`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg C;
    reg F;
    reg G;
    reg W;
    wire A;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C(C),
        .F(F),
        .G(G),
        .W(W),
        .A(A)
    );
    task testcase001;

    begin
        test_num = 1;
        {F, C, G, W} = 4'd0;
        $display("Test %0d: Binary 0000 (Dec 0)", test_num);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        {F, C, G, W} = 4'd1;
        $display("Test %0d: Binary 0001 (Dec 1)", test_num);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        {F, C, G, W} = 4'd2;
        $display("Test %0d: Binary 0010 (Dec 2)", test_num);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        {F, C, G, W} = 4'd3;
        $display("Test %0d: Binary 0011 (Dec 3)", test_num);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        {F, C, G, W} = 4'd4;
        $display("Test %0d: Binary 0100 (Dec 4)", test_num);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        {F, C, G, W} = 4'd5;
        $display("Test %0d: Binary 0101 (Dec 5)", test_num);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        {F, C, G, W} = 4'd6;
        $display("Test %0d: Binary 0110 (Dec 6)", test_num);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        {F, C, G, W} = 4'd7;
        $display("Test %0d: Binary 0111 (Dec 7)", test_num);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        {F, C, G, W} = 4'd8;
        $display("Test %0d: Binary 1000 (Dec 8)", test_num);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        {F, C, G, W} = 4'd9;
        $display("Test %0d: Binary 1001 (Dec 9)", test_num);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        {F, C, G, W} = 4'd10;
        $display("Test %0d: Binary 1010 (Dec 10)", test_num);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        {F, C, G, W} = 4'd11;
        $display("Test %0d: Binary 1011 (Dec 11)", test_num);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        {F, C, G, W} = 4'd12;
        $display("Test %0d: Binary 1100 (Dec 12)", test_num);
        #1;

        check_outputs(1);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        {F, C, G, W} = 4'd13;
        $display("Test %0d: Binary 1101 (Dec 13)", test_num);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        {F, C, G, W} = 4'd14;
        $display("Test %0d: Binary 1110 (Dec 14)", test_num);
        #1;

        check_outputs(0);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        {F, C, G, W} = 4'd15;
        $display("Test %0d: Binary 1111 (Dec 15)", test_num);
        #1;

        check_outputs(0);
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
        input expected_A;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A === (expected_A ^ A ^ expected_A)) begin
                $display("PASS");
                $display("  Outputs: A=%b",
                         A);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A=%b",
                         expected_A);
                $display("  Got:      A=%b",
                         A);
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
