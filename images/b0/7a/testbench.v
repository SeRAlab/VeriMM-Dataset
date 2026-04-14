`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg d;
    reg pass_high;
    reg sr;
    reg srval;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .pass_high(pass_high),
        .sr(sr),
        .srval(srval),
        .q(q)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test 001: Pass High Mode - Transparency (clk=1, d=1)");

        sr = 1; srval = 0; clk = 1; #5; clk = 0; #5;
        sr = 0; d = 1; clk = 1; pass_high = 1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test 002: Pass High Mode - Data Retention (clk=0, hold)");

        sr = 0; d = 1; clk = 1; pass_high = 1; #10;

        clk = 0; d = 0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test 003: Pass High Mode - SR Override (sr=1, srval=0)");

        sr = 1; srval = 0; d = 1; clk = 1; pass_high = 1;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test 004: Pass Low Mode - Transparency (clk=0, d=1)");

        sr = 1; srval = 0; clk = 1; #5; clk = 0; #5;

        sr = 0; d = 1; clk = 0; pass_high = 0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test 005: Pass Low Mode - Data Retention (clk=1, hold)");

        sr = 0; d = 1; clk = 0; pass_high = 0; #10;

        clk = 1; d = 0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test 006: Pass Low Mode - SR Override (sr=1, srval=0)");

        sr = 1; srval = 0; d = 1; clk = 0; pass_high = 0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test 007: MUX Switching (pass_high toggle)");

        pass_high = 1; clk = 1; d = 1; sr = 0; #10;

        pass_high = 0; clk = 0; d = 0; sr = 0; #10;



        pass_high = 1;
        #10;
        #1;

        check_outputs(1'b1);
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
        input expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
                         q);
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
