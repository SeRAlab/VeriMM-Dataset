`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg sel_2to1;
    reg sel_3to1;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .sel_2to1(sel_2to1),
        .sel_3to1(sel_3to1),
        .out(out)
    );
    task testcase001;

    begin
        $display("Test Case 001: sel_3to1=0, sel_2to1=0 -> Selecting 'a' (a=0)");
        test_num = 1;
        a = 1'b0; b = 1'b1; c = 1'b1;
        sel_2to1 = 1'b0; sel_3to1 = 1'b0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: sel_3to1=0, sel_2to1=0 -> Selecting 'a' (a=1)");
        test_num = 2;
        a = 1'b1; b = 1'b0; c = 1'b0;
        sel_2to1 = 1'b0; sel_3to1 = 1'b0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: sel_3to1=0, sel_2to1=1 -> Selecting 'b' (b=0)");
        test_num = 3;
        a = 1'b1; b = 1'b0; c = 1'b1;
        sel_2to1 = 1'b1; sel_3to1 = 1'b0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: sel_3to1=0, sel_2to1=1 -> Selecting 'b' (b=1)");
        test_num = 4;
        a = 1'b0; b = 1'b1; c = 1'b0;
        sel_2to1 = 1'b1; sel_3to1 = 1'b0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: sel_3to1=1 -> Selecting 'c' (c=0)");
        test_num = 5;
        a = 1'b1; b = 1'b1; c = 1'b0;
        sel_2to1 = 1'b0; sel_3to1 = 1'b1;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: sel_3to1=1 -> Selecting 'c' (c=1)");
        test_num = 6;
        a = 1'b0; b = 1'b0; c = 1'b1;
        sel_2to1 = 1'b1; sel_3to1 = 1'b1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: Checking that sel_2to1 and a/b don't affect result when sel_3to1=1 (c=0)");
        test_num = 7;
        a = 1'b1; b = 1'b1; c = 1'b0;
        sel_2to1 = 1'b1; sel_3to1 = 1'b1;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: Checking that 'c' doesn't affect result when sel_3to1=0 (select b=1)");
        test_num = 8;
        a = 1'b0; b = 1'b1; c = 1'b0;
        sel_2to1 = 1'b1; sel_3to1 = 1'b0;
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
