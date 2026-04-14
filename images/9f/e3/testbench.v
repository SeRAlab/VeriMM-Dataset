`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg HARD_ERROR;
    reg LANE_UP;
    reg POWER_DOWN;
    reg [1:0] SOFT_ERROR;
    reg USER_CLK;
    wire CHANNEL_HARD_ERROR;
    wire CHANNEL_SOFT_ERROR;
    wire RESET_CHANNEL;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .HARD_ERROR(HARD_ERROR),
        .LANE_UP(LANE_UP),
        .POWER_DOWN(POWER_DOWN),
        .SOFT_ERROR(SOFT_ERROR),
        .USER_CLK(USER_CLK),
        .CHANNEL_HARD_ERROR(CHANNEL_HARD_ERROR),
        .CHANNEL_SOFT_ERROR(CHANNEL_SOFT_ERROR),
        .RESET_CHANNEL(RESET_CHANNEL)
    );

    // Clock generation (10ns period)
    initial begin
        USER_CLK = 0;
        forever #5 USER_CLK = ~USER_CLK;
    end

        task reset_dut;

    begin
        SOFT_ERROR = 2'b00;
        HARD_ERROR = 1'b0;
        LANE_UP = 1'b1;
        POWER_DOWN = 1'b0;

        @(posedge USER_CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Running Testcase 001: Normal Operation");
        SOFT_ERROR = 2'b00;
        HARD_ERROR = 1'b0;
        LANE_UP = 1'b1;
        POWER_DOWN = 1'b0;
        @(posedge USER_CLK);
        #1;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Running Testcase 002: Soft Error [0]");
        SOFT_ERROR = 2'b01;
        HARD_ERROR = 1'b0;
        LANE_UP = 1'b1;
        POWER_DOWN = 1'b0;
        @(posedge USER_CLK);
        #1;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Running Testcase 003: Soft Error [1]");
        SOFT_ERROR = 2'b10;
        HARD_ERROR = 1'b0;
        LANE_UP = 1'b1;
        POWER_DOWN = 1'b0;
        @(posedge USER_CLK);
        #1;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Running Testcase 004: Hard Error");
        SOFT_ERROR = 2'b00;
        HARD_ERROR = 1'b1;
        LANE_UP = 1'b1;
        POWER_DOWN = 1'b0;
        @(posedge USER_CLK);
        #1;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Running Testcase 005: Lane Down Triggering Reset");
        SOFT_ERROR = 2'b00;
        HARD_ERROR = 1'b0;
        LANE_UP = 1'b0;
        POWER_DOWN = 1'b0;
        @(posedge USER_CLK);
        #1;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        $display("Running Testcase 006: Power Down Triggering Reset");
        SOFT_ERROR = 2'b00;
        HARD_ERROR = 1'b0;
        LANE_UP = 1'b1;
        POWER_DOWN = 1'b1;
        @(posedge USER_CLK);
        #1;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        $display("Running Testcase 007: Multiple Soft Errors");
        SOFT_ERROR = 2'b11;
        HARD_ERROR = 1'b0;
        LANE_UP = 1'b1;
        POWER_DOWN = 1'b0;
        @(posedge USER_CLK);
        #1;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        $display("Running Testcase 008: Simultaneous Hard Error and Reset");
        SOFT_ERROR = 2'b00;
        HARD_ERROR = 1'b1;
        LANE_UP = 1'b0;
        POWER_DOWN = 1'b1;
        @(posedge USER_CLK);
        #1;
        #1;

        check_outputs(1'b1, 1'b0, 1'b1);
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
        input expected_CHANNEL_HARD_ERROR;
        input expected_CHANNEL_SOFT_ERROR;
        input expected_RESET_CHANNEL;
        begin
            if (expected_CHANNEL_HARD_ERROR === (expected_CHANNEL_HARD_ERROR ^ CHANNEL_HARD_ERROR ^ expected_CHANNEL_HARD_ERROR) &&
                expected_CHANNEL_SOFT_ERROR === (expected_CHANNEL_SOFT_ERROR ^ CHANNEL_SOFT_ERROR ^ expected_CHANNEL_SOFT_ERROR) &&
                expected_RESET_CHANNEL === (expected_RESET_CHANNEL ^ RESET_CHANNEL ^ expected_RESET_CHANNEL)) begin
                $display("PASS");
                $display("  Outputs: CHANNEL_HARD_ERROR=%b, CHANNEL_SOFT_ERROR=%b, RESET_CHANNEL=%b",
                         CHANNEL_HARD_ERROR, CHANNEL_SOFT_ERROR, RESET_CHANNEL);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CHANNEL_HARD_ERROR=%b, CHANNEL_SOFT_ERROR=%b, RESET_CHANNEL=%b",
                         expected_CHANNEL_HARD_ERROR, expected_CHANNEL_SOFT_ERROR, expected_RESET_CHANNEL);
                $display("  Got:      CHANNEL_HARD_ERROR=%b, CHANNEL_SOFT_ERROR=%b, RESET_CHANNEL=%b",
                         CHANNEL_HARD_ERROR, CHANNEL_SOFT_ERROR, RESET_CHANNEL);
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
        $dumpvars(0,HARD_ERROR, LANE_UP, POWER_DOWN, SOFT_ERROR, USER_CLK, CHANNEL_HARD_ERROR, CHANNEL_SOFT_ERROR, RESET_CHANNEL);
    end

endmodule
