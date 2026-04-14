`timescale 1ns/1ps

module robot_slam_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] direction;
    reg reset;
    wire [7:0] x_pos;
    wire [7:0] y_pos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    robot_slam_fsm dut (
        .clk(clk),
        .direction(direction),
        .reset(reset),
        .x_pos(x_pos),
        .y_pos(y_pos)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            direction = 2'b00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial Reset Position", test_num);
            reset_dut();
            #1;

            check_outputs(8'd0, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Move UP and RIGHT", test_num);
            reset_dut();
            direction = DIR_UP;
            @(posedge clk);
            direction = DIR_RIGHT;
            @(posedge clk);
            #1;

            check_outputs(8'd1, 8'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Square Path (UP, RIGHT, DOWN, LEFT)", test_num);
            reset_dut();
            direction = DIR_UP;
            @(posedge clk);
            direction = DIR_RIGHT;
            @(posedge clk);
            direction = DIR_DOWN;
            @(posedge clk);
            direction = DIR_LEFT;
            @(posedge clk);
            #1;

            check_outputs(8'd0, 8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Negative Coordinates (-1, -2)", test_num);
            reset_dut();
            direction = DIR_DOWN;
            repeat(2) @(posedge clk);
            direction = DIR_LEFT;
            @(posedge clk);
            #1;

            check_outputs(8'hFF, 8'hFE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Long Path to (5, 3)", test_num);
            reset_dut();
            direction = DIR_RIGHT;
            repeat(5) @(posedge clk);
            direction = DIR_UP;
            repeat(3) @(posedge clk);
            #1;

            check_outputs(8'd5, 8'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("robot_slam_fsm Testbench");
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
        input [7:0] expected_x_pos;
        input [7:0] expected_y_pos;
        begin
            if (expected_x_pos === (expected_x_pos ^ x_pos ^ expected_x_pos) &&
                expected_y_pos === (expected_y_pos ^ y_pos ^ expected_y_pos)) begin
                $display("PASS");
                $display("  Outputs: x_pos=%h, y_pos=%h",
                         x_pos, y_pos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_pos=%h, y_pos=%h",
                         expected_x_pos, expected_y_pos);
                $display("  Got:      x_pos=%h, y_pos=%h",
                         x_pos, y_pos);
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
        $dumpvars(0,clk, direction, reset, x_pos, y_pos);
    end

endmodule
