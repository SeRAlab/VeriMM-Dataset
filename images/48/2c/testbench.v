`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    wire [2:0] t;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .t(t)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            d = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase 001: Synchronous Reset/Load to 1");
            reset_dut();
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase 002: Increment from 1 to 2");
            reset_dut();
            @(negedge clk); d = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase 003: Increment from 1 to 3");
            reset_dut();
            @(negedge clk); d = 0;
            repeat(2) @(posedge clk); #1;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase 004: Increment from 1 to 4");
            reset_dut();
            @(negedge clk); d = 0;
            repeat(3) @(posedge clk); #1;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase 005: Wrap-around from 4 to 0");
            reset_dut();
            @(negedge clk); d = 0;
            repeat(4) @(posedge clk); #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase 006: Complete cycle back to 1 (4->0->1)");
            reset_dut();
            @(negedge clk); d = 0;
            repeat(5) @(posedge clk); #1;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase 007: Multiple cycles (Reset + 7 pulses)");
            reset_dut();
            @(negedge clk); d = 0;
            repeat(7) @(posedge clk); #1;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase 008: Load 1 from state 3");
            reset_dut();
            @(negedge clk); d = 0;
            repeat(2) @(posedge clk);
            @(negedge clk); d = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase 009: Load 1 from state 0");
            reset_dut();
            @(negedge clk); d = 0;
            repeat(4) @(posedge clk);
            @(negedge clk); d = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase 010: Persistent Reset (d=1 for multiple cycles)");
            reset_dut();
            d = 1;
            repeat(3) @(posedge clk); #1;
            #1;

            check_outputs(3'd1);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [2:0] expected_t;
        begin
            if (expected_t === (expected_t ^ t ^ expected_t)) begin
                $display("PASS");
                $display("  Outputs: t=%h",
                         t);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: t=%h",
                         expected_t);
                $display("  Got:      t=%h",
                         t);
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
        $dumpvars(0,clk, d, t);
    end

endmodule
