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
    task calculate_expected_qr;

        input  [63:0] in_a, in_b, in_c, in_d;
        output [63:0] exp_a, exp_b, exp_c, exp_d;
        reg    [63:0] va, vb, vc, vd;
        begin
            va = in_a; vb = in_b; vc = in_c; vd = in_d;


            va = va + vb;
            vd = vd ^ va;
            vd = (vd << 32) | (vd >> 32);


            vc = vc + vd;
            vb = vb ^ vc;
            vb = (vb << 24) | (vb >> 40);


            va = va + vb;
            vd = vd ^ va;
            vd = (vd << 16) | (vd >> 48);


            vc = vc + vd;
            vb = vb ^ vc;
            vb = (vb << 7) | (vb >> 57);

            exp_a = va; exp_b = vb; exp_c = vc; exp_d = vd;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: All Zeros", test_num);
            a = 64'h0; b = 64'h0; c = 64'h0; d = 64'h0;
            #1;

            check_outputs(64'h0, 64'h0, 64'h0, 64'h0);
        end
        endtask

    task testcase002;

        reg [63:0] ex_a, ex_b, ex_c, ex_d;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: All Ones", test_num);
            a = 64'hFFFFFFFFFFFFFFFF;
            b = 64'hFFFFFFFFFFFFFFFF;
            c = 64'hFFFFFFFFFFFFFFFF;
            d = 64'hFFFFFFFFFFFFFFFF;
            calculate_expected_qr(a, b, c, d, ex_a, ex_b, ex_c, ex_d);
            #1;

            check_outputs(ex_a, ex_b, ex_c, ex_d);
        end
        endtask

    task testcase003;

        reg [63:0] ex_a, ex_b, ex_c, ex_d;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Incremental Pattern", test_num);
            a = 64'h1; b = 64'h2; c = 64'h3; d = 64'h4;
            calculate_expected_qr(a, b, c, d, ex_a, ex_b, ex_c, ex_d);
            #1;

            check_outputs(ex_a, ex_b, ex_c, ex_d);
        end
        endtask

    task testcase004;

        reg [63:0] ex_a, ex_b, ex_c, ex_d;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Checkerboard Pattern", test_num);
            a = 64'hAAAAAAAAAAAAAAAA;
            b = 64'h5555555555555555;
            c = 64'hAAAAAAAAAAAAAAAA;
            d = 64'h5555555555555555;
            calculate_expected_qr(a, b, c, d, ex_a, ex_b, ex_c, ex_d);
            #1;

            check_outputs(ex_a, ex_b, ex_c, ex_d);
        end
        endtask

    task testcase005;

        reg [63:0] ex_a, ex_b, ex_c, ex_d;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: MSB Focus", test_num);
            a = 64'h8000000000000000;
            b = 64'h0000000000000000;
            c = 64'h0000000000000000;
            d = 64'h0000000000000001;
            calculate_expected_qr(a, b, c, d, ex_a, ex_b, ex_c, ex_d);
            #1;

            check_outputs(ex_a, ex_b, ex_c, ex_d);
        end
        endtask

    task testcase006;

        reg [63:0] ex_a, ex_b, ex_c, ex_d;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Mixed Constants", test_num);
            a = 64'h6170786533326279;
            b = 64'h3132333435363738;
            c = 64'h7a7b7c7d7e7f8081;
            d = 64'hedcba98765432100;
            calculate_expected_qr(a, b, c, d, ex_a, ex_b, ex_c, ex_d);
            #1;

            check_outputs(ex_a, ex_b, ex_c, ex_d);
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
