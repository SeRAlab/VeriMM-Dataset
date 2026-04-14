`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLOCK;
    reg RESET;
    reg [11:0] x;
    reg [11:0] y;
    wire [11:0] DIFF;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLOCK(CLOCK),
        .RESET(RESET),
        .x(x),
        .y(y),
        .DIFF(DIFF)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCK = 0;
        forever #5 CLOCK = ~CLOCK;
    end

        task reset_dut;

    begin
        RESET = 1;
        x = 0;
        y = 0;
        @(posedge CLOCK);
        #1;
        RESET = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: x > y (x=100, y=40)", test_num);
        reset_dut();
        x = 12'd100;
        y = 12'd40;
        @(posedge CLOCK);
        #1;
        #1;

        check_outputs(12'd60);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: x < y (x=50, y=150)", test_num);
        reset_dut();
        x = 12'd50;
        y = 12'd150;
        @(posedge CLOCK);
        #1;
        #1;

        check_outputs(12'd100);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: x == y (x=2048, y=2048)", test_num);
        reset_dut();
        x = 12'd2048;
        y = 12'd2048;
        @(posedge CLOCK);
        #1;
        #1;

        check_outputs(12'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Max value and 0 (x=4095, y=0)", test_num);
        reset_dut();
        x = 12'hFFF;
        y = 12'd0;
        @(posedge CLOCK);
        #1;
        #1;

        check_outputs(12'hFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: 0 and Max value (x=0, y=4095)", test_num);
        reset_dut();
        x = 12'd0;
        y = 12'hFFF;
        @(posedge CLOCK);
        #1;
        #1;

        check_outputs(12'hFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Minimum difference x > y (x=1, y=0)", test_num);
        reset_dut();
        x = 12'd1;
        y = 12'd0;
        @(posedge CLOCK);
        #1;
        #1;

        check_outputs(12'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Minimum difference x < y (x=4094, y=4095)", test_num);
        reset_dut();
        x = 12'd4094;
        y = 12'd4095;
        @(posedge CLOCK);
        #1;
        #1;

        check_outputs(12'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Large values (x=3000, y=1000)", test_num);
        reset_dut();
        x = 12'd3000;
        y = 12'd1000;
        @(posedge CLOCK);
        #1;
        #1;

        check_outputs(12'd2000);
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
        input [11:0] expected_DIFF;
        begin
            if (expected_DIFF === (expected_DIFF ^ DIFF ^ expected_DIFF)) begin
                $display("PASS");
                $display("  Outputs: DIFF=%h",
                         DIFF);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DIFF=%h",
                         expected_DIFF);
                $display("  Got:      DIFF=%h",
                         DIFF);
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
        $dumpvars(0,CLOCK, RESET, x, y, DIFF);
    end

endmodule
