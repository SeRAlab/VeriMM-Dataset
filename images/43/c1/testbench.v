`timescale 1ns/1ps

module fsm_3_tb;

    // Testbench signals (combinational circuit)
    reg E;
    reg [2:0] state;
    wire [2:0] next_state;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fsm_3 dut (
        .E(E),
        .state(state),
        .next_state(next_state),
        .out(out)
    );
    task testcase001;

        begin
            $display("Test Case 001: State M, E=0 -> Stay in M, out=0");
            E = 0;
            state = 3'b001;
            #1;

            check_outputs(3'b001, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: State M, E=1 -> Transition to N, out=0");
            E = 1;
            state = 3'b001;
            #1;

            check_outputs(3'b010, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: State N, E=1 -> Stay in N, out=1");
            E = 1;
            state = 3'b010;
            #1;

            check_outputs(3'b010, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: State N, E=0 -> Transition to O, out=1");
            E = 0;
            state = 3'b010;
            #1;

            check_outputs(3'b100, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: State O, E=0 -> Stay in O, out=1");
            E = 0;
            state = 3'b100;
            #1;

            check_outputs(3'b100, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: State O, E=1 -> Transition to M, out=1");
            E = 1;
            state = 3'b100;
            #1;

            check_outputs(3'b001, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fsm_3 Testbench");
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
        input [2:0] expected_next_state;
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_next_state === (expected_next_state ^ next_state ^ expected_next_state) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: next_state=%h, out=%b",
                         next_state, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_state=%h, out=%b",
                         expected_next_state, expected_out);
                $display("  Got:      next_state=%h, out=%b",
                         next_state, out);
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
