`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in_Dato1;
    reg [31:0] in_Dato2;
    reg [4:0] in_EX;
    reg [31:0] in_Extend;
    reg [2:0] in_M;
    reg [1:0] in_WB;
    reg [31:0] in_add;
    reg [4:0] in_b15_11;
    reg [4:0] in_b20_16;
    wire [31:0] ou_Dato_1;
    wire [31:0] ou_Dato_2;
    wire [4:0] ou_EX;
    wire [31:0] ou_Extend;
    wire [2:0] ou_M;
    wire [1:0] ou_WB;
    wire [31:0] ou_add;
    wire [4:0] ou_b15_11;
    wire [4:0] ou_b20_16;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_Dato1(in_Dato1),
        .in_Dato2(in_Dato2),
        .in_EX(in_EX),
        .in_Extend(in_Extend),
        .in_M(in_M),
        .in_WB(in_WB),
        .in_add(in_add),
        .in_b15_11(in_b15_11),
        .in_b20_16(in_b20_16),
        .ou_Dato_1(ou_Dato_1),
        .ou_Dato_2(ou_Dato_2),
        .ou_EX(ou_EX),
        .ou_Extend(ou_Extend),
        .ou_M(ou_M),
        .ou_WB(ou_WB),
        .ou_add(ou_add),
        .ou_b15_11(ou_b15_11),
        .ou_b20_16(ou_b20_16)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            in_EX = 0;
            in_M = 0;
            in_WB = 0;
            in_add = 0;
            in_Dato1 = 0;
            in_Dato2 = 0;
            in_Extend = 0;
            in_b20_16 = 0;
            in_b15_11 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            reset_dut();

            in_EX = 5'h00;
            in_M  = 3'h0;
            in_WB = 2'h0;
            in_add = 32'h0000_0000;
            in_Dato1 = 32'h0000_0000;
            in_Dato2 = 32'h0000_0000;
            in_Extend = 32'h0000_0000;
            in_b20_16 = 5'h00;
            in_b15_11 = 5'h00;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0, 32'h0, 5'h0, 32'h0, 3'h0, 2'h0, 32'h0, 5'h0, 5'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Typical CPU Values", test_num);
            reset_dut();

            in_EX = 5'h1F;
            in_M  = 3'h7;
            in_WB = 2'h3;
            in_add = 32'h0000_0400;
            in_Dato1 = 32'hDEAD_BEEF;
            in_Dato2 = 32'hCAFE_BABE;
            in_Extend = 32'h0000_FFFF;
            in_b20_16 = 5'h10;
            in_b15_11 = 5'h05;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hDEAD_BEEF, 32'hCAFE_BABE, 5'h1F, 32'h0000_FFFF, 3'h7, 2'h3, 32'h0000_0400, 5'h05, 5'h10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Pattern", test_num);
            reset_dut();

            in_EX = 5'h1F;
            in_M  = 3'h7;
            in_WB = 2'h3;
            in_add = 32'hFFFF_FFFF;
            in_Dato1 = 32'hFFFF_FFFF;
            in_Dato2 = 32'hFFFF_FFFF;
            in_Extend = 32'hFFFF_FFFF;
            in_b20_16 = 5'h1F;
            in_b15_11 = 5'h1F;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFF_FFFF, 32'hFFFF_FFFF, 5'h1F, 32'hFFFF_FFFF, 3'h7, 2'h3, 32'hFFFF_FFFF, 5'h1F, 5'h1F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits", test_num);
            reset_dut();

            in_EX = 5'b10101;
            in_M  = 3'b101;
            in_WB = 2'b10;
            in_add = 32'hAAAA_AAAA;
            in_Dato1 = 32'h5555_5555;
            in_Dato2 = 32'hAAAA_AAAA;
            in_Extend = 32'h5555_5555;
            in_b20_16 = 5'b01010;
            in_b15_11 = 5'b10101;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h5555_5555, 32'hAAAA_AAAA, 5'b10101, 32'h5555_5555, 3'b101, 2'b10, 32'hAAAA_AAAA, 5'b10101, 5'b01010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Integrity Walk", test_num);
            reset_dut();

            in_EX = 5'h01;
            in_M  = 3'h2;
            in_WB = 2'h1;
            in_add = 32'h1234_5678;
            in_Dato1 = 32'h8765_4321;
            in_Dato2 = 32'hF0F0_F0F0;
            in_Extend = 32'h0F0F_0F0F;
            in_b20_16 = 5'h1A;
            in_b15_11 = 5'h0B;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h8765_4321, 32'hF0F0_F0F0, 5'h01, 32'h0F0F_0F0F, 3'h2, 2'h1, 32'h1234_5678, 5'h0B, 5'h1A);
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
        input [31:0] expected_ou_Dato_1;
        input [31:0] expected_ou_Dato_2;
        input [4:0] expected_ou_EX;
        input [31:0] expected_ou_Extend;
        input [2:0] expected_ou_M;
        input [1:0] expected_ou_WB;
        input [31:0] expected_ou_add;
        input [4:0] expected_ou_b15_11;
        input [4:0] expected_ou_b20_16;
        begin
            if (expected_ou_Dato_1 === (expected_ou_Dato_1 ^ ou_Dato_1 ^ expected_ou_Dato_1) &&
                expected_ou_Dato_2 === (expected_ou_Dato_2 ^ ou_Dato_2 ^ expected_ou_Dato_2) &&
                expected_ou_EX === (expected_ou_EX ^ ou_EX ^ expected_ou_EX) &&
                expected_ou_Extend === (expected_ou_Extend ^ ou_Extend ^ expected_ou_Extend) &&
                expected_ou_M === (expected_ou_M ^ ou_M ^ expected_ou_M) &&
                expected_ou_WB === (expected_ou_WB ^ ou_WB ^ expected_ou_WB) &&
                expected_ou_add === (expected_ou_add ^ ou_add ^ expected_ou_add) &&
                expected_ou_b15_11 === (expected_ou_b15_11 ^ ou_b15_11 ^ expected_ou_b15_11) &&
                expected_ou_b20_16 === (expected_ou_b20_16 ^ ou_b20_16 ^ expected_ou_b20_16)) begin
                $display("PASS");
                $display("  Outputs: ou_Dato_1=%h, ou_Dato_2=%h, ou_EX=%h, ou_Extend=%h, ou_M=%h, ou_WB=%h, ou_add=%h, ou_b15_11=%h, ou_b20_16=%h",
                         ou_Dato_1, ou_Dato_2, ou_EX, ou_Extend, ou_M, ou_WB, ou_add, ou_b15_11, ou_b20_16);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ou_Dato_1=%h, ou_Dato_2=%h, ou_EX=%h, ou_Extend=%h, ou_M=%h, ou_WB=%h, ou_add=%h, ou_b15_11=%h, ou_b20_16=%h",
                         expected_ou_Dato_1, expected_ou_Dato_2, expected_ou_EX, expected_ou_Extend, expected_ou_M, expected_ou_WB, expected_ou_add, expected_ou_b15_11, expected_ou_b20_16);
                $display("  Got:      ou_Dato_1=%h, ou_Dato_2=%h, ou_EX=%h, ou_Extend=%h, ou_M=%h, ou_WB=%h, ou_add=%h, ou_b15_11=%h, ou_b20_16=%h",
                         ou_Dato_1, ou_Dato_2, ou_EX, ou_Extend, ou_M, ou_WB, ou_add, ou_b15_11, ou_b20_16);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, in_Dato1, in_Dato2, in_EX, in_Extend, in_M, in_WB, in_add, in_b15_11, in_b20_16, ou_Dato_1, ou_Dato_2, ou_EX, ou_Extend, ou_M, ou_WB, ou_add, ou_b15_11, ou_b20_16);
    end

endmodule
