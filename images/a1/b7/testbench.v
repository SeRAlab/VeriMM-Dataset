`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg finish;
    reg reset_n;
    reg win;
    wire game_over;
    wire game_won;
    wire [4:0] level;
    wire [4:0] life;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .finish(finish),
        .reset_n(reset_n),
        .win(win),
        .game_over(game_over),
        .game_won(game_won),
        .level(level),
        .life(life)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            finish = 0;
            win = 0;
            @(posedge clk);
            #1 reset_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Initial State (Reset)");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 0, 5'd1, 5'd3);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Win Level 1 (Advance to Level 2)");
            test_num = 2;
            reset_dut();
            finish = 1;
            win = 1;
            @(posedge clk);
            #1 finish = 0; win = 0;

            #1;


            check_outputs(0, 0, 5'd2, 5'd3);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Lose Level 1 (Life Decr)");
            test_num = 3;
            reset_dut();
            finish = 1;
            win = 0;
            @(posedge clk);
            #1 finish = 0;

            #1;


            check_outputs(0, 0, 5'd1, 5'd2);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Lose all lives (Game Over)");
            test_num = 4;
            reset_dut();

            repeat(3) begin
                finish = 1; win = 0;
                @(posedge clk);
                #1 finish = 0;
            end

            #1;


            check_outputs(1, 0, 5'd1, 5'd0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Running Testcase 005: Win Level 10 (Game Won)");
            test_num = 5;
            reset_dut();

            for(i = 1; i <= 9; i = i + 1) begin
                finish = 1; win = 1;
                @(posedge clk);
                #1;
            end

            finish = 1; win = 1;
            @(posedge clk);
            #1 finish = 0; win = 0;

            #1;


            check_outputs(0, 1, 5'd10, 5'd3);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Restore Life on Level Up");
            test_num = 6;
            reset_dut();

            finish = 1; win = 0;
            @(posedge clk);
            #1 finish = 0;

            finish = 1; win = 1;
            @(posedge clk);
            #1 finish = 0; win = 0;

            #1;


            check_outputs(0, 0, 5'd2, 5'd3);
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
        input expected_game_over;
        input expected_game_won;
        input [4:0] expected_level;
        input [4:0] expected_life;
        begin
            if (expected_game_over === (expected_game_over ^ game_over ^ expected_game_over) &&
                expected_game_won === (expected_game_won ^ game_won ^ expected_game_won) &&
                expected_level === (expected_level ^ level ^ expected_level) &&
                expected_life === (expected_life ^ life ^ expected_life)) begin
                $display("PASS");
                $display("  Outputs: game_over=%b, game_won=%b, level=%h, life=%h",
                         game_over, game_won, level, life);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: game_over=%b, game_won=%b, level=%h, life=%h",
                         expected_game_over, expected_game_won, expected_level, expected_life);
                $display("  Got:      game_over=%b, game_won=%b, level=%h, life=%h",
                         game_over, game_won, level, life);
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
        $dumpvars(0,clk, finish, reset_n, win, game_over, game_won, level, life);
    end

endmodule
