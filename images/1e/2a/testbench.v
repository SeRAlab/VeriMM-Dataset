`timescale 1ns/1ps

module AStarCalculator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] g;
    reg goal_reached;
    reg [7:0] h;
    wire [7:0] f;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStarCalculator dut (
        .g(g),
        .goal_reached(goal_reached),
        .h(h),
        .f(f)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard calculation (g=10, h=20, goal=0)", test_num);
            g = 8'd10;
            h = 8'd20;
            goal_reached = 1'b0;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Goal reached flag active (g=15, h=50, goal=1)", test_num);
            g = 8'd15;
            h = 8'd50;
            goal_reached = 1'b1;

            #1;


            check_outputs(8'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero heuristic (g=45, h=0, goal=0)", test_num);
            g = 8'd45;
            h = 8'd0;
            goal_reached = 1'b0;
            #1;

            check_outputs(8'd45);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum value sum (g=128, h=127, goal=0)", test_num);
            g = 8'd128;
            h = 8'd127;
            goal_reached = 1'b0;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow handling (g=200, h=100, goal=0)", test_num);
            g = 8'd200;
            h = 8'd100;
            goal_reached = 1'b0;

            #1;


            check_outputs(8'd44);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            g = 8'd0;
            h = 8'd0;
            goal_reached = 1'b0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large g, goal reached (g=255, h=255, goal=1)", test_num);
            g = 8'd255;
            h = 8'd255;
            goal_reached = 1'b1;
            #1;

            check_outputs(8'd255);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AStarCalculator Testbench");
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
        input [7:0] expected_f;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_f === (expected_f ^ f ^ expected_f)) begin
                $display("PASS");
                $display("  Outputs: f=%h",
                         f);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f=%h",
                         expected_f);
                $display("  Got:      f=%h",
                         f);
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
