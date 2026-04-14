`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data;
    reg reset;
    wire parity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .reset(reset),
        .parity(parity)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        data = 0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Checking reset state...");
        reset_dut();
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Single '1' bit input...");
        reset_dut();
        @(posedge clk);
        data = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Two '1' bits (1 -> 1)...");
        reset_dut();
        @(posedge clk);
        data = 1;
        @(posedge clk);
        data = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Sequence 1, 0, 1, 1...");
        reset_dut();
        @(posedge clk);
        data = 1;
        @(posedge clk);
        data = 0;
        @(posedge clk);
        data = 1;
        @(posedge clk);
        data = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Sequence 1, 1, 0, 0...");
        reset_dut();
        @(posedge clk);
        data = 1;
        @(posedge clk);
        data = 1;
        @(posedge clk);
        data = 0;
        @(posedge clk);
        data = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Multiple '0' bits...");
        reset_dut();
        @(posedge clk);
        data = 0;
        @(posedge clk);
        data = 0;
        @(posedge clk);
        data = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Toggling sequence 1, 0, 1, 0, 1...");
        reset_dut();
        @(posedge clk);
        data = 1;
        @(posedge clk);
        data = 0;
        @(posedge clk);
        data = 1;
        @(posedge clk);
        data = 0;
        @(posedge clk);
        data = 1;
        @(posedge clk);
        #1;
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
        input expected_parity;
        begin
            if (expected_parity === (expected_parity ^ parity ^ expected_parity)) begin
                $display("PASS");
                $display("  Outputs: parity=%b",
                         parity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parity=%b",
                         expected_parity);
                $display("  Got:      parity=%b",
                         parity);
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
        $dumpvars(0,clk, data, reset, parity);
    end

endmodule
