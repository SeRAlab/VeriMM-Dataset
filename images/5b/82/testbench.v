`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a0;
    reg [31:0] a1;
    reg [31:0] a10;
    reg [31:0] a11;
    reg [31:0] a12;
    reg [31:0] a13;
    reg [31:0] a14;
    reg [31:0] a15;
    reg [31:0] a16;
    reg [31:0] a17;
    reg [31:0] a18;
    reg [31:0] a19;
    reg [31:0] a2;
    reg [31:0] a20;
    reg [31:0] a21;
    reg [31:0] a22;
    reg [31:0] a23;
    reg [31:0] a24;
    reg [31:0] a25;
    reg [31:0] a26;
    reg [31:0] a27;
    reg [31:0] a28;
    reg [31:0] a29;
    reg [31:0] a3;
    reg [31:0] a30;
    reg [31:0] a31;
    reg [31:0] a4;
    reg [31:0] a5;
    reg [31:0] a6;
    reg [31:0] a7;
    reg [31:0] a8;
    reg [31:0] a9;
    reg [4:0] s;
    wire [31:0] r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a0(a0),
        .a1(a1),
        .a10(a10),
        .a11(a11),
        .a12(a12),
        .a13(a13),
        .a14(a14),
        .a15(a15),
        .a16(a16),
        .a17(a17),
        .a18(a18),
        .a19(a19),
        .a2(a2),
        .a20(a20),
        .a21(a21),
        .a22(a22),
        .a23(a23),
        .a24(a24),
        .a25(a25),
        .a26(a26),
        .a27(a27),
        .a28(a28),
        .a29(a29),
        .a3(a3),
        .a30(a30),
        .a31(a31),
        .a4(a4),
        .a5(a5),
        .a6(a6),
        .a7(a7),
        .a8(a8),
        .a9(a9),
        .s(s),
        .r(r)
    );
    task init_inputs;

    begin
        a0  = 32'h00000000; a1  = 32'h11111111; a2  = 32'h22222222; a3  = 32'h33333333;
        a4  = 32'h44444444; a5  = 32'h55555555; a6  = 32'h66666666; a7  = 32'h77777777;
        a8  = 32'h88888888; a9  = 32'h99999999; a10 = 32'hAAAAAAAA; a11 = 32'hBBBBBBBB;
        a12 = 32'hCCCCCCCC; a13 = 32'hDDDDDDDD; a14 = 32'hEEEEEEEE; a15 = 32'hFFFFFFFF;
        a16 = 32'h0000FFFF; a17 = 32'hFFFF0000; a18 = 32'h12345678; a19 = 32'h87654321;
        a20 = 32'hA5A5A5A5; a21 = 32'h5A5A5A5A; a22 = 32'h10101010; a23 = 32'h01010101;
        a24 = 32'hCAFECAFE; a25 = 32'hBEEFBEEF; a26 = 32'hDEADBEEF; a27 = 32'hFEEDFACE;
        a28 = 32'h13579BDF; a29 = 32'h02468ACE; a30 = 32'hF0F0F0F0; a31 = 32'h0F0F0F0F;
    end
        endtask

    task testcase001;

    begin
        test_num = 1;
        init_inputs();
        $display("Test Case %0d: Select a0 (s=0)", test_num);
        s = 5'd0;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        init_inputs();
        $display("Test Case %0d: Select a15 (s=15)", test_num);
        s = 5'd15;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        init_inputs();
        $display("Test Case %0d: Select a31 (s=31)", test_num);
        s = 5'd31;
        #1;

        check_outputs(32'h0F0F0F0F);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        init_inputs();
        $display("Test Case %0d: Select a10 (s=10)", test_num);
        s = 5'd10;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        init_inputs();
        $display("Test Case %0d: Select a26 (s=26)", test_num);
        s = 5'd26;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        init_inputs();
        $display("Test Case %0d: Select a5 and change its value", test_num);
        s = 5'd5;
        a5 = 32'hCAFED00D;
        #1;

        check_outputs(32'hCAFED00D);
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
        input [31:0] expected_r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: r=%h",
                         r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r=%h",
                         expected_r);
                $display("  Got:      r=%h",
                         r);
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
