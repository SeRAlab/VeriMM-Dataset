`timescale 1ns/1ps

module AStarPathFinder_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] goal_x;
    reg [4:0] goal_y;
    reg [4:0] x;
    reg [4:0] y;
    wire [4:0] next_x;
    wire [4:0] next_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStarPathFinder dut (
        .goal_x(goal_x),
        .goal_y(goal_y),
        .x(x),
        .y(y),
        .next_x(next_x),
        .next_y(next_y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Current position is at the goal", test_num);
            x = 5'd10; y = 5'd10;
            goal_x = 5'd10; goal_y = 5'd10;
            #1;

            check_outputs(5'd10, 5'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Goal is to the right (+X)", test_num);
            x = 5'd10; y = 5'd10;
            goal_x = 5'd20; goal_y = 5'd10;
            #1;

            check_outputs(5'd11, 5'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Goal is to the left (-X)", test_num);
            x = 5'd10; y = 5'd10;
            goal_x = 5'd5; goal_y = 5'd10;
            #1;

            check_outputs(5'd9, 5'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Goal is above (+Y)", test_num);
            x = 5'd10; y = 5'd10;
            goal_x = 5'd10; goal_y = 5'd15;
            #1;

            check_outputs(5'd10, 5'd11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Goal is below (-Y)", test_num);
            x = 5'd10; y = 5'd10;
            goal_x = 5'd10; goal_y = 5'd2;
            #1;

            check_outputs(5'd10, 5'd9);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Diagonal Move (+X, +Y)", test_num);
            x = 5'd10; y = 5'd10;
            goal_x = 5'd15; goal_y = 5'd15;
            #1;

            check_outputs(5'd11, 5'd11);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Diagonal Move (-X, -Y)", test_num);
            x = 5'd10; y = 5'd10;
            goal_x = 5'd0; goal_y = 5'd0;
            #1;

            check_outputs(5'd9, 5'd9);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Boundary check at (0,0)", test_num);
            x = 5'd0; y = 5'd0;
            goal_x = 5'd5; goal_y = 5'd5;
            #1;

            check_outputs(5'd1, 5'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Boundary check at (31,31)", test_num);
            x = 5'd31; y = 5'd31;
            goal_x = 5'd20; goal_y = 5'd20;
            #1;

            check_outputs(5'd30, 5'd30);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: One step away from goal", test_num);
            x = 5'd15; y = 5'd15;
            goal_x = 5'd16; goal_y = 5'd15;
            #1;

            check_outputs(5'd16, 5'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AStarPathFinder Testbench");
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
        input [4:0] expected_next_x;
        input [4:0] expected_next_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_next_x === (expected_next_x ^ next_x ^ expected_next_x) &&
                expected_next_y === (expected_next_y ^ next_y ^ expected_next_y)) begin
                $display("PASS");
                $display("  Outputs: next_x=%h, next_y=%h",
                         next_x, next_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_x=%h, next_y=%h",
                         expected_next_x, expected_next_y);
                $display("  Got:      next_x=%h, next_y=%h",
                         next_x, next_y);
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
