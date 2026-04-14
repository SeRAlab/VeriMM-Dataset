`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg reset;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .reset(reset)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(posedge clock);
            reset = 1;
            repeat(2) @(posedge clock);
            reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Reset State");
            reset_dut();

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Short Count (10 cycles)");
            reset_dut();
            repeat(10) @(posedge clock);
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Max Value (255)");
            reset_dut();
            repeat(255) @(posedge clock);
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Wrap-around logic");
            reset_dut();
            repeat(256) @(posedge clock);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Post wrap-around count");
            reset_dut();
            repeat(300) @(posedge clock);

            #1;


            check_outputs(8'd44);
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
        begin
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
        $dumpvars(0,clock, reset);
    end

endmodule
