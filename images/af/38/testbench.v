`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg reset;
    wire match;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .reset(reset),
        .match(match)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset behavior check (A > B, but reset active)", test_num);
        A = 4'd15;
        B = 4'd0;
        reset = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset behavior check (A < B, reset active)", test_num);
        A = 4'd1;
        B = 4'd10;
        reset = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A is greater than B (Standard case)", test_num);
        reset = 1; #5; reset = 0;
        A = 4'd10;
        B = 4'd5;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A is less than B (Standard case)", test_num);
        reset = 1; #5; reset = 0;
        A = 4'd3;
        B = 4'd8;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A equals B", test_num);
        reset = 1; #5; reset = 0;
        A = 4'd7;
        B = 4'd7;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A is maximum, B is minimum", test_num);
        reset = 1; #5; reset = 0;
        A = 4'b1111;
        B = 4'b0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A is minimum, B is maximum", test_num);
        reset = 1; #5; reset = 0;
        A = 4'b0000;
        B = 4'b1111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary check (A = B + 1)", test_num);
        reset = 1; #5; reset = 0;
        A = 4'd9;
        B = 4'd8;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary check (B = A + 1)", test_num);
        reset = 1; #5; reset = 0;
        A = 4'd8;
        B = 4'd9;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max values check (A=15, B=15)", test_num);
        reset = 1; #5; reset = 0;
        A = 4'd15;
        B = 4'd15;
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
        input expected_match;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_match === (expected_match ^ match ^ expected_match)) begin
                $display("PASS");
                $display("  Outputs: match=%b",
                         match);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: match=%b",
                         expected_match);
                $display("  Got:      match=%b",
                         match);
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
