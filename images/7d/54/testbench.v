`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] c;
    wire [7:0] d;
    wire [7:0] e;
    wire [7:0] f;
    wire [7:0] g;
    wire [7:0] h;
    wire [7:0] i;
    wire [7:0] j;
    wire [7:0] k;

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
        .f(f),
        .g(g),
        .h(h),
        .i(i),
        .j(j),
        .k(k)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=0xAA, b=0x55", test_num);
            a = 8'hAA;
            b = 8'h55;









            #1;










            check_outputs(8'h00, 8'hFF, 8'hFF, 8'h55, 8'hA5, 8'h15, 8'h00, 8'hAA, 8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=0xF0, b=0x0F", test_num);
            a = 8'hF0;
            b = 8'h0F;









            #1;










            check_outputs(8'h00, 8'hFF, 8'hFF, 8'h0F, 8'h0F, 8'h1E, 8'h00, 8'hF0, 8'hE1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=0xFF, b=0xFF", test_num);
            a = 8'hFF;
            b = 8'hFF;









            #1;










            check_outputs(8'hFF, 8'hFF, 8'h00, 8'h00, 8'hFF, 8'h1F, 8'h01, 8'hFF, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=0x00, b=0x00", test_num);
            a = 8'h00;
            b = 8'h00;









            #1;










            check_outputs(8'h00, 8'h00, 8'h00, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=0x12, b=0x34", test_num);
            a = 8'h12;
            b = 8'h34;









            #1;










            check_outputs(8'h10, 8'h36, 8'h26, 8'hED, 8'h24, 8'h02, 8'h00, 8'h34, 8'hDE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=0x81, b=0xFE", test_num);
            a = 8'h81;
            b = 8'hFE;









            #1;










            check_outputs(8'h80, 8'hFF, 8'h7F, 8'h7E, 8'h1E, 8'h10, 8'h00, 8'hFE, 8'h83);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=0x07, b=0xFF", test_num);
            a = 8'h07;
            b = 8'hFF;









            #1;










            check_outputs(8'h07, 8'hFF, 8'hF8, 8'hF8, 8'h7F, 8'h00, 8'h01, 8'hFF, 8'h08);
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
        input [7:0] expected_c;
        input [7:0] expected_d;
        input [7:0] expected_e;
        input [7:0] expected_f;
        input [7:0] expected_g;
        input [7:0] expected_h;
        input [7:0] expected_i;
        input [7:0] expected_j;
        input [7:0] expected_k;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c) &&
                expected_d === (expected_d ^ d ^ expected_d) &&
                expected_e === (expected_e ^ e ^ expected_e) &&
                expected_f === (expected_f ^ f ^ expected_f) &&
                expected_g === (expected_g ^ g ^ expected_g) &&
                expected_h === (expected_h ^ h ^ expected_h) &&
                expected_i === (expected_i ^ i ^ expected_i) &&
                expected_j === (expected_j ^ j ^ expected_j) &&
                expected_k === (expected_k ^ k ^ expected_k)) begin
                $display("PASS");
                $display("  Outputs: c=%h, d=%h, e=%h, f=%h, g=%h, h=%h, i=%h, j=%h, k=%h",
                         c, d, e, f, g, h, i, j, k);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h, d=%h, e=%h, f=%h, g=%h, h=%h, i=%h, j=%h, k=%h",
                         expected_c, expected_d, expected_e, expected_f, expected_g, expected_h, expected_i, expected_j, expected_k);
                $display("  Got:      c=%h, d=%h, e=%h, f=%h, g=%h, h=%h, i=%h, j=%h, k=%h",
                         c, d, e, f, g, h, i, j, k);
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
