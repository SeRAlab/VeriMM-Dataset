`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    reg [3:0] e;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .q(q)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: All Zeros");
        a = 4'h0; b = 4'h0; c = 4'h0; d = 4'h0; e = 4'h0;
        expected_val = (a & b) | (c & d) | e;
        #1;

        check_outputs(expected_val);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: All Ones");
        a = 4'hF; b = 4'hF; c = 4'hF; d = 4'hF; e = 4'hF;
        expected_val = (a & b) | (c & d) | e;
        #1;

        check_outputs(expected_val);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Bitwise AND (a & b) only");
        a = 4'hF; b = 4'hA; c = 4'h0; d = 4'h0; e = 4'h0;
        expected_val = (a & b) | (c & d) | e;
        #1;

        check_outputs(expected_val);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Bitwise AND (c & d) only");
        a = 4'h0; b = 4'h0; c = 4'hF; d = 4'h5; e = 4'h0;
        expected_val = (a & b) | (c & d) | e;
        #1;

        check_outputs(expected_val);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Input e only (Pass-through)");
        a = 4'h0; b = 4'h0; c = 4'h0; d = 4'h0; e = 4'hB;
        expected_val = (a & b) | (c & d) | e;
        #1;

        check_outputs(expected_val);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Mismatched ANDs (Result should be 0)");
        a = 4'hA; b = 4'h5; c = 4'hC; d = 4'h3; e = 4'h0;
        expected_val = (a & b) | (c & d) | e;
        #1;

        check_outputs(expected_val);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Walking bits (OR combination)");
        a = 4'h1; b = 4'h1; c = 4'h2; d = 4'h2; e = 4'h4;
        expected_val = (a & b) | (c & d) | e;
        #1;

        check_outputs(expected_val);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: Alternating bit patterns");
        a = 4'h5; b = 4'h5; c = 4'hA; d = 4'hA; e = 4'h0;
        expected_val = (a & b) | (c & d) | e;
        #1;

        check_outputs(expected_val);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case 009: Full saturation");
        a = 4'h7; b = 4'hB; c = 4'hD; d = 4'hE; e = 4'h0;
        expected_val = (a & b) | (c & d) | e;
        #1;

        check_outputs(expected_val);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case 010: Randomized Mix");
        a = 4'h2; b = 4'h3; c = 4'h8; d = 4'hC; e = 4'h1;
        expected_val = (a & b) | (c & d) | e;
        #1;

        check_outputs(expected_val);
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
        input [3:0] expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
