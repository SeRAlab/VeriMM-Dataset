`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg start;
    reg [2:0] state;
    wire Done_next;
    wire Idle_next;
    wire Processing_next;
    wire done;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .start(start),
        .state(state),
        .Done_next(Done_next),
        .Idle_next(Idle_next),
        .Processing_next(Processing_next),
        .done(done),
        .ready(ready)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Idle state (001), start=0", test_num);
            state = 3'b001;
            start = 1'b0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Idle state (001), start=1", test_num);
            state = 3'b001;
            start = 1'b1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Processing state (010), start=1", test_num);
            state = 3'b010;
            start = 1'b1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Processing state (010), start=0", test_num);
            state = 3'b010;
            start = 1'b0;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Done state (100), start=0", test_num);
            state = 3'b100;
            start = 1'b0;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Done state (100), start=1", test_num);
            state = 3'b100;
            start = 1'b1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Transition Sequence Path Simulation", test_num);


            state = 3'b001; start = 1;
            #2;


            state = 3'b010; start = 1;
            #2;


            state = 3'b010; start = 0;
            #2;


            state = 3'b100; start = 0;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b1, 1'b0);
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
        input expected_Done_next;
        input expected_Idle_next;
        input expected_Processing_next;
        input expected_done;
        input expected_ready;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Done_next === (expected_Done_next ^ Done_next ^ expected_Done_next) &&
                expected_Idle_next === (expected_Idle_next ^ Idle_next ^ expected_Idle_next) &&
                expected_Processing_next === (expected_Processing_next ^ Processing_next ^ expected_Processing_next) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: Done_next=%b, Idle_next=%b, Processing_next=%b, done=%b, ready=%b",
                         Done_next, Idle_next, Processing_next, done, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Done_next=%b, Idle_next=%b, Processing_next=%b, done=%b, ready=%b",
                         expected_Done_next, expected_Idle_next, expected_Processing_next, expected_done, expected_ready);
                $display("  Got:      Done_next=%b, Idle_next=%b, Processing_next=%b, done=%b, ready=%b",
                         Done_next, Idle_next, Processing_next, done, ready);
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
