`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in;
    reg [2:0] state;
    wire S0_next;
    wire S1_next;
    wire S2_next;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .state(state),
        .S0_next(S0_next),
        .S1_next(S1_next),
        .S2_next(S2_next),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: S0 (001) with in=0");
            test_num = 1;
            state = 3'b001;
            in = 0;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: S0 (001) with in=1");
            test_num = 2;
            state = 3'b001;
            in = 1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: S1 (010) with in=0");
            test_num = 3;
            state = 3'b010;
            in = 0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: S1 (010) with in=1");
            test_num = 4;
            state = 3'b010;
            in = 1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: S2 (100) with in=0");
            test_num = 5;
            state = 3'b100;
            in = 0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: S2 (100) with in=1");
            test_num = 6;
            state = 3'b100;
            in = 1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
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
        input expected_S0_next;
        input expected_S1_next;
        input expected_S2_next;
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S0_next === (expected_S0_next ^ S0_next ^ expected_S0_next) &&
                expected_S1_next === (expected_S1_next ^ S1_next ^ expected_S1_next) &&
                expected_S2_next === (expected_S2_next ^ S2_next ^ expected_S2_next) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: S0_next=%b, S1_next=%b, S2_next=%b, out=%b",
                         S0_next, S1_next, S2_next, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S0_next=%b, S1_next=%b, S2_next=%b, out=%b",
                         expected_S0_next, expected_S1_next, expected_S2_next, expected_out);
                $display("  Got:      S0_next=%b, S1_next=%b, S2_next=%b, out=%b",
                         S0_next, S1_next, S2_next, out);
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
