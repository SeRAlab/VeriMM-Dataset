`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dir;
    reg enable;
    reg rst;
    wire [31:0] cnt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dir(dir),
        .enable(enable),
        .rst(rst),
        .cnt(cnt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            enable = 0;
            dir = 0;
            @(negedge clk);
            #2;
            rst = 1;
            @(posedge clk);
        end
        endtask
    task sync_to_input_phase;

        begin
            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Basic Increment (10 cycles)");
            reset_dut();
            dir = 1;
            enable = 1;
            repeat (10) @(negedge clk);
            #1;
            #1;

            check_outputs(32'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Basic Decrement (Underflow)");
            reset_dut();
            dir = 0;
            enable = 1;
            repeat (1) @(negedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Enable Signal Gating");
            reset_dut();
            dir = 1;
            enable = 0;
            repeat (5) @(negedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Reversible Operation (Up then Down)");
            reset_dut();
            enable = 1;
            dir = 1;
            repeat (10) @(negedge clk);
            dir = 0;
            repeat (4) @(negedge clk);
            #1;
            #1;

            check_outputs(32'd6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Intermittent Enable");
            reset_dut();
            dir = 1;

            enable = 1; @(negedge clk);
            enable = 0; @(negedge clk);
            enable = 1; @(negedge clk);
            enable = 0; @(negedge clk);
            enable = 1; @(negedge clk);

            #1;
            #1;

            check_outputs(32'd3);
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
        input [31:0] expected_cnt;
        begin
            if (expected_cnt === (expected_cnt ^ cnt ^ expected_cnt)) begin
                $display("PASS");
                $display("  Outputs: cnt=%h",
                         cnt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cnt=%h",
                         expected_cnt);
                $display("  Got:      cnt=%h",
                         cnt);
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
        $dumpvars(0,clk, dir, enable, rst, cnt);
    end

endmodule
