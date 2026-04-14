`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enable;
    reg ld_seed;
    reg [7:0] seedData;
    wire [7:0] outData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable(enable),
        .ld_seed(ld_seed),
        .seedData(seedData),
        .outData(outData)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            enable = 0;
            ld_seed = 1;
            seedData = 8'h00;
            @(posedge clock);
            #1;
            ld_seed = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            ld_seed = 1;
            seedData = 8'hA5;
            @(posedge clock);
            #1;
            ld_seed = 0;
            $display("Testcase 001: Loading Seed 0xA5");
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            ld_seed = 1;
            seedData = 8'h5A;
            @(posedge clock);
            #1;
            ld_seed = 0;
            enable = 0;
            repeat(5) @(posedge clock);
            #1;
            $display("Testcase 002: Enable=0, checking if value held at 0x5A");
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            enable = 1;
            @(posedge clock);
            #1;
            $display("Testcase 003: Shift from 0x00 (Expected MSB 1 due to XNOR)");
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            ld_seed = 1;
            seedData = 8'hFF;
            enable = 1;
            @(posedge clock);
            #1;
            $display("Testcase 004: Load priority over Enable (Load 0xFF)");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            enable = 1;
            repeat(2) @(posedge clock);
            #1;
            $display("Testcase 005: Shifting twice from 0x00");
            #1;

            check_outputs(8'hC0);
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
        input [7:0] expected_outData;
        begin
            if (expected_outData === (expected_outData ^ outData ^ expected_outData)) begin
                $display("PASS");
                $display("  Outputs: outData=%h",
                         outData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outData=%h",
                         expected_outData);
                $display("  Got:      outData=%h",
                         outData);
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
        $dumpvars(0,clock, enable, ld_seed, seedData, outData);
    end

endmodule
