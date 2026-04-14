`timescale 1ns/1ps

module AStar_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] goal_x;
    reg [3:0] goal_y;
    reg [15:0] obstacles;
    reg reset;
    reg start;
    reg [3:0] start_x;
    reg [3:0] start_y;
    wire done;
    wire [3:0] path_x;
    wire [3:0] path_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStar dut (
        .clk(clk),
        .goal_x(goal_x),
        .goal_y(goal_y),
        .obstacles(obstacles),
        .reset(reset),
        .start(start),
        .start_x(start_x),
        .start_y(start_y),
        .done(done),
        .path_x(path_x),
        .path_y(path_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            start_x = 0;
            start_y = 0;
            goal_x = 0;
            goal_y = 0;
            obstacles = 16'h0000;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Simple Horizontal Path (0,0) -> (2,0)");
            reset_dut();
            start_x = 4'd0; start_y = 4'd0;
            goal_x = 4'd2;  goal_y = 4'd0;
            obstacles = 16'h0000;
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd2, 4'd0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Obstacle Bypass (0,0) -> (0,2) with obstacle at (0,1)");
            reset_dut();
            start_x = 4'd0; start_y = 4'd0;
            goal_x = 4'd0;  goal_y = 4'd2;
            obstacles = 16'b0000_0000_0001_0000;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd0, 4'd2);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Diagonal Search (0,0) -> (3,3)");
            reset_dut();
            start_x = 4'd0; start_y = 4'd0;
            goal_x = 4'd3;  goal_y = 4'd3;
            obstacles = 16'h0000;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd3, 4'd3);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Start equals Goal (1,1) -> (1,1)");
            reset_dut();
            start_x = 4'd1; start_y = 4'd1;
            goal_x = 4'd1;  goal_y = 4'd1;
            obstacles = 16'h0000;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd1, 4'd1);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Complex Maze Path");
            reset_dut();
            start_x = 4'd0; start_y = 4'd0;
            goal_x = 4'd3;  goal_y = 4'd0;

            obstacles = 16'h0022;
            obstacles[1] = 1; obstacles[5] = 1; obstacles[4] = 1;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'd3, 4'd0);
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
        input expected_done;
        input [3:0] expected_path_x;
        input [3:0] expected_path_y;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_path_x === (expected_path_x ^ path_x ^ expected_path_x) &&
                expected_path_y === (expected_path_y ^ path_y ^ expected_path_y)) begin
                $display("PASS");
                $display("  Outputs: done=%b, path_x=%h, path_y=%h",
                         done, path_x, path_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, path_x=%h, path_y=%h",
                         expected_done, expected_path_x, expected_path_y);
                $display("  Got:      done=%b, path_x=%h, path_y=%h",
                         done, path_x, path_y);
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
        $dumpvars(0,clk, goal_x, goal_y, obstacles, reset, start, start_x, start_y, done, path_x, path_y);
    end

endmodule
