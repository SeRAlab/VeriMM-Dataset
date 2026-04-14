`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg loop_in;
    reg prev;
    reg req;
    wire loop_out;
    wire next;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .loop_in(loop_in),
        .prev(prev),
        .req(req),
        .loop_out(loop_out),
        .next(next)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All inputs zero (IDLE)", test_num);
        prev = 0; req = 0; loop_in = 0;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Pass-through grant (prev=1, req=0)", test_num);
        prev = 1; req = 0; loop_in = 0;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Module consumes grant (prev=1, req=1)", test_num);
        prev = 1; req = 1; loop_in = 0;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Requesting without grant (prev=0, req=1)", test_num);
        prev = 0; req = 1; loop_in = 0;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Upstream request, passing grant (prev=1, req=0, loop_in=1)", test_num);
        prev = 1; req = 0; loop_in = 1;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Upstream request, consume grant (prev=1, req=1, loop_in=1)", test_num);
        prev = 1; req = 1; loop_in = 1;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Upstream request only (prev=0, req=0, loop_in=1)", test_num);
        prev = 0; req = 0; loop_in = 1;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Multiple requests, no grant (prev=0, req=1, loop_in=1)", test_num);
        prev = 0; req = 1; loop_in = 1;
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
        input expected_loop_out;
        input expected_next;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_loop_out === (expected_loop_out ^ loop_out ^ expected_loop_out) &&
                expected_next === (expected_next ^ next ^ expected_next)) begin
                $display("PASS");
                $display("  Outputs: loop_out=%b, next=%b",
                         loop_out, next);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: loop_out=%b, next=%b",
                         expected_loop_out, expected_next);
                $display("  Got:      loop_out=%b, next=%b",
                         loop_out, next);
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
