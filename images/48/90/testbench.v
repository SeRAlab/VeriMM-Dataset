`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in;
    reg [2:0] state;
    wire [2:0] next_state;
    wire out1;
    wire out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .state(state),
        .next_state(next_state),
        .out1(out1),
        .out2(out2)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: State M (3'b001), in = 0", test_num);
            state = 3'b001;
            in = 0;

            #1;


            check_outputs(3'b010, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: State M (3'b001), in = 1", test_num);
            state = 3'b001;
            in = 1;

            #1;


            check_outputs(3'b100, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: State N (3'b010), in = 0", test_num);
            state = 3'b010;
            in = 0;

            #1;


            check_outputs(3'b100, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: State N (3'b010), in = 1", test_num);
            state = 3'b010;
            in = 1;

            #1;


            check_outputs(3'b001, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: State O (3'b100), in = 0", test_num);
            state = 3'b100;
            in = 0;

            #1;


            check_outputs(3'b001, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: State O (3'b100), in = 1", test_num);
            state = 3'b100;
            in = 1;

            #1;


            check_outputs(3'b010, 1'b1, 1'b1);
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
        input [2:0] expected_next_state;
        input expected_out1;
        input expected_out2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_next_state === (expected_next_state ^ next_state ^ expected_next_state) &&
                expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2)) begin
                $display("PASS");
                $display("  Outputs: next_state=%h, out1=%b, out2=%b",
                         next_state, out1, out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_state=%h, out1=%b, out2=%b",
                         expected_next_state, expected_out1, expected_out2);
                $display("  Got:      next_state=%h, out1=%b, out2=%b",
                         next_state, out1, out2);
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
