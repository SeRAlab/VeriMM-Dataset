`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg local_clk;
    reg ref_clk;
    reg reset;
    wire adj_clk;
    wire locked;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .local_clk(local_clk),
        .ref_clk(ref_clk),
        .reset(reset),
        .adj_clk(adj_clk),
        .locked(locked)
    );

    // Clock generation (10ns period)
    initial begin
        ref_clk = 0;
        forever #5 ref_clk = ~ref_clk;
    end

        task reset_dut;

        begin
            reset = 1;
            #100;
            reset = 0;
            #100;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Zero Phase Offset Alignment");
            phase_delay_ns = 0;
            local_clk_en = 1;
            reset_dut();


            #5000;


            @(posedge ref_clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: 2.5ns (90 deg) Phase Lag");
            phase_delay_ns = 2.5;
            local_clk_en = 1;
            reset_dut();

            #10000;

            @(posedge ref_clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: 5.0ns (180 deg) Phase Lag");
            phase_delay_ns = 5.0;
            local_clk_en = 1;
            reset_dut();

            #10000;

            @(posedge ref_clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: 8.0ns (288 deg) Phase Lag");
            phase_delay_ns = 8.0;
            local_clk_en = 1;
            reset_dut();

            #15000;

            @(posedge ref_clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Lock loss on Reset");
            phase_delay_ns = 1.0;
            local_clk_en = 1;
            reset_dut();
            #2000;

            reset = 1;
            #100;

            #1;


            check_outputs(adj_clk, 1'b0);
            reset = 0;
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
        input expected_adj_clk;
        input expected_locked;
        begin
            if (expected_adj_clk === (expected_adj_clk ^ adj_clk ^ expected_adj_clk) &&
                expected_locked === (expected_locked ^ locked ^ expected_locked)) begin
                $display("PASS");
                $display("  Outputs: adj_clk=%b, locked=%b",
                         adj_clk, locked);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adj_clk=%b, locked=%b",
                         expected_adj_clk, expected_locked);
                $display("  Got:      adj_clk=%b, locked=%b",
                         adj_clk, locked);
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
        $dumpvars(0,local_clk, ref_clk, reset, adj_clk, locked);
    end

endmodule
