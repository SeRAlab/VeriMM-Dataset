`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] ball_x_in;
    reg [9:0] ball_y_in;
    reg [1:0] btn;
    reg clk;
    reg [9:0] pixel_x;
    reg reset;
    wire [9:0] ball_x;
    wire [9:0] ball_y;
    wire game_over;
    wire [9:0] paddle_x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ball_x_in(ball_x_in),
        .ball_y_in(ball_y_in),
        .btn(btn),
        .clk(clk),
        .pixel_x(pixel_x),
        .reset(reset),
        .ball_x(ball_x),
        .ball_y(ball_y),
        .game_over(game_over),
        .paddle_x(paddle_x)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        btn = 2'b00;
        ball_x_in = 10'd320;
        ball_y_in = 10'd240;
        pixel_x = 0;
        #20;
        reset = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        reset_dut();



        #1;




        check_outputs(10'd320, 10'd240, 1'b0, 10'd320);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        btn = 2'b10;
        repeat(10) @(posedge clk);
        btn = 2'b00;
        @(posedge clk);


        if (paddle_x > 320)
            #1;

            check_outputs(ball_x, ball_y, 1'b0, paddle_x);
        else
            #1;

            check_outputs(ball_x, ball_y, 1'b0, 10'd340);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        btn = 2'b01;
        repeat(10) @(posedge clk);
        btn = 2'b00;
        @(posedge clk);

        if (paddle_x < 320)
            #1;

            check_outputs(ball_x, ball_y, 1'b0, paddle_x);
        else
            #1;

            check_outputs(ball_x, ball_y, 1'b0, 10'd300);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        btn = 2'b01;
        repeat(200) @(posedge clk);
        btn = 2'b00;
        @(posedge clk);

        if (paddle_x >= 0 && paddle_x < 320)
            #1;

            check_outputs(ball_x, ball_y, 1'b0, paddle_x);
        else
            #1;

            check_outputs(ball_x, ball_y, 1'b0, 10'd0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();

        ball_x_in = 10'd320;
        ball_y_in = 10'd470;
        repeat(5) @(posedge clk);

        #1;


        check_outputs(ball_x, ball_y, 1'b1, paddle_x);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        ball_x_in = 10'd100;
        ball_y_in = 10'd150;
        repeat(1) @(posedge clk);
        #1;

        check_outputs(10'd100, 10'd150, 1'b0, paddle_x);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [9:0] expected_ball_x;
        input [9:0] expected_ball_y;
        input expected_game_over;
        input [9:0] expected_paddle_x;
        begin
            if (expected_ball_x === (expected_ball_x ^ ball_x ^ expected_ball_x) &&
                expected_ball_y === (expected_ball_y ^ ball_y ^ expected_ball_y) &&
                expected_game_over === (expected_game_over ^ game_over ^ expected_game_over) &&
                expected_paddle_x === (expected_paddle_x ^ paddle_x ^ expected_paddle_x)) begin
                $display("PASS");
                $display("  Outputs: ball_x=%h, ball_y=%h, game_over=%b, paddle_x=%h",
                         ball_x, ball_y, game_over, paddle_x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ball_x=%h, ball_y=%h, game_over=%b, paddle_x=%h",
                         expected_ball_x, expected_ball_y, expected_game_over, expected_paddle_x);
                $display("  Got:      ball_x=%h, ball_y=%h, game_over=%b, paddle_x=%h",
                         ball_x, ball_y, game_over, paddle_x);
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
        $dumpvars(0,ball_x_in, ball_y_in, btn, clk, pixel_x, reset, ball_x, ball_y, game_over, paddle_x);
    end

endmodule
