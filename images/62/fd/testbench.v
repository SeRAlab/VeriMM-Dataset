`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg p1a;
    reg p1b;
    reg p1c;
    reg p1d;
    reg p1e;
    reg p1f;
    reg p2a;
    reg p2b;
    reg p2c;
    reg p2d;
    wire p1y;
    wire p2y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .p1a(p1a),
        .p1b(p1b),
        .p1c(p1c),
        .p1d(p1d),
        .p1e(p1e),
        .p1f(p1f),
        .p2a(p2a),
        .p2b(p2b),
        .p2c(p2c),
        .p2d(p2d),
        .p1y(p1y),
        .p2y(p2y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All inputs zero", test_num);
            p1a = 0; p1b = 0; p1c = 0; p1d = 0; p1e = 0; p1f = 0;
            p2a = 0; p2b = 0; p2c = 0; p2d = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: p1 first group active (p1a, p1b, p1c)", test_num);
            p1a = 1; p1b = 1; p1c = 1; p1d = 0; p1e = 0; p1f = 0;
            p2a = 0; p2b = 0; p2c = 0; p2d = 0;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: p1 second group active (p1d, p1e, p1f)", test_num);
            p1a = 0; p1b = 0; p1c = 0; p1d = 1; p1e = 1; p1f = 1;
            p2a = 0; p2b = 0; p2c = 0; p2d = 0;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: p1 partial groups (should be LOW)", test_num);
            p1a = 1; p1b = 1; p1c = 0; p1d = 0; p1e = 1; p1f = 1;
            p2a = 0; p2b = 0; p2c = 0; p2d = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: p2 first group active (p2a, p2b)", test_num);
            p1a = 0; p1b = 0; p1c = 0; p1d = 0; p1e = 0; p1f = 0;
            p2a = 1; p2b = 1; p2c = 0; p2d = 0;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: p2 second group active (p2c, p2d)", test_num);
            p1a = 0; p1b = 0; p1c = 0; p1d = 0; p1e = 0; p1f = 0;
            p2a = 0; p2b = 0; p2c = 1; p2d = 1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: p2 partial groups (should be LOW)", test_num);
            p1a = 0; p1b = 0; p1c = 0; p1d = 0; p1e = 0; p1f = 0;
            p2a = 1; p2b = 0; p2c = 0; p2d = 1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: All outputs active", test_num);
            p1a = 1; p1b = 1; p1c = 1; p1d = 1; p1e = 1; p1f = 1;
            p2a = 1; p2b = 1; p2c = 1; p2d = 1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Mixed signals check", test_num);
            p1a = 1; p1b = 1; p1c = 1; p1d = 0; p1e = 0; p1f = 0;
            p2a = 0; p2b = 0; p2c = 1; p2d = 1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Single bit changes", test_num);
            p1a = 1; p1b = 1; p1c = 0; p1d = 1; p1e = 1; p1f = 1;
            p2a = 1; p2b = 1; p2c = 0; p2d = 0;
            #1;

            check_outputs(1, 1);
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
        input expected_p1y;
        input expected_p2y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_p1y === (expected_p1y ^ p1y ^ expected_p1y) &&
                expected_p2y === (expected_p2y ^ p2y ^ expected_p2y)) begin
                $display("PASS");
                $display("  Outputs: p1y=%b, p2y=%b",
                         p1y, p2y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p1y=%b, p2y=%b",
                         expected_p1y, expected_p2y);
                $display("  Got:      p1y=%b, p2y=%b",
                         p1y, p2y);
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
