`timescale 1ns/1ps

module AStarFSM_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] actual_cost;
    reg [3:0] current_state;
    reg [7:0] heuristic_cost;
    wire [3:0] next_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStarFSM dut (
        .actual_cost(actual_cost),
        .current_state(current_state),
        .heuristic_cost(heuristic_cost),
        .next_state(next_state)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Start State - Moving from state 0 to 1", test_num);
            current_state = 4'd0;
            actual_cost = 8'd10;
            heuristic_cost = 8'd5;

            #1;


            check_outputs(4'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Intermediate State - Transition from state 1 to 2", test_num);
            current_state = 4'd1;
            actual_cost = 8'd20;
            heuristic_cost = 8'd15;
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Intermediate State - Transition from state 2 to 3", test_num);
            current_state = 4'd2;
            actual_cost = 8'd30;
            heuristic_cost = 8'd25;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: High Cost Analysis - State 3 to 4", test_num);
            current_state = 4'd3;
            actual_cost = 8'd100;
            heuristic_cost = 8'd50;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Reaching Goal State - Assuming 4 is goal", test_num);
            current_state = 4'd4;
            actual_cost = 8'd150;
            heuristic_cost = 8'd0;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Boundary Condition - Max State", test_num);
            current_state = 4'hF;
            actual_cost = 8'hFF;
            heuristic_cost = 8'hFF;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Low Cost Efficiency - State 1 with minimal costs", test_num);
            current_state = 4'd1;
            actual_cost = 8'd1;
            heuristic_cost = 8'd1;
            #1;

            check_outputs(4'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AStarFSM Testbench");
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
        input [3:0] expected_next_state;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_next_state === (expected_next_state ^ next_state ^ expected_next_state)) begin
                $display("PASS");
                $display("  Outputs: next_state=%h",
                         next_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_state=%h",
                         expected_next_state);
                $display("  Got:      next_state=%h",
                         next_state);
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
