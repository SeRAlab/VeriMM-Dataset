`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [63:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c)
    );
    task testcase001;

    begin
        a = 32'sd12; b = 32'sd10;
        $display("Test 001: Positive x Positive (12 * 10)");
        #1;

        check_outputs(64'sd120);
    end
        endtask

    task testcase002;

    begin
        a = 32'sd15; b = -32'sd4;
        $display("Test 002: Positive x Negative (15 * -4)");
        #1;

        check_outputs(-64'sd60);
    end
        endtask

    task testcase003;

    begin
        a = -32'sd20; b = 32'sd5;
        $display("Test 003: Negative x Positive (-20 * 5)");
        #1;

        check_outputs(-64'sd100);
    end
        endtask

    task testcase004;

    begin
        a = -32'sd7; b = -32'sd8;
        $display("Test 004: Negative x Negative (-7 * -8)");
        #1;

        check_outputs(64'sd56);
    end
        endtask

    task testcase005;

    begin
        a = 32'sd0; b = 32'sd12345;
        $display("Test 005: Multiplication by Zero (0 * 12345)");
        #1;

        check_outputs(64'sd0);
    end
        endtask

    task testcase006;

    begin
        a = 32'sd1; b = -32'sd999;
        $display("Test 006: Identity Multiplication (1 * -999)");
        #1;

        check_outputs(-64'sd999);
    end
        endtask

    task testcase007;

    begin
        a = 32'h7FFFFFFF; b = 32'sd2;
        $display("Test 007: Max Positive x 2 (0x7FFFFFFF * 2)");
        #1;

        check_outputs(64'h00000000FFFFFFFE);
    end
        endtask

    task testcase008;

    begin
        a = 32'h80000000; b = 32'sd1;
        $display("Test 008: Min Negative x 1 (0x80000000 * 1)");
        #1;

        check_outputs(64'hFFFFFFFF80000000);
    end
        endtask

    task testcase009;

    begin
        a = 32'h80000000; b = -32'sd1;
        $display("Test 009: Min Negative x -1 (0x80000000 * -1)");
        #1;

        check_outputs(64'h0000000080000000);
    end
        endtask

    task testcase010;

    begin
        a = 32'sd65536; b = 32'sd65536;
        $display("Test 010: Large Product (2^16 * 2^16)");
        #1;

        check_outputs(64'h0000000100000000);
    end
        endtask

    task testcase011;

    begin
        a = 32'h7FFFFFFF; b = 32'h7FFFFFFF;
        $display("Test 011: Max Positive x Max Positive");
        #1;

        check_outputs(64'h3FFFFFFF00000001);
    end
        endtask

    task testcase012;

    begin
        a = 32'h80000000; b = 32'h80000000;
        $display("Test 012: Min Negative x Min Negative");
        #1;

        check_outputs(64'h4000000000000000);
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
        input [63:0] expected_c;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: c=%h",
                         c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h",
                         expected_c);
                $display("  Got:      c=%h",
                         c);
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
