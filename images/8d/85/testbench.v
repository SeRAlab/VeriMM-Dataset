`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg BOOT;
    reg S0;
    reg S1;
    reg clk;
    wire VALID;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BOOT(BOOT),
        .S0(S0),
        .S1(S1),
        .clk(clk),
        .VALID(VALID)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            BOOT = 1;
            S1 = 0;
            S0 = 0;
            @(posedge clk);
            #1;
            BOOT = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Resetting to STATE_0...");
            reset_dut();

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Transitioning with S0=1, S1=0...");
            reset_dut();
            S1 = 0; S0 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Transitioning with S0=0, S1=1...");
            reset_dut();
            S1 = 1; S0 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Transitioning with S0=1, S1=1...");
            reset_dut();
            S1 = 1; S0 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Running multiple clock cycles to traverse states...");
            reset_dut();

            S1 = 0; S0 = 1; @(posedge clk); #1;
            S1 = 1; S0 = 0; @(posedge clk); #1;
            S1 = 1; S0 = 1; @(posedge clk); #1;
            S1 = 0; S0 = 0; @(posedge clk); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Asserting BOOT signal during state sequence...");
            reset_dut();
            S1 = 1; S0 = 1;
            @(posedge clk); #1;
            @(posedge clk); #1;

            BOOT = 1;
            @(posedge clk); #1;
            BOOT = 0;
            #1;

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
        input expected_VALID;
        begin
            if (expected_VALID === (expected_VALID ^ VALID ^ expected_VALID)) begin
                $display("PASS");
                $display("  Outputs: VALID=%b",
                         VALID);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: VALID=%b",
                         expected_VALID);
                $display("  Got:      VALID=%b",
                         VALID);
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
        $dumpvars(0,BOOT, S0, S1, clk, VALID);
    end

endmodule
