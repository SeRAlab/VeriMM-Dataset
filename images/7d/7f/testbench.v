`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg b;
    reg clk;
    reg reset;
    wire x;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .x(x),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset state S0...");
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Transition S0 -> S1 (a=1)...");
            reset_dut();
            a = 1; b = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Transition S1 -> S2 (b=1)...");
            reset_dut();

            a = 1; b = 0;
            @(posedge clk);

            #1 a = 0; b = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Full cycle S0 -> S1 -> S2 -> S0...");
            reset_dut();

            a = 1; b = 0; @(posedge clk);

            #1 a = 0; b = 1; @(posedge clk);

            #1 a = 1; b = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Input b=1 while in S0...");
            reset_dut();
            a = 0; b = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Reset while in S2...");
            reset_dut();
            a = 1; b = 0; @(posedge clk);
            #1 a = 0; b = 1; @(posedge clk);
            #1 reset = 1;
            @(posedge clk);
            #1 reset = 0;
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_x;
        input expected_y;
        begin
            if (expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: x=%b, y=%b",
                         x, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x=%b, y=%b",
                         expected_x, expected_y);
                $display("  Got:      x=%b, y=%b",
                         x, y);
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
        $dumpvars(0,a, b, clk, reset, x, y);
    end

endmodule
