`timescale 1ns/1ps

module multi_input_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg d;
    reg e;
    reg f;
    reg g;
    reg h;
    reg i;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multi_input_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .h(h),
        .i(i),
        .out(out)
    );
    task testcase001;

        begin
            $display("Test Case 001: Dominant input i is High");
            a = 0; b = 0; c = 0; d = 0; e = 0; f = 0; g = 0; h = 0; i = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Dominant input h is Low (and i is Low)");
            a = 1; b = 1; c = 1; d = 1; e = 1; f = 1; g = 1; h = 0; i = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Input g is High (with h=1, i=0)");
            a = 0; b = 0; c = 0; d = 0; e = 0; f = 0; g = 1; h = 1; i = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Inputs e and f are Low (resetting the chain before g)");
            a = 1; b = 1; c = 1; d = 1; e = 0; f = 0; g = 0; h = 1; i = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Input c is High (with e=1, h=1, i=0)");
            a = 0; b = 0; c = 1; d = 0; e = 1; f = 0; g = 0; h = 1; i = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Input d is High (with f=1, h=1, i=0)");
            a = 0; b = 0; c = 0; d = 1; e = 0; f = 1; g = 0; h = 1; i = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Inputs a and b are High (with e=1, h=1, i=0)");
            a = 1; b = 1; c = 0; d = 0; e = 1; f = 0; g = 0; h = 1; i = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Only a is High (should result in Low)");
            a = 1; b = 0; c = 0; d = 0; e = 1; f = 1; g = 0; h = 1; i = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: All inputs zero");
            a = 0; b = 0; c = 0; d = 0; e = 0; f = 0; g = 0; h = 0; i = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: Complex Path (a&b High, but e&f Low kills it)");
            a = 1; b = 1; c = 0; d = 0; e = 0; f = 0; g = 0; h = 1; i = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multi_input_module Testbench");
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
