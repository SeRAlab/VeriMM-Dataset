`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg [2:0] state;
    wire X_next;
    wire Y_next;
    wire Z_next;
    wire b;
    wire c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .state(state),
        .X_next(X_next),
        .Y_next(Y_next),
        .Z_next(Z_next),
        .b(b),
        .c(c)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: State X, a=0");
            state = 3'b001;
            a = 0;
            #1;

            check_outputs(0, 1, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: State X, a=1");
            state = 3'b001;
            a = 1;
            #1;

            check_outputs(0, 0, 1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: State Y, a=0");
            state = 3'b010;
            a = 0;
            #1;

            check_outputs(0, 0, 1, 1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: State Y, a=1");
            state = 3'b010;
            a = 1;
            #1;

            check_outputs(1, 0, 0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: State Z, a=0");
            state = 3'b100;
            a = 0;
            #1;

            check_outputs(1, 0, 0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: State Z, a=1");
            state = 3'b100;
            a = 1;
            #1;

            check_outputs(0, 1, 0, 0, 1);
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
        input expected_X_next;
        input expected_Y_next;
        input expected_Z_next;
        input expected_b;
        input expected_c;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X_next === (expected_X_next ^ X_next ^ expected_X_next) &&
                expected_Y_next === (expected_Y_next ^ Y_next ^ expected_Y_next) &&
                expected_Z_next === (expected_Z_next ^ Z_next ^ expected_Z_next) &&
                expected_b === (expected_b ^ b ^ expected_b) &&
                expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: X_next=%b, Y_next=%b, Z_next=%b, b=%b, c=%b",
                         X_next, Y_next, Z_next, b, c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X_next=%b, Y_next=%b, Z_next=%b, b=%b, c=%b",
                         expected_X_next, expected_Y_next, expected_Z_next, expected_b, expected_c);
                $display("  Got:      X_next=%b, Y_next=%b, Z_next=%b, b=%b, c=%b",
                         X_next, Y_next, Z_next, b, c);
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
