`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg d;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .y(y)
    );
    task testcase001;

        begin
            $display("Testcase 001: All inputs LOW (a=0, b=0, c=0, d=0)");
            a = 0; b = 0; c = 0; d = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Input 'a' HIGH (a=1, b=0, c=0, d=0)");
            a = 1; b = 0; c = 0; d = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Input 'b' HIGH (a=0, b=1, c=0, d=0)");
            a = 0; b = 1; c = 0; d = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Input 'c' HIGH (a=0, b=0, c=1, d=0)");
            a = 0; b = 0; c = 1; d = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Input 'd' HIGH (a=0, b=0, c=0, d=1)");
            a = 0; b = 0; c = 0; d = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: All inputs HIGH (a=1, b=1, c=1, d=1)");
            a = 1; b = 1; c = 1; d = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Multiple inputs HIGH (a=1, b=0, c=1, d=0)");
            a = 1; b = 0; c = 1; d = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Multiple inputs HIGH (a=0, b=1, c=1, d=1)");
            a = 0; b = 1; c = 1; d = 1;
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
        input expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
                         y);
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
