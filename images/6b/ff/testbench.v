`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg x;
    reg y;
    reg z;
    wire p;
    wire q;
    wire r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .z(z),
        .p(p),
        .q(q),
        .r(r)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: x=0, y=0, z=0 -> Expected: p=0, q=0, r=0");
            x = 1'b0; y = 1'b0; z = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: x=0, y=0, z=1 -> Expected: p=0, q=0, r=1");
            x = 1'b0; y = 1'b0; z = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: x=0, y=1, z=0 -> Expected: p=0, q=1, r=0");
            x = 1'b0; y = 1'b1; z = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: x=0, y=1, z=1 -> Expected: p=0, q=1, r=1");
            x = 1'b0; y = 1'b1; z = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: x=1, y=0, z=0 -> Expected: p=1, q=0, r=0");
            x = 1'b1; y = 1'b0; z = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: x=1, y=0, z=1 -> Expected: p=1, q=1, r=0");
            x = 1'b1; y = 1'b0; z = 1'b1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: x=1, y=1, z=0 -> Expected: p=1, q=0, r=1");
            x = 1'b1; y = 1'b1; z = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case 008: x=1, y=1, z=1 -> Expected: p=1, q=1, r=1");
            x = 1'b1; y = 1'b1; z = 1'b1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
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
        input expected_p;
        input expected_q;
        input expected_r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_p === (expected_p ^ p ^ expected_p) &&
                expected_q === (expected_q ^ q ^ expected_q) &&
                expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: p=%b, q=%b, r=%b",
                         p, q, r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%b, q=%b, r=%b",
                         expected_p, expected_q, expected_r);
                $display("  Got:      p=%b, q=%b, r=%b",
                         p, q, r);
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
