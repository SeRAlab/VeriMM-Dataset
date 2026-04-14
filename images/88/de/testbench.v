`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg r;
    reg s;
    wire p;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .r(r),
        .s(s),
        .p(p),
        .q(q)
    );
    task testcase001;

        begin
            $display("Running testcase001: Reset logic...");
            test_num = 1;

            s = 0; r = 1;
            #10;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Set logic...");
            test_num = 2;

            s = 0; r = 1;
            #10;

            s = 1; r = 0;
            #10;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Hold logic after Set...");
            test_num = 3;

            s = 0; r = 1;
            #10;

            s = 1; r = 0;
            #10;

            s = 0; r = 0;
            #10;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Hold logic after Reset...");
            test_num = 4;

            s = 0; r = 1;
            #10;

            s = 0; r = 0;
            #10;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: State Toggle...");
            test_num = 5;

            s = 0; r = 1;
            #10;

            s = 1; r = 0;
            #10;

            s = 0; r = 1;
            #10;
            #1;

            check_outputs(1, 0);
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
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_p === (expected_p ^ p ^ expected_p) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: p=%b, q=%b",
                         p, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%b, q=%b",
                         expected_p, expected_q);
                $display("  Got:      p=%b, q=%b",
                         p, q);
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
