`timescale 1ns/1ps

module fsm_circuit_tb;

    // Testbench signals (combinational circuit)
    reg in;
    reg [2:0] state;
    wire U_next;
    wire V_next;
    wire W_next;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fsm_circuit dut (
        .in(in),
        .state(state),
        .U_next(U_next),
        .V_next(V_next),
        .W_next(W_next),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: State U (001), in = 0");
        state = 3'b001;
        in = 0;
        #1;

        check_outputs(1, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: State U (001), in = 1");
        state = 3'b001;
        in = 1;
        #1;

        check_outputs(0, 1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: State V (010), in = 0");
        state = 3'b010;
        in = 0;
        #1;

        check_outputs(0, 0, 1, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: State V (010), in = 1");
        state = 3'b010;
        in = 1;
        #1;

        check_outputs(0, 1, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: State W (100), in = 0");
        state = 3'b100;
        in = 0;
        #1;

        check_outputs(0, 0, 1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: State W (100), in = 1");
        state = 3'b100;
        in = 1;
        #1;

        check_outputs(0, 1, 0, 0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fsm_circuit Testbench");
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
        input expected_U_next;
        input expected_V_next;
        input expected_W_next;
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_U_next === (expected_U_next ^ U_next ^ expected_U_next) &&
                expected_V_next === (expected_V_next ^ V_next ^ expected_V_next) &&
                expected_W_next === (expected_W_next ^ W_next ^ expected_W_next) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: U_next=%b, V_next=%b, W_next=%b, out=%b",
                         U_next, V_next, W_next, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: U_next=%b, V_next=%b, W_next=%b, out=%b",
                         expected_U_next, expected_V_next, expected_W_next, expected_out);
                $display("  Got:      U_next=%b, V_next=%b, W_next=%b, out=%b",
                         U_next, V_next, W_next, out);
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
