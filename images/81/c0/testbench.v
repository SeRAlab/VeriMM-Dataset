`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    wire h0;
    wire h1;
    wire h2;
    wire h3;
    wire h4;
    wire h5;
    wire h6;

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
        .h0(h0),
        .h1(h1),
        .h2(h2),
        .h3(h3),
        .h4(h4),
        .h5(h5),
        .h6(h6)
    );
    task testcase001;

    begin
        test_num = 1;
        {A, B, C, D} = 4'b0000;
        #1;

        check_outputs(1, 1, 1, 1, 1, 1, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        {A, B, C, D} = 4'b0001;
        #1;

        check_outputs(0, 1, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        {A, B, C, D} = 4'b0010;
        #1;

        check_outputs(1, 1, 0, 1, 1, 0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        {A, B, C, D} = 4'b0011;
        #1;

        check_outputs(1, 1, 1, 1, 0, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        {A, B, C, D} = 4'b0100;
        #1;

        check_outputs(0, 1, 1, 0, 0, 1, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        {A, B, C, D} = 4'b0101;
        #1;

        check_outputs(1, 0, 1, 1, 0, 1, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        {A, B, C, D} = 4'b0110;
        #1;

        check_outputs(1, 0, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        {A, B, C, D} = 4'b0111;
        #1;

        check_outputs(1, 1, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        {A, B, C, D} = 4'b1000;
        #1;

        check_outputs(1, 1, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        {A, B, C, D} = 4'b1001;
        #1;

        check_outputs(1, 1, 1, 1, 0, 1, 1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        {A, B, C, D} = 4'b1010;
        #1;

        check_outputs(1, 1, 1, 0, 1, 1, 1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        {A, B, C, D} = 4'b1011;
        #1;

        check_outputs(0, 0, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        {A, B, C, D} = 4'b1100;
        #1;

        check_outputs(1, 0, 0, 1, 1, 1, 0);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        {A, B, C, D} = 4'b1101;
        #1;

        check_outputs(0, 1, 1, 1, 1, 0, 1);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        {A, B, C, D} = 4'b1110;
        #1;

        check_outputs(1, 0, 0, 1, 1, 1, 1);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        {A, B, C, D} = 4'b1111;
        #1;

        check_outputs(1, 0, 0, 0, 1, 1, 1);
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
        input expected_h0;
        input expected_h1;
        input expected_h2;
        input expected_h3;
        input expected_h4;
        input expected_h5;
        input expected_h6;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_h0 === (expected_h0 ^ h0 ^ expected_h0) &&
                expected_h1 === (expected_h1 ^ h1 ^ expected_h1) &&
                expected_h2 === (expected_h2 ^ h2 ^ expected_h2) &&
                expected_h3 === (expected_h3 ^ h3 ^ expected_h3) &&
                expected_h4 === (expected_h4 ^ h4 ^ expected_h4) &&
                expected_h5 === (expected_h5 ^ h5 ^ expected_h5) &&
                expected_h6 === (expected_h6 ^ h6 ^ expected_h6)) begin
                $display("PASS");
                $display("  Outputs: h0=%b, h1=%b, h2=%b, h3=%b, h4=%b, h5=%b, h6=%b",
                         h0, h1, h2, h3, h4, h5, h6);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h0=%b, h1=%b, h2=%b, h3=%b, h4=%b, h5=%b, h6=%b",
                         expected_h0, expected_h1, expected_h2, expected_h3, expected_h4, expected_h5, expected_h6);
                $display("  Got:      h0=%b, h1=%b, h2=%b, h3=%b, h4=%b, h5=%b, h6=%b",
                         h0, h1, h2, h3, h4, h5, h6);
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
