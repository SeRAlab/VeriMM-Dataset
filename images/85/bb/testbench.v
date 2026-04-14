`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enable;
    reg [7:0] rate;
    reg reset;
    wire sync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable(enable),
        .rate(rate),
        .reset(reset),
        .sync(sync)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            rate = 0;
            @(posedge clock);
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Checking Reset State");
            reset_dut();

            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Rate=3, Enable=1, Wait 4 cycles for sync");
            reset_dut();
            rate = 8'd3;
            enable = 1'b1;





            repeat(4) @(posedge clock);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Rate=3, Enable=1, Wait 2 cycles (should be low)");
            reset_dut();
            rate = 8'd3;
            enable = 1'b1;
            repeat(2) @(posedge clock);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Rate=3, Enable=0, Pulse should not occur");
            reset_dut();
            rate = 8'd3;
            enable = 1'b0;
            repeat(10) @(posedge clock);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Rate=0 (Sync every cycle)");
            reset_dut();
            rate = 8'd0;
            enable = 1'b1;
            @(posedge clock);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Changing rate from 10 to 2");
            reset_dut();
            rate = 8'd10;
            enable = 1'b1;
            repeat(3) @(posedge clock);
            rate = 8'd2;


            @(posedge clock);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Rate=10, Wait 11 cycles");
            reset_dut();
            rate = 8'd10;
            enable = 1'b1;
            repeat(11) @(posedge clock);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase 008: Toggling enable mid-count");
            reset_dut();
            rate = 8'd5;
            enable = 1'b1;
            repeat(2) @(posedge clock);
            enable = 1'b0;
            repeat(5) @(posedge clock);
            enable = 1'b1;
            repeat(3) @(posedge clock);
            #1 #1;
 check_outputs(1'b1);
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
        input expected_sync;
        begin
            if (expected_sync === (expected_sync ^ sync ^ expected_sync)) begin
                $display("PASS");
                $display("  Outputs: sync=%b",
                         sync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sync=%b",
                         expected_sync);
                $display("  Got:      sync=%b",
                         sync);
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
        $dumpvars(0,clock, enable, rate, reset, sync);
    end

endmodule
