`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] apple_x;
    reg [7:0] apple_y;
    reg clk;
    reg rst;
    reg [7:0] snake;
    wire [11:0] color_out;
    wire hsync;
    wire vsync;
    wire [9:0] x_pos;
    wire [9:0] y_pos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .apple_x(apple_x),
        .apple_y(apple_y),
        .clk(clk),
        .rst(rst),
        .snake(snake),
        .color_out(color_out),
        .hsync(hsync),
        .vsync(vsync),
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
        rst = 1;
        apple_x = 8'd10;
        apple_y = 8'd10;
        snake = 8'd5;
        repeat(5) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Initial state after reset", test_num);
        reset_dut();



        #1;




        check_outputs(12'hXXX, 1'b1, 1'b1, 10'd0, 10'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Horizontal position increment", test_num);
        reset_dut();
        repeat(100) @(posedge clk);

        #1;


        check_outputs(12'hXXX, 1'b1, 1'b1, 10'd100, 10'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: HSYNC pulse activation", test_num);
        reset_dut();


        repeat(700) @(posedge clk);

        #1;


        check_outputs(12'h000, 1'b0, 1'b1, 10'd700, 10'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Line transition (Y position increment)", test_num);
        reset_dut();

        repeat(810) @(posedge clk);


        #1;



        check_outputs(12'hXXX, 1'b1, 1'b1, 10'd10, 10'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Rendering check at apple location", test_num);
        reset_dut();

        apple_x = 8'd20;
        apple_y = 8'd5;




        repeat(5 * 800 + 20) @(posedge clk);





        if (color_out !== 12'h000) begin
             $display("  Rendering detected at apple location: %h", color_out);
             pass_count = pass_count + 1;
        end else begin
             $display("  FAIL: No color detected at apple location");
             fail_count = fail_count + 1;
        end
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Blanking region color check", test_num);
        reset_dut();

        repeat(700) @(posedge clk);

        #1;


        check_outputs(12'h000, 1'b0, 1'b1, 10'd700, 10'd0);
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
        input [11:0] expected_color_out;
        input expected_hsync;
        input expected_vsync;
        input [9:0] expected_x_pos;
        input [9:0] expected_y_pos;
        begin
            if (expected_color_out === (expected_color_out ^ color_out ^ expected_color_out) &&
                expected_hsync === (expected_hsync ^ hsync ^ expected_hsync) &&
                expected_vsync === (expected_vsync ^ vsync ^ expected_vsync) &&
                expected_x_pos === (expected_x_pos ^ x_pos ^ expected_x_pos) &&
                expected_y_pos === (expected_y_pos ^ y_pos ^ expected_y_pos)) begin
                $display("PASS");
                $display("  Outputs: color_out=%h, hsync=%b, vsync=%b, x_pos=%h, y_pos=%h",
                         color_out, hsync, vsync, x_pos, y_pos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: color_out=%h, hsync=%b, vsync=%b, x_pos=%h, y_pos=%h",
                         expected_color_out, expected_hsync, expected_vsync, expected_x_pos, expected_y_pos);
                $display("  Got:      color_out=%h, hsync=%b, vsync=%b, x_pos=%h, y_pos=%h",
                         color_out, hsync, vsync, x_pos, y_pos);
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
        $dumpvars(0,apple_x, apple_y, clk, rst, snake, color_out, hsync, vsync, x_pos, y_pos);
    end

endmodule
