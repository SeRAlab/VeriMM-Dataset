`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in;
    reg [2:0] state;
    wire E_next;
    wire F_next;
    wire G_next;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .state(state),
        .E_next(E_next),
        .F_next(F_next),
        .G_next(G_next),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase001: State E, in=0 -> Next: E, Out: 1");

        state = 3'b001;
        in = 0;
        #10;

        #1;


        check_outputs(1, 0, 0, 1);
    end
    endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase002: State E, in=1 -> Next: F, Out: 1");

        state = 3'b001;
        in = 1;
        #10;

        #1;


        check_outputs(0, 1, 0, 1);
    end
    endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase003: State F, in=0 -> Next: G, Out: 1");

        state = 3'b001;
        #5;
        state = 3'b010;
        in = 0;
        #10;

        #1;


        check_outputs(0, 0, 1, 1);
    end
    endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase004: State F, in=1 -> Next: E, Out: 1");

        state = 3'b001;
        #5;
        state = 3'b010;
        in = 1;
        #10;

        #1;


        check_outputs(1, 0, 0, 1);
    end
    endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase005: State G, in=0 -> Next: F, Out: 0");

        state = 3'b001;
        #5;
        state = 3'b100;
        in = 0;
        #10;

        #1;


        check_outputs(0, 1, 0, 0);
    end
    endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase006: State G, in=1 -> Next: G, Out: 0");

        state = 3'b001;
        #5;
        state = 3'b100;
        in = 1;
        #10;

        #1;


        check_outputs(0, 0, 1, 0);
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
        input expected_E_next;
        input expected_F_next;
        input expected_G_next;
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_E_next === (expected_E_next ^ E_next ^ expected_E_next) &&
                expected_F_next === (expected_F_next ^ F_next ^ expected_F_next) &&
                expected_G_next === (expected_G_next ^ G_next ^ expected_G_next) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: E_next=%b, F_next=%b, G_next=%b, out=%b",
                         E_next, F_next, G_next, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: E_next=%b, F_next=%b, G_next=%b, out=%b",
                         expected_E_next, expected_F_next, expected_G_next, expected_out);
                $display("  Got:      E_next=%b, F_next=%b, G_next=%b, out=%b",
                         E_next, F_next, G_next, out);
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
