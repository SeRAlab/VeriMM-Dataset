`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg go;
    reg resetn;
    reg stop;
    wire move;
    wire start;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .go(go),
        .resetn(resetn),
        .stop(stop),
        .move(move),
        .start(start)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetn = 0;
            go = 0;
            stop = 0;
            repeat(2) @(posedge clk);
            #1;
            resetn = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #2;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(negedge clk) go = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(negedge clk) go = 1;
            @(posedge clk);
            @(negedge clk) go = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(negedge clk) go = 1;
            @(posedge clk);
            @(posedge clk);
            repeat(3) @(posedge clk);
            #2;

            #1;


            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(negedge clk) go = 1;
            @(posedge clk);
            @(posedge clk);
            @(negedge clk) stop = 1;
            @(posedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            @(negedge clk) go = 1;
            @(posedge clk);
            @(posedge clk);
            @(negedge clk) resetn = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0);
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
        input expected_move;
        input expected_start;
        begin
            if (expected_move === (expected_move ^ move ^ expected_move) &&
                expected_start === (expected_start ^ start ^ expected_start)) begin
                $display("PASS");
                $display("  Outputs: move=%b, start=%b",
                         move, start);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: move=%b, start=%b",
                         expected_move, expected_start);
                $display("  Got:      move=%b, start=%b",
                         move, start);
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
        $dumpvars(0,clk, go, resetn, stop, move, start);
    end

endmodule
