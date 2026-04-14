`timescale 1ns/1ps

module AStarSearch_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] goal_x;
    reg [3:0] goal_y;
    reg [15:0] grid;
    reg rst;
    reg [3:0] start_x;
    reg [3:0] start_y;
    wire [15:0] path;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStarSearch dut (
        .clk(clk),
        .goal_x(goal_x),
        .goal_y(goal_y),
        .grid(grid),
        .rst(rst),
        .start_x(start_x),
        .start_y(start_y),
        .path(path)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start_x = 0;
            start_y = 0;
            goal_x = 0;
            goal_y = 0;
            grid = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task wait_cycles;

        input integer cycles;
        begin
            repeat (cycles) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Direct Horizontal Path (0,0) to (3,0)", test_num);
            reset_dut();
            start_x = 0; start_y = 0;
            goal_x = 3;  goal_y = 0;
            grid = 16'h0000;
            wait_cycles(100);
            #1;

            check_outputs(16'h000F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Direct Vertical Path (0,0) to (0,3)", test_num);
            reset_dut();
            start_x = 0; start_y = 0;
            goal_x = 0;  goal_y = 3;
            grid = 16'h0000;
            wait_cycles(100);
            #1;

            check_outputs(16'h1111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Simple Obstacle Avoidance", test_num);
            reset_dut();
            start_x = 0; start_y = 0;
            goal_x = 1;  goal_y = 1;
            grid = 16'b0000_0000_0000_0010;
            wait_cycles(100);
            #1;

            check_outputs(16'h0031);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Blocked Path", test_num);
            reset_dut();
            start_x = 0; start_y = 0;
            goal_x = 3;  goal_y = 3;

            grid = (1 << 14) | (1 << 11);
            wait_cycles(100);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Long detour path", test_num);
            reset_dut();
            start_x = 0; start_y = 0;
            goal_x = 3;  goal_y = 3;
            grid = 16'b0000_0000_0111_0000;
            wait_cycles(200);
            #1;

            check_outputs(16'h888F);
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
        input [15:0] expected_path;
        begin
            if (expected_path === (expected_path ^ path ^ expected_path)) begin
                $display("PASS");
                $display("  Outputs: path=%h",
                         path);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: path=%h",
                         expected_path);
                $display("  Got:      path=%h",
                         path);
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
        $dumpvars(0,clk, goal_x, goal_y, grid, rst, start_x, start_y, path);
    end

endmodule
