`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [31:0] nonce;
    wire [31:0] true_nonce;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .nonce(nonce),
        .true_nonce(true_nonce)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Input 0x00000000");
        nonce = 32'h0; @(posedge clk);
        nonce = 32'h00000000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hFFFFFF40);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Input 0xFFFFFFFF");
        nonce = 32'h0; @(posedge clk);
        nonce = 32'hFFFFFFFF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hFFFFFF3F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Input 0x80000000 (MSB)");
        nonce = 32'h0; @(posedge clk);
        nonce = 32'h80000000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hFFFFFF41);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Input 0x00000001 (LSB)");
        nonce = 32'h0; @(posedge clk);
        nonce = 32'h00000001;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h7FFFFF40);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Input 0x000000C0");
        nonce = 32'h0; @(posedge clk);
        nonce = 32'h000000C0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h02FFFF40);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Input 0x12345678");
        nonce = 32'h0; @(posedge clk);
        nonce = 32'h12345678;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h1E6A2B88);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Input 0xA5A5A5A5");
        nonce = 32'h0; @(posedge clk);
        nonce = 32'hA5A5A5A5;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hA5A5A4E5);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: Input 0xDEADBEEF");
        nonce = 32'h0; @(posedge clk);
        nonce = 32'hDEADBEEF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hF77DB4BB);
    end
        endtask

    task testcases1;

    begin
        testcase001();
        testcase002();
        testcase003();
        testcase004();
    end
        endtask

    task testcases2;

    begin
        testcase005();
        testcase006();
        testcase007();
        testcase008();
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
        testcases1();
        testcases2();
        
        
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
        input [31:0] expected_true_nonce;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_true_nonce === (expected_true_nonce ^ true_nonce ^ expected_true_nonce)) begin
                $display("PASS");
                $display("  Outputs: true_nonce=%h",
                         true_nonce);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: true_nonce=%h",
                         expected_true_nonce);
                $display("  Got:      true_nonce=%h",
                         true_nonce);
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
