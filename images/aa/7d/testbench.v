`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a0;
    reg a1;
    reg a2;
    reg a3;
    reg b0;
    reg b1;
    reg b2;
    reg b3;
    reg c0;
    reg c1;
    reg c2;
    reg c3;
    reg d0;
    reg d1;
    reg d2;
    reg d3;
    reg s0;
    reg s1;
    wire y0;
    wire y1;
    wire y2;
    wire y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a0(a0),
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .b0(b0),
        .b1(b1),
        .b2(b2),
        .b3(b3),
        .c0(c0),
        .c1(c1),
        .c2(c2),
        .c3(c3),
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .s0(s0),
        .s1(s1),
        .y0(y0),
        .y1(y1),
        .y2(y2),
        .y3(y3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select A (s1=0, s0=0)", test_num);

            a0=1; a1=0; a2=1; a3=0;
            b0=0; b1=0; b2=0; b3=0;
            c0=0; c1=0; c2=0; c3=0;
            d0=0; d1=0; d2=0; d3=0;
            s1=0; s0=0;
            #1;

            check_outputs(1, 0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select B (s1=0, s0=1)", test_num);

            a0=1; a1=0; a2=1; a3=0;
            b0=1; b1=1; b2=0; b3=0;
            c0=1; c1=0; c2=1; c3=0;
            d0=1; d1=0; d2=1; d3=0;
            s1=0; s0=1;
            #1;

            check_outputs(1, 1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select C (s1=1, s0=0)", test_num);

            a0=1; a1=1; a2=1; a3=1;
            b0=1; b1=1; b2=1; b3=1;
            c0=0; c1=1; c2=0; c3=1;
            d0=1; d1=1; d2=1; d3=1;
            s1=1; s0=0;
            #1;

            check_outputs(0, 1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select D (s1=1, s0=1)", test_num);

            a0=0; a1=0; a2=0; a3=0;
            b0=0; b1=0; b2=0; b3=0;
            c0=0; c1=0; c2=0; c3=0;
            d0=0; d1=0; d2=1; d3=1;
            s1=1; s0=1;
            #1;

            check_outputs(0, 0, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify isolation (Select A, modify B)", test_num);

            a0=1; a1=1; a2=1; a3=1;
            b0=0; b1=0; b2=0; b3=0;
            c0=0; c1=0; c2=0; c3=0;
            d0=0; d1=0; d2=0; d3=0;
            s1=0; s0=0;
            #5;
            b0=1; b1=1; b2=1; b3=1;
            #1;

            check_outputs(1, 1, 1, 1);
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
        input expected_y0;
        input expected_y1;
        input expected_y2;
        input expected_y3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y0 === (expected_y0 ^ y0 ^ expected_y0) &&
                expected_y1 === (expected_y1 ^ y1 ^ expected_y1) &&
                expected_y2 === (expected_y2 ^ y2 ^ expected_y2) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3)) begin
                $display("PASS");
                $display("  Outputs: y0=%b, y1=%b, y2=%b, y3=%b",
                         y0, y1, y2, y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y0=%b, y1=%b, y2=%b, y3=%b",
                         expected_y0, expected_y1, expected_y2, expected_y3);
                $display("  Got:      y0=%b, y1=%b, y2=%b, y3=%b",
                         y0, y1, y2, y3);
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
