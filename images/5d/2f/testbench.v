`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [16:0] A;
    reg [15:0] B;
    reg CE;
    reg CLK;
    reg SCLR;
    wire [24:0] P;
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
        test_num = test_num + 1;
        $display("\nTestcase %0d: Synchronous Clear (SCLR) Logic", test_num);
        @(posedge CLK);
        SCLR <= 1; CE <= 1; A <= 17'h1FFFF; B <= 16'hFFFF;
        @(posedge CLK);

        #1;


        check_outputs(25'h0, 48'h0, CODE_ZERO);
        SCLR <= 0;
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Basic Multiplication (100 * 25)", test_num);
        @(posedge CLK);
        A <= 17'd100; B <= 16'd25; SCLR <= 0; CE <= 1;
        @(posedge CLK);

        #1;


        check_outputs(25'h9C4, 48'h9C4, CODE_NOT_ZERO);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Zero Multiplier (A * 0)", test_num);
        @(posedge CLK);
        A <= 17'hABCDE; B <= 16'h0; SCLR <= 0; CE <= 1;
        @(posedge CLK);
        #1;

        check_outputs(25'h0, 48'h0, CODE_ZERO);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Clock Enable (CE) functionality", test_num);

        @(posedge CLK);
        A <= 17'd10; B <= 16'd10; CE <= 1;
        @(posedge CLK);
        #1;


        @(posedge CLK);
        CE <= 0; A <= 17'd50; B <= 16'd50;
        @(posedge CLK);

        #1;


        check_outputs(25'd100, 48'd100, CODE_NOT_ZERO);


        @(posedge CLK);
        CE <= 1;
        @(posedge CLK);

        #1;


        check_outputs(25'd2500, 48'd2500, CODE_NOT_ZERO);
    end
        endtask

    task testcase005;

    reg [32:0] full_prod;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Large Multiplication and Truncation", test_num);
        @(posedge CLK);
        A <= 17'h1FFFF;
        B <= 16'hFFFF;
        CE <= 1; SCLR <= 0;
        @(posedge CLK);


        #1;



        check_outputs(25'h1FF0001, 48'h1FF0001, CODE_NOT_ZERO);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Product zero via 25-bit truncation", test_num);
        @(posedge CLK);


        A <= 17'h10000;
        B <= 16'h0200;

        CE <= 1; SCLR <= 0;
        @(posedge CLK);
        #1;

        check_outputs(25'h0, 48'h0, CODE_ZERO);
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
        input [24:0] expected_P;
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
