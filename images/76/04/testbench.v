`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg HARD_ERR;
    reg LANE_UP;
    reg USER_CLK;
    wire CHANNEL_HARD_ERR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .HARD_ERR(HARD_ERR),
        .LANE_UP(LANE_UP),
        .USER_CLK(USER_CLK),
        .CHANNEL_HARD_ERR(CHANNEL_HARD_ERR)
    );

    // Clock generation (10ns period)
    initial begin
        USER_CLK = 0;
        forever #5 USER_CLK = ~USER_CLK;
    end

        task reset_dut;

    begin
        HARD_ERR = 0;
        LANE_UP = 0;
        @(posedge USER_CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Running Testcase 001: LANE_UP=1, HARD_ERR=1");
        LANE_UP = 1;
        HARD_ERR = 1;
        @(posedge USER_CLK);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Running Testcase 002: LANE_UP=1, HARD_ERR=0");
        LANE_UP = 1;
        HARD_ERR = 0;
        @(posedge USER_CLK);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Running Testcase 003: LANE_UP=0, HARD_ERR=1");
        LANE_UP = 0;
        HARD_ERR = 1;
        @(posedge USER_CLK);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Running Testcase 004: Recovery from Error (1->0) when LANE_UP is 1");

        LANE_UP = 1;
        HARD_ERR = 1;
        @(posedge USER_CLK);
        #1;

        HARD_ERR = 0;
        @(posedge USER_CLK);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Running Testcase 005: Verify registration on rising edge only");
        LANE_UP = 1;
        HARD_ERR = 1;
        #2;

        if (CHANNEL_HARD_ERR === 1'b0) begin
            @(posedge USER_CLK);
            #2;
            #1;

            check_outputs(1'b1);
        end else begin
            $display("FAIL: Output changed before clock edge");
            fail_count = fail_count + 1;
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
        input expected_CHANNEL_HARD_ERR;
        begin
            if (expected_CHANNEL_HARD_ERR === (expected_CHANNEL_HARD_ERR ^ CHANNEL_HARD_ERR ^ expected_CHANNEL_HARD_ERR)) begin
                $display("PASS");
                $display("  Outputs: CHANNEL_HARD_ERR=%b",
                         CHANNEL_HARD_ERR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CHANNEL_HARD_ERR=%b",
                         expected_CHANNEL_HARD_ERR);
                $display("  Got:      CHANNEL_HARD_ERR=%b",
                         CHANNEL_HARD_ERR);
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
        $dumpvars(0,HARD_ERR, LANE_UP, USER_CLK, CHANNEL_HARD_ERR);
    end

endmodule
