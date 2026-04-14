`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [2:0] load_val;
    reg reset;
    reg up_down;
    wire [2:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .load_val(load_val),
        .reset(reset),
        .up_down(up_down),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            up_down = 0;
            load_val = 3'b000;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Incrementing 3 times from zero");
            reset_dut();
            up_down = 1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Upward wrap-around (7 -> 0)");
            reset_dut();
            load_val = 3'd7;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            up_down = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Loading 5 and decrementing 2 times");
            reset_dut();
            load_val = 3'd5;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            up_down = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Downward wrap-around (0 -> 7)");
            reset_dut();
            up_down = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Checking full 3-bit cycle upward (8 steps)");
            reset_dut();
            up_down = 1;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Load priority over counting");
            reset_dut();
            up_down = 1;
            load_val = 3'd4;
            load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Reset priority over Load and Count");
            reset_dut();
            load_val = 3'd2;
            load = 1;
            up_down = 1;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0);
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
        input [2:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, load, load_val, reset, up_down, count);
    end

endmodule
