`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg b;
    reg clk;
    reg pause;
    reg reset;
    wire out;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .pause(pause),
        .reset(reset),
        .out(out),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            pause = 0;
            a = 0;
            b = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking Reset State");
            reset_dut();

            #1;


            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Counter Increment (1 Step)");
            reset_dut();
            pause = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'b1000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Counter Increment (2 Steps)");
            reset_dut();
            pause = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'b1100);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Pause and XOR Logic (1 ^ 0)");
            reset_dut();

            pause = 0;
            @(posedge clk);

            pause = 1;
            a = 1;
            b = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b1000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Pause and XOR Logic (1 ^ 1)");
            reset_dut();
            pause = 0;
            @(posedge clk);
            pause = 1;
            a = 1;
            b = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'b1000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Pause and XOR Logic (0 ^ 1)");
            reset_dut();
            pause = 1;
            a = 0;
            b = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Resuming Count after Pause");
            reset_dut();
            pause = 0;
            @(posedge clk);
            pause = 1;
            a = 1; b = 0;
            @(posedge clk);
            pause = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'b1100);
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
        input expected_out;
        input [3:0] expected_q;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: out=%b, q=%h",
                         out, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, q=%h",
                         expected_out, expected_q);
                $display("  Got:      out=%b, q=%h",
                         out, q);
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
        $dumpvars(0,a, b, clk, pause, reset, out, q);
    end

endmodule
