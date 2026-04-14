`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start;
    reg tone;
    wire buzzer;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .tone(tone),
        .buzzer(buzzer)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            tone = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            #100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            tone = 0;
            start = 1;
            #10;
            start = 0;

            #100000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            tone = 1;
            start = 1;
            #10;
            start = 0;
            #100000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            tone = 1;
            start = 1;
            #10;
            start = 0;
            #500;
            reset = 1;
            #20;
            #1;

            check_outputs(1'b0);
            reset = 0;
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            tone = 0;
            start = 1;
            #10;
            start = 0;
            #100000;

            tone = 1;
            start = 1;
            #10;
            start = 0;
            #100000;
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
        input expected_buzzer;
        begin
            if (expected_buzzer === (expected_buzzer ^ buzzer ^ expected_buzzer)) begin
                $display("PASS");
                $display("  Outputs: buzzer=%b",
                         buzzer);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: buzzer=%b",
                         expected_buzzer);
                $display("  Got:      buzzer=%b",
                         buzzer);
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
        $dumpvars(0,clk, reset, start, tone, buzzer);
    end

endmodule
