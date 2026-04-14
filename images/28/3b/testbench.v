`timescale 1ns/1ps

module AStarHeuristic_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] current_cost;
    reg [3:0] heuristic;
    wire [3:0] f_cost;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStarHeuristic dut (
        .current_cost(current_cost),
        .heuristic(heuristic),
        .f_cost(f_cost)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero sum (0 + 0)", test_num);
            current_cost = 4'd0;
            heuristic = 4'd0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic addition (3 + 4)", test_num);
            current_cost = 4'd3;
            heuristic = 4'd4;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary condition - Sum exactly 15 (7 + 8)", test_num);
            current_cost = 4'd7;
            heuristic = 4'd8;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Satiation - Sum slightly over 15 (8 + 8 = 16)", test_num);
            current_cost = 4'd8;
            heuristic = 4'd8;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Satiation - Maximum inputs (15 + 15 = 30)", test_num);
            current_cost = 4'd15;
            heuristic = 4'd15;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Satiation - One max input and small offset (15 + 1)", test_num);
            current_cost = 4'd15;
            heuristic = 4'd1;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero cost, max heuristic (0 + 15)", test_num);
            current_cost = 4'd0;
            heuristic = 4'd15;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max cost, zero heuristic (15 + 0)", test_num);
            current_cost = 4'd15;
            heuristic = 4'd0;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random small values (5 + 2)", test_num);
            current_cost = 4'd5;
            heuristic = 4'd2;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Satiation - High values (10 + 12)", test_num);
            current_cost = 4'd10;
            heuristic = 4'd12;
            #1;

            check_outputs(4'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AStarHeuristic Testbench");
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
        input [3:0] expected_f_cost;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_f_cost === (expected_f_cost ^ f_cost ^ expected_f_cost)) begin
                $display("PASS");
                $display("  Outputs: f_cost=%h",
                         f_cost);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f_cost=%h",
                         expected_f_cost);
                $display("  Got:      f_cost=%h",
                         f_cost);
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
