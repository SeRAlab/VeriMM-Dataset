`timescale 1ns/1ps

module AStarSearch_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] current_cost;
    reg [3:0] heuristic_cost;
    reg [3:0] total_cost;
    wire [3:0] next_step;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStarSearch dut (
        .current_cost(current_cost),
        .heuristic_cost(heuristic_cost),
        .total_cost(total_cost),
        .next_step(next_step)
    );
    task testcase001;

        begin
            test_num = test_num + 1;

            current_cost = 4'd2;
            heuristic_cost = 4'd3;
            total_cost = 4'd1;

            $display("Test Case %0d: current_cost=%d, heuristic_cost=%d, total_cost=%d", test_num, current_cost, heuristic_cost, total_cost);
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;

            current_cost = 4'd2;
            heuristic_cost = 4'd3;
            total_cost = 4'd6;

            $display("Test Case %0d: current_cost=%d, heuristic_cost=%d, total_cost=%d", test_num, current_cost, heuristic_cost, total_cost);
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;

            current_cost = 4'd4;
            heuristic_cost = 4'd4;
            total_cost = 4'd8;

            $display("Test Case %0d: current_cost=%d, heuristic_cost=%d, total_cost=%d", test_num, current_cost, heuristic_cost, total_cost);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;

            current_cost = 4'd0;
            heuristic_cost = 4'd0;
            total_cost = 4'd0;

            $display("Test Case %0d: current_cost=%d, heuristic_cost=%d, total_cost=%d", test_num, current_cost, heuristic_cost, total_cost);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;

            current_cost = 4'd10;
            heuristic_cost = 4'd10;
            total_cost = 4'd2;

            $display("Test Case %0d: current_cost=%d, heuristic_cost=%d, total_cost=%d", test_num, current_cost, heuristic_cost, total_cost);
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;

            current_cost = 4'd15;
            heuristic_cost = 4'd2;
            total_cost = 4'd15;

            $display("Test Case %0d: current_cost=%d, heuristic_cost=%d, total_cost=%d", test_num, current_cost, heuristic_cost, total_cost);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;

            current_cost = 4'd0;
            heuristic_cost = 4'd1;
            total_cost = 4'd0;

            $display("Test Case %0d: current_cost=%d, heuristic_cost=%d, total_cost=%d", test_num, current_cost, heuristic_cost, total_cost);
            #1;

            check_outputs(4'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AStarSearch Testbench");
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
        input [3:0] expected_next_step;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_next_step === (expected_next_step ^ next_step ^ expected_next_step)) begin
                $display("PASS");
                $display("  Outputs: next_step=%h",
                         next_step);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_step=%h",
                         expected_next_step);
                $display("  Got:      next_step=%h",
                         next_step);
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
