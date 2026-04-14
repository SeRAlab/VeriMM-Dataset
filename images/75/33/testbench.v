`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    reg [63:0] c;
    reg [63:0] d;
    wire [63:0] a_prim;
    wire [63:0] b_prim;
    wire [63:0] c_prim;
    wire [63:0] d_prim;

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
        .a_prim(a_prim),
        .b_prim(b_prim),
        .c_prim(c_prim),
        .d_prim(d_prim)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: All Zeros", test_num);
            a = 64'h0; b = 64'h0; c = 64'h0; d = 64'h0;
            #1;

            check_outputs(64'h0, 64'h0, 64'h0, 64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Incremental Low Values", test_num);
            a = 64'h1; b = 64'h2; c = 64'h3; d = 64'h4;
            #1;

            check_outputs(
                64'h0700000001000003,
                64'h8383808380818381,
                64'h0007010700030703,
                64'h0007010000030700
            );
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: All Ones", test_num);
            a = 64'hFFFFFFFFFFFFFFFF;
            b = 64'hFFFFFFFFFFFFFFFF;
            c = 64'hFFFFFFFFFFFFFFFF;
            d = 64'hFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(
                64'hFEFFFFFFFFFFFFFD,
                64'h007FF7FFFFFF9008,
                64'hFFFFEFFFFFFFDFEF,
                64'hFFFFEFFFFFFDFEFF
            );
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Alternating Patterns (5/A)", test_num);
            a = 64'h5555555555555555;
            b = 64'hAAAAAAAAAAAAAAAA;
            c = 64'h5555555555555555;
            d = 64'hAAAAAAAAAAAAAAAA;
            #1;

            check_outputs(
                64'hFFFFFFFFFFFFFFFF,
                64'h2AAAAAAAAAAAAAAAA,
                64'h5555555555555554,
                64'hAAAAAAAAAAAAAAAA
            );
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Sparse High Bits", test_num);
            a = 64'h8000000000000000;
            b = 64'h0000000000000001;
            c = 64'h0000000000000000;
            d = 64'h0000000000000000;
            #1;

            check_outputs(
                64'h8000000100000001,
                64'h4000000080000000,
                64'h8000000180000001,
                64'h8000000180000001
            );
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
        input [63:0] expected_a_prim;
        input [63:0] expected_b_prim;
        input [63:0] expected_c_prim;
        input [63:0] expected_d_prim;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a_prim === (expected_a_prim ^ a_prim ^ expected_a_prim) &&
                expected_b_prim === (expected_b_prim ^ b_prim ^ expected_b_prim) &&
                expected_c_prim === (expected_c_prim ^ c_prim ^ expected_c_prim) &&
                expected_d_prim === (expected_d_prim ^ d_prim ^ expected_d_prim)) begin
                $display("PASS");
                $display("  Outputs: a_prim=%h, b_prim=%h, c_prim=%h, d_prim=%h",
                         a_prim, b_prim, c_prim, d_prim);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_prim=%h, b_prim=%h, c_prim=%h, d_prim=%h",
                         expected_a_prim, expected_b_prim, expected_c_prim, expected_d_prim);
                $display("  Got:      a_prim=%h, b_prim=%h, c_prim=%h, d_prim=%h",
                         a_prim, b_prim, c_prim, d_prim);
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
