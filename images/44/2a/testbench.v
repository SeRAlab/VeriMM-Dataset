`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg reset;
    reg [3:0] state;
    wire Q0_next;
    wire Q1_next;
    wire Q2_next;
    wire Q3_next;
    wire out1;
    wire out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .state(state),
        .Q0_next(Q0_next),
        .Q1_next(Q1_next),
        .Q2_next(Q2_next),
        .Q3_next(Q3_next),
        .out1(out1),
        .out2(out2)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Reset logic from state Q3", test_num);
        reset = 1; clk = 1; state = 4'b1000;
        #1;

        check_outputs(1, 0, 0, 0, 1, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: State Q0 transition with clk=0", test_num);
        reset = 0; clk = 0; state = 4'b0001;
        #1;

        check_outputs(0, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: State Q0 transition with clk=1", test_num);
        reset = 0; clk = 1; state = 4'b0001;
        #1;

        check_outputs(0, 0, 1, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: State Q1 transition with clk=0", test_num);
        reset = 0; clk = 0; state = 4'b0010;
        #1;

        check_outputs(0, 0, 0, 1, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: State Q1 transition with clk=1", test_num);
        reset = 0; clk = 1; state = 4'b0010;
        #1;

        check_outputs(1, 0, 0, 0, 0, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: State Q2 transition with clk=0", test_num);
        reset = 0; clk = 0; state = 4'b0100;
        #1;

        check_outputs(1, 0, 0, 0, 1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: State Q2 transition with clk=1", test_num);
        reset = 0; clk = 1; state = 4'b0100;
        #1;

        check_outputs(0, 0, 0, 1, 1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: State Q3 transition with clk=0", test_num);
        reset = 0; clk = 0; state = 4'b1000;
        #1;

        check_outputs(0, 0, 1, 0, 1, 1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: State Q3 transition with clk=1", test_num);
        reset = 0; clk = 1; state = 4'b1000;
        #1;

        check_outputs(0, 1, 0, 0, 1, 1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Reset logic from state Q0", test_num);
        reset = 1; clk = 0; state = 4'b0001;
        #1;

        check_outputs(1, 0, 0, 0, 0, 0);
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
        input expected_Q0_next;
        input expected_Q1_next;
        input expected_Q2_next;
        input expected_Q3_next;
        input expected_out1;
        input expected_out2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q0_next === (expected_Q0_next ^ Q0_next ^ expected_Q0_next) &&
                expected_Q1_next === (expected_Q1_next ^ Q1_next ^ expected_Q1_next) &&
                expected_Q2_next === (expected_Q2_next ^ Q2_next ^ expected_Q2_next) &&
                expected_Q3_next === (expected_Q3_next ^ Q3_next ^ expected_Q3_next) &&
                expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2)) begin
                $display("PASS");
                $display("  Outputs: Q0_next=%b, Q1_next=%b, Q2_next=%b, Q3_next=%b, out1=%b, out2=%b",
                         Q0_next, Q1_next, Q2_next, Q3_next, out1, out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q0_next=%b, Q1_next=%b, Q2_next=%b, Q3_next=%b, out1=%b, out2=%b",
                         expected_Q0_next, expected_Q1_next, expected_Q2_next, expected_Q3_next, expected_out1, expected_out2);
                $display("  Got:      Q0_next=%b, Q1_next=%b, Q2_next=%b, Q3_next=%b, out1=%b, out2=%b",
                         Q0_next, Q1_next, Q2_next, Q3_next, out1, out2);
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
