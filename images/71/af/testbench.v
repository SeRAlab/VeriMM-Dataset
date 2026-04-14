`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in;
    reg [2:0] state;
    wire W_next;
    wire X_next;
    wire Y_next;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .state(state),
        .W_next(W_next),
        .X_next(X_next),
        .Y_next(Y_next),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: State W (001), in=0 -> Expect W_next, out=1", test_num);
        state = 3'b001; in = 1'b0;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: State W (001), in=1 -> Expect X_next, out=1", test_num);
        state = 3'b001; in = 1'b1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: State X (010), in=0 -> Expect Y_next, out=0", test_num);
        state = 3'b010; in = 1'b0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: State X (010), in=1 -> Expect X_next, out=0", test_num);
        state = 3'b010; in = 1'b1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: State Y (100), in=0 -> Expect X_next, out=1", test_num);
        state = 3'b100; in = 1'b0;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: State Y (100), in=1 -> Expect W_next, out=1", test_num);
        state = 3'b100; in = 1'b1;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b1);
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
        input expected_W_next;
        input expected_X_next;
        input expected_Y_next;
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_W_next === (expected_W_next ^ W_next ^ expected_W_next) &&
                expected_X_next === (expected_X_next ^ X_next ^ expected_X_next) &&
                expected_Y_next === (expected_Y_next ^ Y_next ^ expected_Y_next) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: W_next=%b, X_next=%b, Y_next=%b, out=%b",
                         W_next, X_next, Y_next, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: W_next=%b, X_next=%b, Y_next=%b, out=%b",
                         expected_W_next, expected_X_next, expected_Y_next, expected_out);
                $display("  Got:      W_next=%b, X_next=%b, Y_next=%b, out=%b",
                         W_next, X_next, Y_next, out);
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
