`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] bossHP;
    reg clk;
    reg [1:0] playerHP;
    reg rst;
    wire [1:0] gameState;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bossHP(bossHP),
        .clk(clk),
        .playerHP(playerHP),
        .rst(rst),
        .gameState(gameState)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            bossHP = 10'd500;
            playerHP = 2'd3;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boss HP Zero", test_num);
            reset_dut();
            bossHP = 10'd0;
            playerHP = 2'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Player HP Zero", test_num);
            reset_dut();
            bossHP = 10'd100;
            playerHP = 2'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Normal Play (Both Alive)", test_num);
            reset_dut();
            bossHP = 10'd10;
            playerHP = 2'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Return to Idle from Boss Defeat", test_num);
            reset_dut();

            bossHP = 0;
            @(posedge clk);

            bossHP = 10'd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition Boss Defeat to Player Defeat", test_num);
            reset_dut();
            bossHP = 0;
            playerHP = 3;
            @(posedge clk);

            bossHP = 10;
            playerHP = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sustained Player Defeat State", test_num);
            reset_dut();
            bossHP = 10'd500;
            playerHP = 2'd0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
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
        input [1:0] expected_gameState;
        begin
            if (expected_gameState === (expected_gameState ^ gameState ^ expected_gameState)) begin
                $display("PASS");
                $display("  Outputs: gameState=%h",
                         gameState);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gameState=%h",
                         expected_gameState);
                $display("  Got:      gameState=%h",
                         gameState);
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
        $dumpvars(0,bossHP, clk, playerHP, rst, gameState);
    end

endmodule
