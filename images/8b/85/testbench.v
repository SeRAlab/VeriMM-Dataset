`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg touch_signal;
    wire touched;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .touch_signal(touch_signal),
        .touched(touched)
    );

        task reset_dut;

        begin
            rst_n = 0;
            touch_signal = 0;
            repeat(5) @(posedge clk);
            rst_n = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Initial State Check...");
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Glitch Rejection (Short High)...");
            reset_dut();
            @(posedge clk);
            touch_signal = 1;
            repeat(3) @(posedge clk);
            touch_signal = 0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Valid Touch Detection...");
            reset_dut();
            @(posedge clk);
            touch_signal = 1;
            repeat(30) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Glitch Rejection (Short Low during Active)...");
            reset_dut();
            @(posedge clk);
            touch_signal = 1;
            repeat(30) @(posedge clk);


            touch_signal = 0;
            repeat(3) @(posedge clk);
            touch_signal = 1;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Touch Release Detection...");
            reset_dut();
            @(posedge clk);
            touch_signal = 1;
            repeat(30) @(posedge clk);

            touch_signal = 0;
            repeat(30) @(posedge clk);
            #1;

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
        input expected_touched;
        begin
            if (expected_touched === (expected_touched ^ touched ^ expected_touched)) begin
                $display("PASS");
                $display("  Outputs: touched=%b",
                         touched);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: touched=%b",
                         expected_touched);
                $display("  Got:      touched=%b",
                         touched);
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
        $dumpvars(0,touch_signal, touched);
    end

endmodule
