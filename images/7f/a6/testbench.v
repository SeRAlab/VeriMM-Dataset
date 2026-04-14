`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg c;
    reg clk;
    reg d;
    reg si;
    reg sm;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c(c),
        .clk(clk),
        .d(d),
        .si(si),
        .sm(sm),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        c = 0;
        forever #5 c = ~c;
    end

        task reset_dut;

        begin
            d = 0;
            si = 0;
            sm = 0;
            clk = 1;
            @(posedge c);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            d = 1;
            si = 0;
            sm = 0;
            clk = 1;
            @(posedge c);
            #2;
            $display("Testcase 001: Load D=1");
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            d = 1; clk = 1; sm = 0; @(posedge c); #2;
            d = 0;
            @(posedge c);
            #2;
            $display("Testcase 002: Load D=0");
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            d = 0;
            si = 1;
            sm = 1;
            clk = 1;
            @(posedge c);
            #2;
            $display("Testcase 003: Load SI=1 (Scan Mode)");
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            d = 1; sm = 0; clk = 1;
            @(posedge c); #2;

            clk = 0;
            d = 0;
            @(posedge c);
            #2;
            $display("Testcase 004: Hold value (clk=0)");
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            d = 0;
            si = 1;
            sm = 1;
            clk = 1;
            @(posedge c);
            #2;
            $display("Testcase 005: SM selection priority (SI over D)");
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            d = 1; clk = 1; sm = 0; @(posedge c); #2;
            d = 1;
            si = 0;
            sm = 1;
            clk = 1;
            @(posedge c);
            #2;
            $display("Testcase 006: Load SI=0 while D=1");
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            d = 1; clk = 1; sm = 0; @(posedge c); #2;
            clk = 0;
            d = 0; si = 1; sm = 1;
            @(posedge c); #2;
            @(posedge c); #2;
            @(posedge c); #2;
            $display("Testcase 007: Hold value multiple cycles");
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
        testcase006();
        testcase007();
        
        
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
        input expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
                         q);
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
        $dumpvars(0,c, clk, d, si, sm, q);
    end

endmodule
