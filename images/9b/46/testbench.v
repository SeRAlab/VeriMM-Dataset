`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    reg [63:0] c;
    reg [63:0] d;
    reg [63:0] m0;
    reg [63:0] m1;
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
        .m0(m0),
        .m1(m1),
        .a_prim(a_prim),
        .b_prim(b_prim),
        .c_prim(c_prim),
        .d_prim(d_prim)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All Zeros", test_num);
            a = 64'h0; b = 64'h0; c = 64'h0; d = 64'h0;
            m0 = 64'h0; m1 = 64'h0;
            #1;

            check_outputs(64'h0, 64'h0, 64'h0, 64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Simple Incremental Values", test_num);
            a = 64'h1; b = 64'h2; c = 64'h3; d = 64'h4;
            m0 = 64'h5; m1 = 64'h6;
            #1;

            check_outputs(64'h010000000000001A, 64'h023402180018001E, 64'h001A010C000C0003, 64'h001A0100000C0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: High Bit and Overflow", test_num);
            a = 64'hFFFFFFFFFFFFFFFF;
            b = 64'hFFFFFFFFFFFFFFFF;
            c = 64'hFFFFFFFFFFFFFFFF;
            d = 64'hFFFFFFFFFFFFFFFF;
            m0 = 64'h0;
            m1 = 64'h0;





            #1;






            check_outputs(64'h00000000FFFFFEFE, 64'hFDFC0000000001FE, 64'hFEFE0000FFFFFFFF, 64'hFEFE00000001FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Blake2b Constant Mix", test_num);
            a = 64'h6A09E667F3BCC908;
            b = 64'hBB67AE8584CAA73B;
            c = 64'h3C6EF372FE94F82B;
            d = 64'hA54FF53A5F1D36F1;
            m0 = 64'h0123456789ABCDEF;
            m1 = 64'hFEDCBA9876543210;

            #1;


            check_outputs(64'hCA99361073192348, 64'hA206659FFFF2A2B6, 64'h745593EDC143E25D, 64'hDAB797B63ED3F0C3);
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
