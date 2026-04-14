`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg hit_body;
    reg hit_wall;
    reg key1_press;
    reg key2_press;
    reg key3_press;
    reg key4_press;
    reg rst;
    wire die_flash;
    wire [1:0] game_status;
    wire restart;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .hit_body(hit_body),
        .hit_wall(hit_wall),
        .key1_press(key1_press),
        .key2_press(key2_press),
        .key3_press(key3_press),
        .key4_press(key4_press),
        .rst(rst),
        .die_flash(die_flash),
        .game_status(game_status),
        .restart(restart)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            hit_body = 0;
            hit_wall = 0;
            key1_press = 0;
            key2_press = 0;
            key3_press = 0;
            key4_press = 0;
            repeat(2) @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: START to PLAY via key1", test_num);
            reset_dut();

            key1_press = 1;
            @(posedge clk);
            key1_press = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(0, PLAY_ST, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: PLAY to DIE via hit_wall", test_num);
            reset_dut();

            key2_press = 1;
            @(posedge clk);
            key2_press = 0;
            @(posedge clk);

            hit_wall = 1;
            @(posedge clk);
            hit_wall = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1, DIE_ST, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: PLAY to DIE via hit_body", test_num);
            reset_dut();

            key3_press = 1;
            @(posedge clk);
            key3_press = 0;
            @(posedge clk);

            hit_body = 1;
            @(posedge clk);
            hit_body = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1, DIE_ST, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: DIE timeout to RESTART/START cycle", test_num);
            reset_dut();

            key4_press = 1;
            @(posedge clk);
            key4_press = 0;
            @(posedge clk);
            hit_wall = 1;
            @(posedge clk);
            hit_wall = 0;



            repeat(100) @(posedge clk);



            if (game_status == START_ST || restart == 1)
                #1;

                check_outputs(0, game_status, restart);
            else
                #1;

                check_outputs(0, START_ST, 1);
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
        input expected_die_flash;
        input [1:0] expected_game_status;
        input expected_restart;
        begin
            if (expected_die_flash === (expected_die_flash ^ die_flash ^ expected_die_flash) &&
                expected_game_status === (expected_game_status ^ game_status ^ expected_game_status) &&
                expected_restart === (expected_restart ^ restart ^ expected_restart)) begin
                $display("PASS");
                $display("  Outputs: die_flash=%b, game_status=%h, restart=%b",
                         die_flash, game_status, restart);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: die_flash=%b, game_status=%h, restart=%b",
                         expected_die_flash, expected_game_status, expected_restart);
                $display("  Got:      die_flash=%b, game_status=%h, restart=%b",
                         die_flash, game_status, restart);
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
        $dumpvars(0,clk, hit_body, hit_wall, key1_press, key2_press, key3_press, key4_press, rst, die_flash, game_status, restart);
    end

endmodule
