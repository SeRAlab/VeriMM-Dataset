`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    reg START;
    wire [2:0] NUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RST(RST),
        .START(START),
        .NUM(NUM)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            START = 0;
            @(posedge CLK);
            #1;
            RST = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Initialization Check");
            reset_dut();
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Basic Sequence Increment");
            reset_dut();
            START = 1;
            @(posedge CLK);
            @(posedge CLK);
            #1;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: START Signal Gate Check");
            reset_dut();
            START = 0;
            repeat(4) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Wrap-around Logic (5 -> 0)");
            reset_dut();
            START = 1;
            repeat(6) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Pause and Resume Logic");
            reset_dut();
            START = 1;
            repeat(3) @(posedge CLK);
            START = 0;
            repeat(2) @(posedge CLK);
            START = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(3'd4);
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
        input [2:0] expected_NUM;
        begin
            if (expected_NUM === (expected_NUM ^ NUM ^ expected_NUM)) begin
                $display("PASS");
                $display("  Outputs: NUM=%h",
                         NUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: NUM=%h",
                         expected_NUM);
                $display("  Got:      NUM=%h",
                         NUM);
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
        $dumpvars(0,CLK, RST, START, NUM);
    end

endmodule
