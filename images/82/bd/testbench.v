`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    reg [3:0] opt;
    wire [63:0] ans;
    wire zeroflag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .opt(opt),
        .ans(ans),
        .zeroflag(zeroflag)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise AND", test_num);
        A = 64'hAAAA_AAAA_AAAA_AAAA;
        B = 64'hFFFF_FFFF_0000_0000;
        opt = 4'b0000;
        #1;

        check_outputs(64'hAAAA_AAAA_0000_0000, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise AND (Result Zero)", test_num);
        A = 64'h5555_5555_5555_5555;
        B = 64'hAAAA_AAAA_AAAA_AAAA;
        opt = 4'b0000;
        #1;

        check_outputs(64'h0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise OR", test_num);
        A = 64'h1234_5678_0000_0000;
        B = 64'h0000_0000_8765_4321;
        opt = 4'b0001;
        #1;

        check_outputs(64'h1234_5678_8765_4321, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (Small numbers)", test_num);
        A = 64'd500;
        B = 64'd250;
        opt = 4'b0010;
        #1;

        check_outputs(64'd750, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (Overflow to Zero)", test_num);
        A = 64'hFFFF_FFFF_FFFF_FFFF;
        B = 64'h0000_0000_0000_0001;
        opt = 4'b0010;
        #1;

        check_outputs(64'h0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction", test_num);
        A = 64'd1000;
        B = 64'd300;
        opt = 4'b0011;
        #1;

        check_outputs(64'd700, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (Equality check)", test_num);
        A = 64'hDEAD_BEEF_CAFE_BABE;
        B = 64'hDEAD_BEEF_CAFE_BABE;
        opt = 4'b0011;
        #1;

        check_outputs(64'h0, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pass Value A", test_num);
        A = 64'hFEDC_BA98_7654_3210;
        B = 64'h0;
        opt = 4'b0100;
        #1;

        check_outputs(64'hFEDC_BA98_7654_3210, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise NOR", test_num);
        A = 64'h0000_0000_0000_0000;
        B = 64'h0000_0000_0000_0000;
        opt = 4'b0101;
        #1;

        check_outputs(64'hFFFF_FFFF_FFFF_FFFF, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise NOR (Result Zero)", test_num);
        A = 64'hFFFF_FFFF_FFFF_FFFF;
        B = 64'hFFFF_FFFF_FFFF_FFFF;
        opt = 4'b0101;
        #1;

        check_outputs(64'h0, 1'b1);
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
        input [63:0] expected_ans;
        input expected_zeroflag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ans === (expected_ans ^ ans ^ expected_ans) &&
                expected_zeroflag === (expected_zeroflag ^ zeroflag ^ expected_zeroflag)) begin
                $display("PASS");
                $display("  Outputs: ans=%h, zeroflag=%b",
                         ans, zeroflag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ans=%h, zeroflag=%b",
                         expected_ans, expected_zeroflag);
                $display("  Got:      ans=%h, zeroflag=%b",
                         ans, zeroflag);
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
