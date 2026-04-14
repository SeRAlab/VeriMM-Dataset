`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg bsc;
    reg clk;
    reg reset;
    reg transmit_enable;
    wire char_sent;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bsc(bsc),
        .clk(clk),
        .reset(reset),
        .transmit_enable(transmit_enable),
        .char_sent(char_sent)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            transmit_enable = 0;
            bsc = 4'b0000;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset behavior");
            reset_dut();

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Trigger transition (TE=1, BSC!=1111)");
            reset_dut();
            @(posedge clk);
            transmit_enable = 1;
            bsc = 4'b1010;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: No transition (TE=0, BSC!=1111)");
            reset_dut();
            @(posedge clk);
            transmit_enable = 0;
            bsc = 4'b1010;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: No transition (TE=1, BSC=1111)");
            reset_dut();
            @(posedge clk);
            transmit_enable = 1;
            bsc = 4'b1111;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Delayed transition");
            reset_dut();
            @(posedge clk);
            transmit_enable = 1;
            bsc = 4'b1111;
            @(posedge clk);
            bsc = 4'b0001;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1);
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
        input expected_char_sent;
        begin
            if (expected_char_sent === (expected_char_sent ^ char_sent ^ expected_char_sent)) begin
                $display("PASS");
                $display("  Outputs: char_sent=%b",
                         char_sent);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: char_sent=%b",
                         expected_char_sent);
                $display("  Got:      char_sent=%b",
                         char_sent);
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
        $dumpvars(0,bsc, clk, reset, transmit_enable, char_sent);
    end

endmodule
