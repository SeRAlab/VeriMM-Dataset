`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg CE;
    reg CLK;
    reg SCLR;
    wire [7:0] P;
    wire [47:0] PCASC;
    wire [1:0] ZERO_DETECT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CE(CE),
        .CLK(CLK),
        .SCLR(SCLR),
        .P(P),
        .PCASC(PCASC),
        .ZERO_DETECT(ZERO_DETECT)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Synchronous Clear", test_num);
        A = 16'hABCD;
        B = 16'h1234;
        CE = 1;
        SCLR = 1;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(8'h00, 48'h0, 2'b11);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Basic Multiplication (12 * 10)", test_num);

        SCLR = 1;
        @(posedge CLK);
        #1;

        SCLR = 0;
        CE = 1;
        A = 16'd12;
        B = 16'd10;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(8'h78, 48'h78, 2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Zero Detection (Full Zero)", test_num);
        SCLR = 1;
        @(posedge CLK);
        #1;
        SCLR = 0;
        CE = 1;
        A = 16'hFFFF;
        B = 16'h0000;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(8'h00, 48'h0, 2'b11);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Partial Zero Detection (P=0, Result!=0)", test_num);
        SCLR = 1;
        @(posedge CLK);
        #1;
        SCLR = 0;
        CE = 1;
        A = 16'd256;
        B = 16'd2;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(8'h00, 48'h200, 2'b10);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Large Product (65535 * 65535)", test_num);
        SCLR = 1;
        @(posedge CLK);
        #1;
        SCLR = 0;
        CE = 1;
        A = 16'hFFFF;
        B = 16'hFFFF;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(8'h01, 48'h0000FFFE0001, 2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Clock Enable (CE) Logic", test_num);

        SCLR = 1;
        @(posedge CLK);
        #1;
        SCLR = 0; CE = 1; A = 16'd5; B = 16'd4;
        @(posedge CLK);
        #1;


        CE = 0; A = 16'd10; B = 16'd10;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(8'h14, 48'h14, 2'b00);
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
        input [7:0] expected_P;
        input [47:0] expected_PCASC;
        input [1:0] expected_ZERO_DETECT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P) &&
                expected_PCASC === (expected_PCASC ^ PCASC ^ expected_PCASC) &&
                expected_ZERO_DETECT === (expected_ZERO_DETECT ^ ZERO_DETECT ^ expected_ZERO_DETECT)) begin
                $display("PASS");
                $display("  Outputs: P=%h, PCASC=%h, ZERO_DETECT=%h",
                         P, PCASC, ZERO_DETECT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h, PCASC=%h, ZERO_DETECT=%h",
                         expected_P, expected_PCASC, expected_ZERO_DETECT);
                $display("  Got:      P=%h, PCASC=%h, ZERO_DETECT=%h",
                         P, PCASC, ZERO_DETECT);
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
