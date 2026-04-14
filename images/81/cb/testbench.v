`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iClock;
    reg [31:0] iInstruction;
    reg iReset;
    wire [31:0] oA;
    wire [31:0] oB;
    wire [31:0] oIP;
    wire oJump;
    wire [31:0] oNextIP;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iClock(iClock),
        .iInstruction(iInstruction),
        .iReset(iReset),
        .oA(oA),
        .oB(oB),
        .oIP(oIP),
        .oJump(oJump),
        .oNextIP(oNextIP)
    );

    // Clock generation (10ns period)
    initial begin
        iClock = 0;
        forever #5 iClock = ~iClock;
    end

        task reset_dut;

        begin
            iReset = 1;
            iInstruction = 0;
            @(posedge iClock);
            #1;
            iReset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Test Case 001: Reset");
            reset_dut();
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 1'b0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Test Case 002: B - A > 0 (No Jump)");
            reset_dut();

            iInstruction = {8'd5, 8'd10, 16'h0080};
            @(posedge iClock);
            #1;

            #1;


            check_outputs(32'd5, 32'd10, 32'd4, 1'b0, 32'd8);
        end
        endtask

    task testcase003;

        begin
            $display("Running Test Case 003: B - A < 0 (Jump)");
            reset_dut();

            iInstruction = {8'd10, 8'd5, 16'h0100};
            @(posedge iClock);
            #1;

            #1;


            check_outputs(32'd10, 32'd5, 32'h0100, 1'b1, 32'h0100);
        end
        endtask

    task testcase004;

        begin
            $display("Running Test Case 004: B - A = 0 (Jump)");
            reset_dut();

            iInstruction = {8'd7, 8'd7, 16'h0200};
            @(posedge iClock);
            #1;

            #1;


            check_outputs(32'd7, 32'd7, 32'h0200, 1'b1, 32'h0200);
        end
        endtask

    task testcase005;

        begin
            $display("Running Test Case 005: Large Target Check");
            reset_dut();

            iInstruction = {8'd1, 8'd0, 16'hFFFF};
            @(posedge iClock);
            #1;

            #1;


            check_outputs(32'd1, 32'd0, 32'hFFFF, 1'b1, 32'hFFFF);
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
        input [31:0] expected_oA;
        input [31:0] expected_oB;
        input [31:0] expected_oIP;
        input expected_oJump;
        input [31:0] expected_oNextIP;
        begin
            if (expected_oA === (expected_oA ^ oA ^ expected_oA) &&
                expected_oB === (expected_oB ^ oB ^ expected_oB) &&
                expected_oIP === (expected_oIP ^ oIP ^ expected_oIP) &&
                expected_oJump === (expected_oJump ^ oJump ^ expected_oJump) &&
                expected_oNextIP === (expected_oNextIP ^ oNextIP ^ expected_oNextIP)) begin
                $display("PASS");
                $display("  Outputs: oA=%h, oB=%h, oIP=%h, oJump=%b, oNextIP=%h",
                         oA, oB, oIP, oJump, oNextIP);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oA=%h, oB=%h, oIP=%h, oJump=%b, oNextIP=%h",
                         expected_oA, expected_oB, expected_oIP, expected_oJump, expected_oNextIP);
                $display("  Got:      oA=%h, oB=%h, oIP=%h, oJump=%b, oNextIP=%h",
                         oA, oB, oIP, oJump, oNextIP);
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
        $dumpvars(0,iClock, iInstruction, iReset, oA, oB, oIP, oJump, oNextIP);
    end

endmodule
