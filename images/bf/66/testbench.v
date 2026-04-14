`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg reset;
    wire [12:0] rnd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .reset(reset),
        .rnd(rnd)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking reset state...", test_num);
            reset_dut();

            #1;


            check_outputs(13'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Checking output after 13 clock cycles...", test_num);
            reset_dut();
            repeat(13) @(posedge clock);
            #1;

            #1;


            check_outputs(13'h0401);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Checking output after 26 clock cycles...", test_num);
            reset_dut();
            repeat(26) @(posedge clock);
            #1;

            #1;


            check_outputs(13'h1A23);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verifying output does not change before 13 cycles...", test_num);
            reset_dut();
            repeat(12) @(posedge clock);
            #1;

            #1;


            check_outputs(13'h0001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verifying output hold between cycles 13 and 25...", test_num);
            reset_dut();
            repeat(20) @(posedge clock);
            #1;

            #1;


            check_outputs(13'h0401);
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
        input [12:0] expected_rnd;
        begin
            if (expected_rnd === (expected_rnd ^ rnd ^ expected_rnd)) begin
                $display("PASS");
                $display("  Outputs: rnd=%h",
                         rnd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rnd=%h",
                         expected_rnd);
                $display("  Got:      rnd=%h",
                         rnd);
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
        $dumpvars(0,clock, reset, rnd);
    end

endmodule
