`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg CIN;
    wire COUT;
    wire [15:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CIN(CIN),
        .COUT(COUT),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Zero Addition", test_num);
        A = 16'h0000;
        B = 16'h0000;
        CIN = 1'b0;
        #1;

        check_outputs(1'b0, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Simple Addition No Carry", test_num);
        A = 16'h1234;
        B = 16'h1111;
        CIN = 1'b0;
        #1;

        check_outputs(1'b0, 16'h2345);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Addition with CIN", test_num);
        A = 16'h0005;
        B = 16'h000A;
        CIN = 1'b1;
        #1;

        check_outputs(1'b0, 16'h0010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Max SUM without COUT", test_num);
        A = 16'hFFFE;
        B = 16'h0001;
        CIN = 1'b0;
        #1;

        check_outputs(1'b0, 16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: CIN causing COUT", test_num);
        A = 16'hFFFF;
        B = 16'h0000;
        CIN = 1'b1;
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Carry Out Generation", test_num);
        A = 16'h8000;
        B = 16'h8000;
        CIN = 1'b0;
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Alternating Bits", test_num);
        A = 16'hAAAA;
        B = 16'h5555;
        CIN = 1'b0;
        #1;

        check_outputs(1'b0, 16'hFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Alternating Bits with CIN", test_num);
        A = 16'hAAAA;
        B = 16'h5555;
        CIN = 1'b1;
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Maximum Addition (All ones)", test_num);
        A = 16'hFFFF;
        B = 16'hFFFF;
        CIN = 1'b1;
        #1;

        check_outputs(1'b1, 16'hFFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Random Pattern", test_num);
        A = 16'hA5A5;
        B = 16'h5A5A;
        CIN = 1'b0;
        #1;

        check_outputs(1'b0, 16'hFFFF);
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
        input expected_COUT;
        input [15:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, SUM=%h",
                         COUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, SUM=%h",
                         expected_COUT, expected_SUM);
                $display("  Got:      COUT=%b, SUM=%h",
                         COUT, SUM);
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
