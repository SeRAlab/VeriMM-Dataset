`timescale 1ns/1ps

module AStarSearch_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] goal_x;
    reg [3:0] goal_y;
    reg [3:0] move_cost;
    reg [3:0] start_x;
    reg [3:0] start_y;
    wire [7:0] total_cost;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStarSearch dut (
        .goal_x(goal_x),
        .goal_y(goal_y),
        .move_cost(move_cost),
        .start_x(start_x),
        .start_y(start_y),
        .total_cost(total_cost)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Identical Start and Goal", test_num);
        start_x = 4'd5;
        start_y = 4'd5;
        goal_x = 4'd5;
        goal_y = 4'd5;
        move_cost = 4'd10;

        #1;


        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Pure Horizontal Movement", test_num);
        start_x = 4'd2;
        start_y = 4'd3;
        goal_x = 4'd10;
        goal_y = 4'd3;
        move_cost = 4'd2;

        #1;


        check_outputs(8'd16);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Pure Vertical Movement", test_num);
        start_x = 4'd0;
        start_y = 4'd0;
        goal_x = 4'd0;
        goal_y = 4'd15;
        move_cost = 4'd3;

        #1;


        check_outputs(8'd45);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Diagonal Path (Manhattan Distance)", test_num);
        start_x = 4'd1;
        start_y = 4'd1;
        goal_x = 4'd4;
        goal_y = 4'd5;
        move_cost = 4'd5;

        #1;


        check_outputs(8'd35);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Move Cost is Zero", test_num);
        start_x = 4'd0;
        start_y = 4'd0;
        goal_x = 4'd15;
        goal_y = 4'd15;
        move_cost = 4'd0;

        #1;


        check_outputs(8'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Negative Direction Movement (Goal < Start)", test_num);
        start_x = 4'd10;
        start_y = 4'd12;
        goal_x = 4'd2;
        goal_y = 4'd4;
        move_cost = 4'd1;

        #1;


        check_outputs(8'd16);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Large Path within 8-bit Output Range", test_num);
        start_x = 4'd0;
        start_y = 4'd0;
        goal_x = 4'd15;
        goal_y = 4'd15;
        move_cost = 4'd8;

        #1;


        check_outputs(8'd240);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Minimum Distance with High Move Cost", test_num);
        start_x = 4'd7;
        start_y = 4'd7;
        goal_x = 4'd8;
        goal_y = 4'd7;
        move_cost = 4'd15;

        #1;


        check_outputs(8'd15);
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
        input [7:0] expected_total_cost;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_total_cost === (expected_total_cost ^ total_cost ^ expected_total_cost)) begin
                $display("PASS");
                $display("  Outputs: total_cost=%h",
                         total_cost);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: total_cost=%h",
                         expected_total_cost);
                $display("  Got:      total_cost=%h",
                         total_cost);
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
