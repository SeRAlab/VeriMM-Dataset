`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [31:0] iTDATA;
    reg [3:0] iTKEEP;
    reg iTLAST;
    reg iTREADY;
    reg iTUSER;
    reg iTVALID;
    reg rst;
    wire [31:0] oTDATA;
    wire [3:0] oTKEEP;
    wire oTLAST;
    wire oTREADY;
    wire oTUSER;
    wire oTVALID;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .iTDATA(iTDATA),
        .iTKEEP(iTKEEP),
        .iTLAST(iTLAST),
        .iTREADY(iTREADY),
        .iTUSER(iTUSER),
        .iTVALID(iTVALID),
        .rst(rst),
        .oTDATA(oTDATA),
        .oTKEEP(oTKEEP),
        .oTLAST(oTLAST),
        .oTREADY(oTREADY),
        .oTUSER(oTUSER),
        .oTVALID(oTVALID)
    );
    task testcase001;

    begin
        $display("Test Case 001: Basic Replacement (0x00000000 -> 0x000f003)");
        test_num = test_num + 1;

        rst = 1;
        iTDATA = 0; iTUSER = 0; iTKEEP = 0; iTVALID = 0; iTLAST = 0; iTREADY = 0;
        #20;
        rst = 0;
        @(posedge clk);


        iTDATA = 32'h00000000;
        iTKEEP = 4'hF;
        iTLAST = 1'b0;
        iTUSER = 1'b0;
        iTVALID = 1'b1;
        iTREADY = 1'b1;


        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h000f003, 4'hF, 1'b0, 1'b1, 1'b0, 1'b1);
    end
    endtask

    task testcase002;

    begin
        $display("Test Case 002: Pass-through (Non-zero data)");
        test_num = test_num + 1;
        rst = 1;
        #20;
        rst = 0;
        @(posedge clk);

        iTDATA = 32'hABCDEF12;
        iTKEEP = 4'hF;
        iTLAST = 1'b1;
        iTUSER = 1'b1;
        iTVALID = 1'b1;
        iTREADY = 1'b1;

        @(posedge clk);
        #1;

        #1;


        check_outputs(32'hABCDEF12, 4'hF, 1'b1, 1'b1, 1'b1, 1'b1);
    end
    endtask

    task testcase003;

    begin
        $display("Test Case 003: Handshake Propagation (iTREADY=0)");
        test_num = test_num + 1;
        rst = 1;
        #20;
        rst = 0;
        @(posedge clk);

        iTDATA = 32'h00000000;
        iTKEEP = 4'hE;
        iTLAST = 1'b0;
        iTUSER = 1'b0;
        iTVALID = 1'b1;
        iTREADY = 1'b0;

        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h000f003, 4'hE, 1'b0, 1'b0, 1'b0, 1'b1);
    end
    endtask

    task testcase004;

    begin
        $display("Test Case 004: Byte Keep and User Flag propagation");
        test_num = test_num + 1;
        rst = 1;
        #20;
        rst = 0;
        @(posedge clk);

        iTDATA = 32'h5555AAAA;
        iTKEEP = 4'b1010;
        iTLAST = 1'b1;
        iTUSER = 1'b1;
        iTVALID = 1'b1;
        iTREADY = 1'b1;

        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h5555AAAA, 4'b1010, 1'b1, 1'b1, 1'b1, 1'b1);
    end
    endtask

    task testcase005;

    begin
        $display("Test Case 005: Validity Signal propagation (iTVALID=0)");
        test_num = test_num + 1;
        rst = 1;
        #20;
        rst = 0;
        @(posedge clk);

        iTDATA = 32'h00000000;
        iTKEEP = 4'hF;
        iTLAST = 1'b0;
        iTUSER = 1'b0;
        iTVALID = 1'b0;
        iTREADY = 1'b1;

        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h000f003, 4'hF, 1'b0, 1'b1, 1'b0, 1'b0);
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
        input [31:0] expected_oTDATA;
        input [3:0] expected_oTKEEP;
        input expected_oTLAST;
        input expected_oTREADY;
        input expected_oTUSER;
        input expected_oTVALID;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oTDATA === (expected_oTDATA ^ oTDATA ^ expected_oTDATA) &&
                expected_oTKEEP === (expected_oTKEEP ^ oTKEEP ^ expected_oTKEEP) &&
                expected_oTLAST === (expected_oTLAST ^ oTLAST ^ expected_oTLAST) &&
                expected_oTREADY === (expected_oTREADY ^ oTREADY ^ expected_oTREADY) &&
                expected_oTUSER === (expected_oTUSER ^ oTUSER ^ expected_oTUSER) &&
                expected_oTVALID === (expected_oTVALID ^ oTVALID ^ expected_oTVALID)) begin
                $display("PASS");
                $display("  Outputs: oTDATA=%h, oTKEEP=%h, oTLAST=%b, oTREADY=%b, oTUSER=%b, oTVALID=%b",
                         oTDATA, oTKEEP, oTLAST, oTREADY, oTUSER, oTVALID);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oTDATA=%h, oTKEEP=%h, oTLAST=%b, oTREADY=%b, oTUSER=%b, oTVALID=%b",
                         expected_oTDATA, expected_oTKEEP, expected_oTLAST, expected_oTREADY, expected_oTUSER, expected_oTVALID);
                $display("  Got:      oTDATA=%h, oTKEEP=%h, oTLAST=%b, oTREADY=%b, oTUSER=%b, oTVALID=%b",
                         oTDATA, oTKEEP, oTLAST, oTREADY, oTUSER, oTVALID);
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
