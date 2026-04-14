`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in;
    reg [1:0] state;
    wire [1:0] next_state;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .state(state),
        .next_state(next_state),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: State A (00), In=0", test_num);
            state = 2'b00;
            in = 1'b0;

            #1;


            check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: State A (00), In=1", test_num);
            state = 2'b00;
            in = 1'b1;

            #1;


            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: State B (01), In=0", test_num);
            state = 2'b01;
            in = 1'b0;

            #1;


            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: State B (01), In=1", test_num);
            state = 2'b01;
            in = 1'b1;

            #1;


            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: State C (10), In=0", test_num);
            state = 2'b10;
            in = 1'b0;

            #1;


            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: State C (10), In=1", test_num);
            state = 2'b10;
            in = 1'b1;

            #1;


            check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: State D (11), In=0", test_num);
            state = 2'b11;
            in = 1'b0;

            #1;


            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: State D (11), In=1", test_num);
            state = 2'b11;
            in = 1'b1;

            #1;


            check_outputs(2'b11, 1'b0);
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
        input [1:0] expected_next_state;
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
