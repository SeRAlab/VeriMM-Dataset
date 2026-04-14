`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg trig;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .trig(trig),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            trig = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic pulse start");
            reset_dut();
            trig = 1;
            @(posedge clk);
            #1 trig = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Pulse duration (t=3)");
            reset_dut();
            trig = 1;
            @(posedge clk);
            #1 trig = 0;
            repeat (T_VAL - 1) @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Trigger ignored during pulse");
            reset_dut();
            trig = 1;
            @(posedge clk);
            #1 trig = 0;
            @(posedge clk);
            #1 trig = 1;
            @(posedge clk);
            #1 trig = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Long trigger signal");
            reset_dut();
            trig = 1;
            repeat (T_VAL + 2) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
            trig = 0;
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Reset during pulse");
            reset_dut();
            trig = 1;
            @(posedge clk);
            #1 trig = 0;
            @(posedge clk);
            #1 rst = 1;
            #1 #1;
 check_outputs(1'b0);
            rst = 0;
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Idle state");
            reset_dut();
            repeat (5) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
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
        input expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
        $dumpvars(0,clk, rst, trig, out);
    end

endmodule
