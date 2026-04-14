`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg rst;
    reg set_delay;
    reg set_sound;
    wire [7:0] delay_timer;
    wire [7:0] sound_timer;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .rst(rst),
        .set_delay(set_delay),
        .set_sound(set_sound),
        .delay_timer(delay_timer),
        .sound_timer(sound_timer)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data = 0;
            set_delay = 0;
            set_sound = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Load Delay Timer", test_num);
            reset_dut();
            @(posedge clk);
            data = 8'hA5;
            set_delay = 1;
            @(posedge clk);
            set_delay = 0;
            #1;
            #1;

            check_outputs(8'hA5, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Load Sound Timer", test_num);
            reset_dut();
            @(posedge clk);
            data = 8'h3C;
            set_sound = 1;
            @(posedge clk);
            set_sound = 0;
            #1;
            #1;

            check_outputs(8'h00, 8'h3C);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Sequential Load Both Timers", test_num);
            reset_dut();


            @(posedge clk);
            data = 8'h11;
            set_delay = 1;
            @(posedge clk);
            set_delay = 0;


            @(posedge clk);
            data = 8'hEE;
            set_sound = 1;
            @(posedge clk);
            set_sound = 0;

            #1;
            #1;

            check_outputs(8'h11, 8'hEE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Simultaneous Load", test_num);
            reset_dut();
            @(posedge clk);
            data = 8'hFF;
            set_delay = 1;
            set_sound = 1;
            @(posedge clk);
            set_delay = 0;
            set_sound = 0;
            #1;
            #1;

            check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Load Zero Value", test_num);
            reset_dut();

            @(posedge clk);
            data = 8'hAA;
            set_delay = 1;
            set_sound = 1;
            @(posedge clk);

            data = 8'h00;
            set_delay = 1;
            set_sound = 1;
            @(posedge clk);
            set_delay = 0;
            set_sound = 0;
            #1;
            #1;

            check_outputs(8'h00, 8'h00);
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
        input [7:0] expected_delay_timer;
        input [7:0] expected_sound_timer;
        begin
            if (expected_delay_timer === (expected_delay_timer ^ delay_timer ^ expected_delay_timer) &&
                expected_sound_timer === (expected_sound_timer ^ sound_timer ^ expected_sound_timer)) begin
                $display("PASS");
                $display("  Outputs: delay_timer=%h, sound_timer=%h",
                         delay_timer, sound_timer);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: delay_timer=%h, sound_timer=%h",
                         expected_delay_timer, expected_sound_timer);
                $display("  Got:      delay_timer=%h, sound_timer=%h",
                         delay_timer, sound_timer);
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
        $dumpvars(0,clk, data, rst, set_delay, set_sound, delay_timer, sound_timer);
    end

endmodule
