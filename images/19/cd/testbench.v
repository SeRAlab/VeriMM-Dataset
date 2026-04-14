`timescale 1ns/1ps

module AStar_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] cost_to_goal;
    reg [3:0] current_state_x;
    reg [3:0] current_state_y;
    reg [3:0] goal_state_x;
    reg [3:0] goal_state_y;
    reg rst;
    wire [3:0] next_state_x;
    wire [3:0] next_state_y;
    wire [7:0] path_cost;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStar dut (
        .clk(clk),
        .cost_to_goal(cost_to_goal),
        .current_state_x(current_state_x),
        .current_state_y(current_state_y),
        .goal_state_x(goal_state_x),
        .goal_state_y(goal_state_y),
        .rst(rst),
        .next_state_x(next_state_x),
        .next_state_y(next_state_y),
        .path_cost(path_cost)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            cost_to_goal = 0;
            current_state_x = 0;
            current_state_y = 0;
            goal_state_x = 0;
            goal_state_y = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            cost_to_goal = 8'd10;
            current_state_x = 4'd5;
            current_state_y = 4'd5;
            goal_state_x = 4'd5;
            goal_state_y = 4'd5;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Current at Goal", test_num);
            #1;

            check_outputs(4'd5, 4'd5, 8'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            cost_to_goal = 8'd5;
            current_state_x = 4'd5;
            current_state_y = 4'd3;
            goal_state_x = 4'd8;
            goal_state_y = 4'd3;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Move Right", test_num);
            #1;

            check_outputs(4'd6, 4'd3, 8'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            cost_to_goal = 8'd0;
            current_state_x = 4'd4;
            current_state_y = 4'd2;
            goal_state_x = 4'd4;
            goal_state_y = 4'd7;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Move Up", test_num);
            #1;

            check_outputs(4'd4, 4'd3, 8'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            cost_to_goal = 8'd20;
            current_state_x = 4'd2;
            current_state_y = 4'd2;
            goal_state_x = 4'd4;
            goal_state_y = 4'd4;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Diagonal Move (X-priority)", test_num);
            #1;

            check_outputs(4'd3, 4'd2, 8'd24);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            cost_to_goal = 8'd100;
            current_state_x = 4'd0;
            current_state_y = 4'd0;
            goal_state_x = 4'd15;
            goal_state_y = 4'd10;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Large Path Cost", test_num);
            #1;

            check_outputs(4'd1, 4'd0, 8'd125);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            cost_to_goal = 8'd10;
            current_state_x = 4'd10;
            current_state_y = 4'd10;
            goal_state_x = 4'd8;
            goal_state_y = 4'd8;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Move Backwards", test_num);
            #1;

            check_outputs(4'd9, 4'd10, 8'd14);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AStar Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [3:0] expected_next_state_x;
        input [3:0] expected_next_state_y;
        input [7:0] expected_path_cost;
        begin
            if (expected_next_state_x === (expected_next_state_x ^ next_state_x ^ expected_next_state_x) &&
                expected_next_state_y === (expected_next_state_y ^ next_state_y ^ expected_next_state_y) &&
                expected_path_cost === (expected_path_cost ^ path_cost ^ expected_path_cost)) begin
                $display("PASS");
                $display("  Outputs: next_state_x=%h, next_state_y=%h, path_cost=%h",
                         next_state_x, next_state_y, path_cost);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_state_x=%h, next_state_y=%h, path_cost=%h",
                         expected_next_state_x, expected_next_state_y, expected_path_cost);
                $display("  Got:      next_state_x=%h, next_state_y=%h, path_cost=%h",
                         next_state_x, next_state_y, path_cost);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, cost_to_goal, current_state_x, current_state_y, goal_state_x, goal_state_y, rst, next_state_x, next_state_y, path_cost);
    end

endmodule
