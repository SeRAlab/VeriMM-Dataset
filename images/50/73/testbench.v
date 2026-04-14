`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg fastclk;
    reg slowclk;
    wire firstedge;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .fastclk(fastclk),
        .slowclk(slowclk),
        .firstedge(firstedge)
    );

    // Clock generation (10ns period)
    initial begin
        fastclk = 0;
        forever #5 fastclk = ~fastclk;
    end

        task reset_dut;

        begin
            slowclk = 0;

            repeat(3) @(posedge fastclk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase 001: Detecting Rising Edge");

            @(posedge fastclk);
            slowclk = 1;



            @(negedge fastclk);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase 002: Detecting Falling Edge");


            slowclk = 1;
            repeat(2) @(posedge fastclk);


            @(posedge fastclk);
            slowclk = 0;

            @(negedge fastclk);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase 003: Steady State (Low)");

            slowclk = 0;
            repeat(4) @(posedge fastclk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase 004: Pulse Duration Verification");

            @(posedge fastclk);
            slowclk = 1;

            @(negedge fastclk);
            @(negedge fastclk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase 005: Steady State (High)");

            slowclk = 1;
            repeat(2) @(negedge fastclk);
            repeat(2) @(posedge fastclk);
            #2;
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
        input expected_firstedge;
        begin
            if (expected_firstedge === (expected_firstedge ^ firstedge ^ expected_firstedge)) begin
                $display("PASS");
                $display("  Outputs: firstedge=%b",
                         firstedge);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: firstedge=%b",
                         expected_firstedge);
                $display("  Got:      firstedge=%b",
                         firstedge);
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
        $dumpvars(0,fastclk, slowclk, firstedge);
    end

endmodule
