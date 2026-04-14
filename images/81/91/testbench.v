`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] hex;
    wire segA;
    wire segB;
    wire segC;
    wire segD;
    wire segE;
    wire segF;
    wire segG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hex(hex),
        .segA(segA),
        .segB(segB),
        .segC(segC),
        .segD(segD),
        .segE(segE),
        .segF(segF),
        .segG(segG)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: hex = 4'h0 (Expected: 1111110)", test_num);
        hex = 4'h0;
        #1;

        check_outputs(1, 1, 1, 1, 1, 1, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: hex = 4'h1 (Expected: 0110000)", test_num);
        hex = 4'h1;
        #1;

        check_outputs(0, 1, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: hex = 4'h2 (Expected: 1101101)", test_num);
        hex = 4'h2;
        #1;

        check_outputs(1, 1, 0, 1, 1, 0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: hex = 4'h3 (Expected: 1111001)", test_num);
        hex = 4'h3;
        #1;

        check_outputs(1, 1, 1, 1, 0, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: hex = 4'h4 (Expected: 0110011)", test_num);
        hex = 4'h4;
        #1;

        check_outputs(0, 1, 1, 0, 0, 1, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: hex = 4'h5 (Expected: 1011011)", test_num);
        hex = 4'h5;
        #1;

        check_outputs(1, 0, 1, 1, 0, 1, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: hex = 4'h6 (Expected: 1011111)", test_num);
        hex = 4'h6;
        #1;

        check_outputs(1, 0, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: hex = 4'h7 (Expected: 1110000)", test_num);
        hex = 4'h7;
        #1;

        check_outputs(1, 1, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTestcase %0d: hex = 4'h8 (Expected: 1111111)", test_num);
        hex = 4'h8;
        #1;

        check_outputs(1, 1, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTestcase %0d: hex = 4'h9 (Expected: 1111011)", test_num);
        hex = 4'h9;
        #1;

        check_outputs(1, 1, 1, 1, 0, 1, 1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("\nTestcase %0d: hex = 4'hA (Expected: 1110111)", test_num);
        hex = 4'hA;
        #1;

        check_outputs(1, 1, 1, 0, 1, 1, 1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("\nTestcase %0d: hex = 4'hB (Expected: 0011111)", test_num);
        hex = 4'hB;
        #1;

        check_outputs(0, 0, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("\nTestcase %0d: hex = 4'hC (Expected: 1001110)", test_num);
        hex = 4'hC;
        #1;

        check_outputs(1, 0, 0, 1, 1, 1, 0);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("\nTestcase %0d: hex = 4'hD (Expected: 0111101)", test_num);
        hex = 4'hD;
        #1;

        check_outputs(0, 1, 1, 1, 1, 0, 1);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        $display("\nTestcase %0d: hex = 4'hE (Expected: 1001111)", test_num);
        hex = 4'hE;
        #1;

        check_outputs(1, 0, 0, 1, 1, 1, 1);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        $display("\nTestcase %0d: hex = 4'hF (Expected: 1000111)", test_num);
        hex = 4'hF;
        #1;

        check_outputs(1, 0, 0, 0, 1, 1, 1);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_segA;
        input expected_segB;
        input expected_segC;
        input expected_segD;
        input expected_segE;
        input expected_segF;
        input expected_segG;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_segA === (expected_segA ^ segA ^ expected_segA) &&
                expected_segB === (expected_segB ^ segB ^ expected_segB) &&
                expected_segC === (expected_segC ^ segC ^ expected_segC) &&
                expected_segD === (expected_segD ^ segD ^ expected_segD) &&
                expected_segE === (expected_segE ^ segE ^ expected_segE) &&
                expected_segF === (expected_segF ^ segF ^ expected_segF) &&
                expected_segG === (expected_segG ^ segG ^ expected_segG)) begin
                $display("PASS");
                $display("  Outputs: segA=%b, segB=%b, segC=%b, segD=%b, segE=%b, segF=%b, segG=%b",
                         segA, segB, segC, segD, segE, segF, segG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: segA=%b, segB=%b, segC=%b, segD=%b, segE=%b, segF=%b, segG=%b",
                         expected_segA, expected_segB, expected_segC, expected_segD, expected_segE, expected_segF, expected_segG);
                $display("  Got:      segA=%b, segB=%b, segC=%b, segD=%b, segE=%b, segF=%b, segG=%b",
                         segA, segB, segC, segD, segE, segF, segG);
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
