`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    wire clk_moving_obs;
    wire clk_player;
    wire dclk;
    wire segclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .clk_moving_obs(clk_moving_obs),
        .clk_player(clk_player),
        .dclk(dclk),
        .segclk(segclk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            clr = 1;
            repeat(2) @(posedge clk);
            #1 clr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Initial state check", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: dclk toggle check (Cycle 1)", test_num);
            reset_dut();

            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: dclk toggle check (Cycle 2)", test_num);
            reset_dut();
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: segclk toggle check (2^16 cycles)", test_num);
            reset_dut();

            repeat(65536) @(posedge clk);
            #1;


            #1;



            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Mid-operation reset check", test_num);
            reset_dut();

            repeat(65536) @(posedge clk);
            #1;
            if (segclk !== 1'b1) begin
                $display("Prerequisite Failed: segclk did not go high");
                fail_count = fail_count + 1;
            end else begin

                clr = 1;
                repeat(2) @(posedge clk);
                #1;

                #1;


                check_outputs(0, 0, 0, 0);
                clr = 0;
            end
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Slow clock inactivity check", test_num);
            reset_dut();

            repeat(10000) @(posedge clk);
            #1;



            #1;




            check_outputs(0, 0, 0, 0);
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
        input expected_clk_moving_obs;
        input expected_clk_player;
        input expected_dclk;
        input expected_segclk;
        begin
            if (expected_clk_moving_obs === (expected_clk_moving_obs ^ clk_moving_obs ^ expected_clk_moving_obs) &&
                expected_clk_player === (expected_clk_player ^ clk_player ^ expected_clk_player) &&
                expected_dclk === (expected_dclk ^ dclk ^ expected_dclk) &&
                expected_segclk === (expected_segclk ^ segclk ^ expected_segclk)) begin
                $display("PASS");
                $display("  Outputs: clk_moving_obs=%b, clk_player=%b, dclk=%b, segclk=%b",
                         clk_moving_obs, clk_player, dclk, segclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_moving_obs=%b, clk_player=%b, dclk=%b, segclk=%b",
                         expected_clk_moving_obs, expected_clk_player, expected_dclk, expected_segclk);
                $display("  Got:      clk_moving_obs=%b, clk_player=%b, dclk=%b, segclk=%b",
                         clk_moving_obs, clk_player, dclk, segclk);
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
        $dumpvars(0,clk, clr, clk_moving_obs, clk_player, dclk, segclk);
    end

endmodule
