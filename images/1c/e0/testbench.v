`timescale 1ns/1ps

module rrt_pathfinder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] goal_x;
    reg [7:0] goal_y;
    reg [7:0] max_iterations;
    reg rst;
    reg [7:0] start_x;
    reg [7:0] start_y;
    wire path_found;
    wire [7:0] path_x;
    wire [7:0] path_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_pathfinder dut (
        .clk(clk),
        .goal_x(goal_x),
        .goal_y(goal_y),
        .max_iterations(max_iterations),
        .rst(rst),
        .start_x(start_x),
        .start_y(start_y),
        .path_found(path_found),
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
            rst = 1;
            start_x = 8'h0;
            start_y = 8'h0;
            goal_x = 8'h0;
            goal_y = 8'h0;
            max_iterations = 8'h0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Start equals Goal", test_num);
            reset_dut();

            start_x = 8'd100;
            start_y = 8'd100;
            goal_x = 8'd100;
            goal_y = 8'd100;
            max_iterations = 8'd5;


            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'd100, 8'd100);
        end
        endtask

    task testcase002;

        integer timeout;
        begin
            test_num = 2;
            $display("\nTestcase %0d: Simple Pathfinding", test_num);
            reset_dut();

            start_x = 8'd10;
            start_y = 8'd10;
            goal_x = 8'd20;
            goal_y = 8'd20;
            max_iterations = 8'd200;


            timeout = 0;
            while (!path_found && timeout < 500) begin
                @(posedge clk);
                timeout = timeout + 1;
            end

            #10;
            #1;

            check_outputs(1'b1, 8'd20, 8'd20);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Zero Iterations", test_num);
            reset_dut();

            start_x = 8'd10;
            start_y = 8'd10;
            goal_x = 8'd50;
            goal_y = 8'd50;
            max_iterations = 8'd0;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b0, 8'd0, 8'd0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("\nTestcase %0d: Insufficient Iterations for distance", test_num);
            reset_dut();

            start_x = 8'd0;
            start_y = 8'd0;
            goal_x = 8'd255;
            goal_y = 8'd255;
            max_iterations = 8'd2;


            repeat(20) @(posedge clk);

            #1;


            check_outputs(1'b0, 8'd0, 8'd0);
        end
        endtask

    task testcase005;

        integer timeout;
        begin
            test_num = 5;
            $display("\nTestcase %0d: Boundary Search (Origin to Max)", test_num);
            reset_dut();

            start_x = 8'h00;
            start_y = 8'h00;
            goal_x = 8'hFF;
            goal_y = 8'hFF;
            max_iterations = 8'hFF;

            timeout = 0;

            while (!path_found && timeout < 1000) begin
                @(posedge clk);
                timeout = timeout + 1;
            end

            #10;


            if (path_found)
                #1;

                check_outputs(1'b1, 8'hFF, 8'hFF);
            else
                #1;

                check_outputs(1'b0, 8'h00, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_pathfinder Testbench");
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
        input expected_path_found;
        input [7:0] expected_path_x;
        input [7:0] expected_path_y;
        begin
            if (expected_path_found === (expected_path_found ^ path_found ^ expected_path_found) &&
                expected_path_x === (expected_path_x ^ path_x ^ expected_path_x) &&
                expected_path_y === (expected_path_y ^ path_y ^ expected_path_y)) begin
                $display("PASS");
                $display("  Outputs: path_found=%b, path_x=%h, path_y=%h",
                         path_found, path_x, path_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: path_found=%b, path_x=%h, path_y=%h",
                         expected_path_found, expected_path_x, expected_path_y);
                $display("  Got:      path_found=%b, path_x=%h, path_y=%h",
                         path_found, path_x, path_y);
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
        $dumpvars(0,clk, goal_x, goal_y, max_iterations, rst, start_x, start_y, path_found, path_x, path_y);
    end

endmodule
