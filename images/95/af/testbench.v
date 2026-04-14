`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [49:0] a;
    reg [49:0] b;
    reg cin;
    wire [49:0] c;
    wire [49:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .cin(cin),
        .c(c),
        .s(s)
    );
    task compute_expected;

        input [49:0] ia;
        input [49:0] ib;
        input icin;
        output [49:0] os;
        output [49:0] oc;
        reg [49:0] ts;
        reg [49:0] tc;
        reg last_c;
        integer i;
        begin
            last_c = icin;
            for (i = 0; i < 50; i = i + 1) begin
                ts[i] = ia[i] ^ ib[i] ^ last_c;
                tc[i] = (ia[i] & ib[i]) | (last_c & (ia[i] ^ ib[i]));
                last_c = tc[i];
            end
            os = ts;
            oc = tc;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros", test_num);
            a = 50'h0;
            b = 50'h0;
            cin = 0;
            compute_expected(a, b, cin, exp_s, exp_c);
            #1;

            check_outputs(exp_c, exp_s);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry-in only", test_num);
            a = 50'h0;
            b = 50'h0;
            cin = 1;
            compute_expected(a, b, cin, exp_s, exp_c);
            #1;

            check_outputs(exp_c, exp_s);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Addition (No bit carries)", test_num);
            a = 50'h1111111111111;
            b = 50'h2222222222222;
            cin = 0;
            compute_expected(a, b, cin, exp_s, exp_c);
            #1;

            check_outputs(exp_c, exp_s);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max carry propagation", test_num);
            a = 50'h3FFFFFFFFFFFF;
            b = 50'h0000000000000;
            cin = 1;
            compute_expected(a, b, cin, exp_s, exp_c);
            #1;

            check_outputs(exp_c, exp_s);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Complementary Inputs (Sum all 1s, Carries all 0s)", test_num);
            a = 50'h1555555555555;
            b = 50'h2AAAAAAAAAAAA;
            cin = 0;
            compute_expected(a, b, cin, exp_s, exp_c);
            #1;

            check_outputs(exp_c, exp_s);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Complementary Inputs (Sum all 0s, Carries all 1s)", test_num);
            a = 50'h1555555555555;
            b = 50'h2AAAAAAAAAAAA;
            cin = 1;
            compute_expected(a, b, cin, exp_s, exp_c);
            #1;

            check_outputs(exp_c, exp_s);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Values with Carry", test_num);
            a = 50'h3FFFFFFFFFFFF;
            b = 50'h3FFFFFFFFFFFF;
            cin = 1;
            compute_expected(a, b, cin, exp_s, exp_c);
            #1;

            check_outputs(exp_c, exp_s);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random Pattern 1", test_num);
            a = 50'h0A5A5A5A5A5A5;
            b = 50'h1C3C3C3C3C3C3;
            cin = 0;
            compute_expected(a, b, cin, exp_s, exp_c);
            #1;

            check_outputs(exp_c, exp_s);
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
        input [49:0] expected_c;
        input [49:0] expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: c=%h, s=%h",
                         c, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h, s=%h",
                         expected_c, expected_s);
                $display("  Got:      c=%h, s=%h",
                         c, s);
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
