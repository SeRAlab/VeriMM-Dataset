`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enable;
    reg middle;
    reg [5:0] radius;
    reg reset;
    reg rotary_event;
    reg rotary_right;
    reg [4:0] speed;
    wire [9:0] paddle_x;
    wire [9:0] paddle_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable(enable),
        .middle(middle),
        .radius(radius),
        .reset(reset),
        .rotary_event(rotary_event),
        .rotary_right(rotary_right),
        .speed(speed),
        .paddle_x(paddle_x),
        .paddle_y(paddle_y)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            middle = 0;
            radius = 6'd10;
            speed = 5'd5;
            rotary_event = 0;
            rotary_right = 0;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            middle = 0;
            @(posedge clock);
            #1;

            check_outputs(10'd320, 10'd440);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            middle = 1;
            @(posedge clock);
            #1;

            check_outputs(10'd320, 10'd240);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            enable = 1;
            speed = 5'd5;
            rotary_right = 1;

            repeat(3) begin
                rotary_event = 1;
                @(posedge clock);
                rotary_event = 0;
                @(posedge clock);
            end

            #1;


            check_outputs(10'd335, 10'd440);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            enable = 1;
            speed = 5'd10;
            rotary_right = 0;

            repeat(4) begin
                rotary_event = 1;
                @(posedge clock);
                rotary_event = 0;
                @(posedge clock);
            end

            #1;


            check_outputs(10'd280, 10'd440);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            radius = 6'd20;
            enable = 1;
            speed = 5'd30;
            rotary_right = 1;


            repeat(20) begin
                rotary_event = 1;
                @(posedge clock);
                rotary_event = 0;
                @(posedge clock);
            end

            #1;


            check_outputs(10'd619, 10'd440);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            radius = 6'd15;
            enable = 1;
            speed = 5'd31;
            rotary_right = 0;


            repeat(20) begin
                rotary_event = 1;
                @(posedge clock);
                rotary_event = 0;
                @(posedge clock);
            end

            #1;


            check_outputs(10'd15, 10'd440);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            enable = 0;
            speed = 5'd10;
            rotary_right = 1;

            repeat(5) begin
                rotary_event = 1;
                @(posedge clock);
                rotary_event = 0;
                @(posedge clock);
            end

            #1;


            check_outputs(10'd320, 10'd440);
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
        input [9:0] expected_paddle_x;
        input [9:0] expected_paddle_y;
        begin
            if (expected_paddle_x === (expected_paddle_x ^ paddle_x ^ expected_paddle_x) &&
                expected_paddle_y === (expected_paddle_y ^ paddle_y ^ expected_paddle_y)) begin
                $display("PASS");
                $display("  Outputs: paddle_x=%h, paddle_y=%h",
                         paddle_x, paddle_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: paddle_x=%h, paddle_y=%h",
                         expected_paddle_x, expected_paddle_y);
                $display("  Got:      paddle_x=%h, paddle_y=%h",
                         paddle_x, paddle_y);
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
        $dumpvars(0,clock, enable, middle, radius, reset, rotary_event, rotary_right, speed, paddle_x, paddle_y);
    end

endmodule
