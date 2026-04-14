`timescale 1ns/1ps

module AStarSearch_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] current_node;
    reg [3:0] goal_node;
    reg [3:0] heuristic;
    wire is_goal;
    wire [3:0] next_node;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStarSearch dut (
        .current_node(current_node),
        .goal_node(goal_node),
        .heuristic(heuristic),
        .is_goal(is_goal),
        .next_node(next_node)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Current node is goal node", test_num);
            current_node = 4'd5;
            goal_node = 4'd5;
            heuristic = 4'd0;

            #1;


            check_outputs(1'b1, 4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Current node is not goal, simple increment", test_num);
            current_node = 4'd2;
            goal_node = 4'd8;
            heuristic = 4'd6;

            #1;


            check_outputs(1'b0, 4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary condition - Start of range", test_num);
            current_node = 4'd0;
            goal_node = 4'd15;
            heuristic = 4'd15;

            #1;


            check_outputs(1'b0, 4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reaching goal from adjacent node", test_num);
            current_node = 4'd14;
            goal_node = 4'd15;
            heuristic = 4'd1;

            #1;


            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Goal node at zero", test_num);
            current_node = 4'd0;
            goal_node = 4'd0;
            heuristic = 4'd0;

            #1;


            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large heuristic value influence", test_num);
            current_node = 4'd7;
            goal_node = 4'd12;
            heuristic = 4'd10;

            #1;


            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum node values", test_num);
            current_node = 4'd15;
            goal_node = 4'd15;
            heuristic = 4'd0;

            #1;


            check_outputs(1'b1, 4'd15);
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
        input expected_is_goal;
        input [3:0] expected_next_node;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_is_goal === (expected_is_goal ^ is_goal ^ expected_is_goal) &&
                expected_next_node === (expected_next_node ^ next_node ^ expected_next_node)) begin
                $display("PASS");
                $display("  Outputs: is_goal=%b, next_node=%h",
                         is_goal, next_node);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_goal=%b, next_node=%h",
                         expected_is_goal, expected_next_node);
                $display("  Got:      is_goal=%b, next_node=%h",
                         is_goal, next_node);
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
