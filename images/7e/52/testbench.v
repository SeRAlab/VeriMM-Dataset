`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    reg Cin;
    wire Carry;
    wire [63:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Carry(Carry),
        .Sum(Sum)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All Zeros", test_num);
        A = 64'h0;
        B = 64'h0;
        Cin = 1'b0;
        #1;

        check_outputs(1'b0, 64'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Simple addition without carry", test_num);
        A = 64'h123456789ABCDEF0;
        B = 64'h1111111111111111;
        Cin = 1'b0;
        #1;

        check_outputs(1'b0, 64'h23456789BBBDFF01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Simple addition with Cin only", test_num);
        A = 64'h0;
        B = 64'h0;
        Cin = 1'b1;
        #1;

        check_outputs(1'b0, 64'h1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Max 64-bit result", test_num);
        A = 64'hFFFFFFFFFFFFFFFF;
        B = 64'h0;
        Cin = 1'b0;
        #1;

        check_outputs(1'b0, 64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Carry-out from A+B", test_num);
        A = 64'hFFFFFFFFFFFFFFFF;
        B = 64'h1;
        Cin = 1'b0;
        #1;

        check_outputs(1'b1, 64'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Carry-out from A+Cin", test_num);
        A = 64'hFFFFFFFFFFFFFFFF;
        B = 64'h0;
        Cin = 1'b1;
        #1;

        check_outputs(1'b1, 64'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Maximum sum inputs", test_num);
        A = 64'hFFFFFFFFFFFFFFFF;
        B = 64'hFFFFFFFFFFFFFFFF;
        Cin = 1'b1;

        #1;


        check_outputs(1'b1, 64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Alternating bits pattern", test_num);
        A = 64'hAAAAAAAAAAAAAAAA;
        B = 64'h5555555555555555;
        Cin = 1'b1;

        #1;


        check_outputs(1'b1, 64'h0);
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
        input expected_Carry;
        input [63:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Carry === (expected_Carry ^ Carry ^ expected_Carry) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Carry=%b, Sum=%h",
                         Carry, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Carry=%b, Sum=%h",
                         expected_Carry, expected_Sum);
                $display("  Got:      Carry=%b, Sum=%h",
                         Carry, Sum);
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
