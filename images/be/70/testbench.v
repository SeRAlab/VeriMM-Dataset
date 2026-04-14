`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg run_game;
    wire compute;
    wire hold;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .run_game(run_game),
        .compute(compute),
        .hold(hold)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            run_game = 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            run_game = 1;

            repeat(4) @(posedge clk);

            @(posedge clk);
            #1;
            $display("Testcase 001: Run for 5 cycles - Checking if compute is activated");
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            run_game = 1;
            repeat(3) @(posedge clk);
            run_game = 0;
            @(posedge clk);
            #1;
            $display("Testcase 002: Deassert run_game - Checking if signals are cleared");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            run_game = 1;
            repeat(5) @(posedge clk);
            @(posedge clk);
            #1;
            $display("Testcase 003: Post-compute cycle - Checking if compute is cleared and counter resets");
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            run_game = 1;


            repeat(11) @(posedge clk);
            #1;
            $display("Testcase 004: Continuous run (2nd cycle) - Checking compute activation again");
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            run_game = 1;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase 005: Intermediate state - Checking hold is active and compute is inactive");
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_compute;
        input expected_hold;
        begin
            if (expected_compute === (expected_compute ^ compute ^ expected_compute) &&
                expected_hold === (expected_hold ^ hold ^ expected_hold)) begin
                $display("PASS");
                $display("  Outputs: compute=%b, hold=%b",
                         compute, hold);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compute=%b, hold=%b",
                         expected_compute, expected_hold);
                $display("  Got:      compute=%b, hold=%b",
                         compute, hold);
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
        $dumpvars(0,clk, run_game, compute, hold);
    end

endmodule
