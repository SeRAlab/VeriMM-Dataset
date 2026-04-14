`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg enable;
    reg fb_clk;
    reg ref_clk;
    reg reset;
    wire [7:0] delay;
    wire locked;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .fb_clk(fb_clk),
        .ref_clk(ref_clk),
        .reset(reset),
        .delay(delay),
        .locked(locked)
    );

    // Clock generation (10ns period)
    initial begin
        fb_clk = 0;
        forever #5 fb_clk = ~fb_clk;
    end

        task reset_dut;

    begin
        reset = 1;
        enable = 0;
        phase_delay = 0;
        #20;
        reset = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Reset Initialization");
        reset_dut();
        test_num = test_num + 1;

        #1;


        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Aligned Clocks (Locking)");
        reset_dut();
        test_num = test_num + 1;
        enable = 1;
        phase_delay = 0;
        #100;
        #1;

        check_outputs(delay, 1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Enable Disabled with Phase Error");
        reset_dut();
        test_num = test_num + 1;
        enable = 0;
        phase_delay = 2.0;
        #100;

        #1;


        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Reference Clock Lags (Ref after FB)");
        reset_dut();
        test_num = test_num + 1;
        enable = 1;
        phase_delay = 1.0;
        #100;

        if (delay != 8'h00 && locked == 1'b0) begin
            pass_count = pass_count + 1;
            $display("PASS: Delay adjusted to %h", delay);
        end else begin
            fail_count = fail_count + 1;
            $display("FAIL: Delay=%h, Locked=%b", delay, locked);
        end
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Reference Clock Leads (Ref before FB)");
        reset_dut();
        test_num = test_num + 1;
        enable = 1;
        phase_delay = 9.0;
        #100;

        if (delay != 8'h00 && locked == 1'b0) begin
            pass_count = pass_count + 1;
            $display("PASS: Delay adjusted to %h", delay);
        end else begin
            fail_count = fail_count + 1;
            $display("FAIL: Delay=%h, Locked=%b", delay, locked);
        end
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
        input [7:0] expected_delay;
        input expected_locked;
        begin
            if (expected_delay === (expected_delay ^ delay ^ expected_delay) &&
                expected_locked === (expected_locked ^ locked ^ expected_locked)) begin
                $display("PASS");
                $display("  Outputs: delay=%h, locked=%b",
                         delay, locked);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: delay=%h, locked=%b",
                         expected_delay, expected_locked);
                $display("  Got:      delay=%h, locked=%b",
                         delay, locked);
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
        $dumpvars(0,enable, fb_clk, ref_clk, reset, delay, locked);
    end

endmodule
