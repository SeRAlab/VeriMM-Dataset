`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg ENABLE;
    reg [9:0] SYNCH_TIME;
    wire [9:0] PIXCOUNT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .ENABLE(ENABLE),
        .SYNCH_TIME(SYNCH_TIME),
        .PIXCOUNT(PIXCOUNT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            ENABLE = 0;
            SYNCH_TIME = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            ENABLE = 1;
            SYNCH_TIME = START_RANGE;

            repeat(10) begin
                @(posedge CLK);
                SYNCH_TIME = SYNCH_TIME + 1;
            end
            #1;
            $display("Testcase 001: Basic Counting");
            #1;

            check_outputs(10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            ENABLE = 1;
            SYNCH_TIME = START_RANGE;
            repeat(5) @(posedge CLK);
            SYNCH_TIME = END_RANGE + 1;
            @(posedge CLK);
            #1;
            $display("Testcase 002: Reset when out of range");
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            SYNCH_TIME = START_RANGE;
            ENABLE = 1;
            repeat(5) @(posedge CLK);
            ENABLE = 0;
            repeat(3) @(posedge CLK);
            #1;
            $display("Testcase 003: ENABLE signal gating");
            #1;

            check_outputs(5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            ENABLE = 1;
            SYNCH_TIME = START_RANGE - 1;
            @(posedge CLK);
            #1;
            if (PIXCOUNT !== 0) begin
                $display("Lower boundary failed at 143");
            end
            SYNCH_TIME = START_RANGE;
            @(posedge CLK);
            #1;
            $display("Testcase 004: Lower boundary transition");
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            ENABLE = 1;
            SYNCH_TIME = END_RANGE;
            @(posedge CLK);
            SYNCH_TIME = END_RANGE + 1;
            @(posedge CLK);
            #1;
            $display("Testcase 005: Upper boundary transition");
            #1;

            check_outputs(0);
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
        input [9:0] expected_PIXCOUNT;
        begin
            if (expected_PIXCOUNT === (expected_PIXCOUNT ^ PIXCOUNT ^ expected_PIXCOUNT)) begin
                $display("PASS");
                $display("  Outputs: PIXCOUNT=%h",
                         PIXCOUNT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PIXCOUNT=%h",
                         expected_PIXCOUNT);
                $display("  Got:      PIXCOUNT=%h",
                         PIXCOUNT);
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
        $dumpvars(0,CLK, ENABLE, SYNCH_TIME, PIXCOUNT);
    end

endmodule
