`timescale 1ns/1ps

module a_star_pathfinding_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] current_x;
    reg [3:0] current_y;
    reg [15:0] obstacles;
    reg reset;
    reg [3:0] target_x;
    reg [3:0] target_y;
    wire [3:0] next_move_x;
    wire [3:0] next_move_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    a_star_pathfinding dut (
        .clk(clk),
        .current_x(current_x),
        .current_y(current_y),
        .obstacles(obstacles),
        .reset(reset),
        .target_x(target_x),
        .target_y(target_y),
        .next_move_x(next_move_x),
        .next_move_y(next_move_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            current_x = 0;
            current_y = 0;
            target_x = 0;
            target_y = 0;
            obstacles = 16'h0000;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Straight line move (Right)", test_num);
            current_x = 4'd0;
            current_y = 4'd0;
            target_x  = 4'd2;
            target_y  = 4'd0;
            obstacles = 16'h0000;

            repeat(20) @(posedge clk);
            #1;

            check_outputs(4'd1, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Straight line move (Down)", test_num);
            current_x = 4'd1;
            current_y = 4'd0;
            target_x  = 4'd1;
            target_y  = 4'd2;
            obstacles = 16'h0000;

            repeat(20) @(posedge clk);
            #1;

            check_outputs(4'd1, 4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Avoid obstacle at (1,0)", test_num);
            current_x = 4'd0;
            current_y = 4'd0;
            target_x  = 4'd2;
            target_y  = 4'd0;

            obstacles = 16'b0000_0000_0000_0010;

            repeat(20) @(posedge clk);
            #1;

            check_outputs(4'd0, 4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Target already reached", test_num);
            current_x = 4'd2;
            current_y = 4'd2;
            target_x  = 4'd2;
            target_y  = 4'd2;
            obstacles = 16'h0000;

            repeat(20) @(posedge clk);
            #1;

            check_outputs(4'd2, 4'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Corridor pathfinding", test_num);
            current_x = 4'd1;
            current_y = 4'd0;
            target_x  = 4'd1;
            target_y  = 4'd2;

            obstacles = (1 << 4) | (1 << 6);

            repeat(20) @(posedge clk);
            #1;

            check_outputs(4'd1, 4'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %0d: Diagonal step (0,0 to 1,1)", test_num);
            current_x = 4'd0;
            current_y = 4'd0;
            target_x  = 4'd1;
            target_y  = 4'd1;
            obstacles = 16'h0000;

            repeat(20) @(posedge clk);

            if (next_move_x == 4'd1 && next_move_y == 4'd0)
                #1;

                check_outputs(4'd1, 4'd0);
            else
                #1;

                check_outputs(4'd0, 4'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("a_star_pathfinding Testbench");
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
        input [3:0] expected_next_move_x;
        input [3:0] expected_next_move_y;
        begin
            if (expected_next_move_x === (expected_next_move_x ^ next_move_x ^ expected_next_move_x) &&
                expected_next_move_y === (expected_next_move_y ^ next_move_y ^ expected_next_move_y)) begin
                $display("PASS");
                $display("  Outputs: next_move_x=%h, next_move_y=%h",
                         next_move_x, next_move_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_move_x=%h, next_move_y=%h",
                         expected_next_move_x, expected_next_move_y);
                $display("  Got:      next_move_x=%h, next_move_y=%h",
                         next_move_x, next_move_y);
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
        $dumpvars(0,clk, current_x, current_y, obstacles, reset, target_x, target_y, next_move_x, next_move_y);
    end

endmodule
