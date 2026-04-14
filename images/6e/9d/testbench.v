`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    wire F;
    wire G;
    wire H;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .F(F),
        .G(G),
        .H(H)
    );
    task testcase001;
 begin $display("Running Test 001: 0000"); run_test(4'b0000); end     endtask

    task testcase002;
 begin $display("Running Test 002: 0001"); run_test(4'b0001); end     endtask

    task testcase003;
 begin $display("Running Test 003: 0010"); run_test(4'b0010); end     endtask

    task testcase004;
 begin $display("Running Test 004: 0011"); run_test(4'b0011); end     endtask

    task testcase005;
 begin $display("Running Test 005: 0100"); run_test(4'b0100); end     endtask

    task testcase006;
 begin $display("Running Test 006: 0101"); run_test(4'b0101); end     endtask

    task testcase007;
 begin $display("Running Test 007: 0110"); run_test(4'b0110); end     endtask

    task testcase008;
 begin $display("Running Test 008: 0111"); run_test(4'b0111); end     endtask

    task testcase009;
 begin $display("Running Test 009: 1000"); run_test(4'b1000); end     endtask

    task testcase010;
 begin $display("Running Test 010: 1001"); run_test(4'b1001); end     endtask

    task testcase011;
 begin $display("Running Test 011: 1010"); run_test(4'b1010); end     endtask

    task testcase012;
 begin $display("Running Test 012: 1011"); run_test(4'b1011); end     endtask

    task testcase013;
 begin $display("Running Test 013: 1100"); run_test(4'b1100); end     endtask

    task testcase014;
 begin $display("Running Test 014: 1101"); run_test(4'b1101); end     endtask

    task testcase015;
 begin $display("Running Test 015: 1110"); run_test(4'b1110); end     endtask

    task testcase016;
 begin $display("Running Test 016: 1111"); run_test(4'b1111); end     endtask

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
        input expected_F;
        input expected_G;
        input expected_H;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_F === (expected_F ^ F ^ expected_F) &&
                expected_G === (expected_G ^ G ^ expected_G) &&
                expected_H === (expected_H ^ H ^ expected_H)) begin
                $display("PASS");
                $display("  Outputs: F=%b, G=%b, H=%b",
                         F, G, H);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: F=%b, G=%b, H=%b",
                         expected_F, expected_G, expected_H);
                $display("  Got:      F=%b, G=%b, H=%b",
                         F, G, H);
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
