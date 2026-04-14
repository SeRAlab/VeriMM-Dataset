`timescale 1ns/1ps

module AStarNextNode_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] current_node;
    reg [4:0] goal_node;
    reg [4:0] heuristic;
    wire [4:0] next_node;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStarNextNode dut (
        .current_node(current_node),
        .goal_node(goal_node),
        .heuristic(heuristic),
        .next_node(next_node)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            current_node = 5'd10;
            goal_node = 5'd20;
            heuristic = 5'd10;
            $display("Test %0d: Moving Up (Current: 10, Goal: 20)", test_num);
            #1;

            check_outputs(5'd11);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            current_node = 5'd25;
            goal_node = 5'd15;
            heuristic = 5'd10;
            $display("Test %0d: Moving Down (Current: 25, Goal: 15)", test_num);
            #1;

            check_outputs(5'd24);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            current_node = 5'd15;
            goal_node = 5'd15;
            heuristic = 5'd0;
            $display("Test %0d: At Goal (Current: 15, Goal: 15)", test_num);
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            current_node = 5'd0;
            goal_node = 5'd5;
            heuristic = 5'd5;
            $display("Test %0d: Boundary Start (Current: 0, Goal: 5)", test_num);
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            current_node = 5'd31;
            goal_node = 5'd20;
            heuristic = 5'd11;
            $display("Test %0d: Boundary End (Current: 31, Goal: 20)", test_num);
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            current_node = 5'd2;
            goal_node = 5'd30;
            heuristic = 5'd28;
            $display("Test %0d: Large Gap Up (Current: 2, Goal: 30)", test_num);
            #1;

            check_outputs(5'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            current_node = 5'd30;
            goal_node = 5'd1;
            heuristic = 5'd29;
            $display("Test %0d: Large Gap Down (Current: 30, Goal: 1)", test_num);
            #1;

            check_outputs(5'd29);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            current_node = 5'd10;
            goal_node = 5'd11;
            heuristic = 5'd1;
            $display("Test %0d: Neighbor Goal (Current: 10, Goal: 11)", test_num);
            #1;

            check_outputs(5'd11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AStarNextNode Testbench");
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
        input [4:0] expected_next_node;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_next_node === (expected_next_node ^ next_node ^ expected_next_node)) begin
                $display("PASS");
                $display("  Outputs: next_node=%h",
                         next_node);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_node=%h",
                         expected_next_node);
                $display("  Got:      next_node=%h",
                         next_node);
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
