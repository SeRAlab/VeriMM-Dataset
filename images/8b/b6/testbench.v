`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg bit_in;
    reg clk;
    reg reset;
    wire [4:0] shift_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bit_in(bit_in),
        .clk(clk),
        .reset(reset),
        .shift_reg(shift_reg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            bit_in = 0;
            #15;
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Shifting in all 1s...");
            reset_dut();
            bit_in = 1;
            repeat(5) @(negedge clk);
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Shifting in all 0s...");
            reset_dut();

            bit_in = 1; repeat(5) @(negedge clk);
            bit_in = 0; repeat(5) @(negedge clk);
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Shifting in 10101...");
            reset_dut();
            bit_in = 1; @(negedge clk);
            bit_in = 0; @(negedge clk);
            bit_in = 1; @(negedge clk);
            bit_in = 0; @(negedge clk);
            bit_in = 1; @(negedge clk);
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Shifting in 11001...");
            reset_dut();
            bit_in = 1; @(negedge clk);
            bit_in = 1; @(negedge clk);
            bit_in = 0; @(negedge clk);
            bit_in = 0; @(negedge clk);
            bit_in = 1; @(negedge clk);
            #1;

            check_outputs(5'b11001);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overflow check (Input: 1 then 00110)...");
            reset_dut();
            bit_in = 1; @(negedge clk);
            bit_in = 0; @(negedge clk);
            bit_in = 0; @(negedge clk);
            bit_in = 1; @(negedge clk);
            bit_in = 1; @(negedge clk);
            bit_in = 0; @(negedge clk);
            #1;

            check_outputs(5'b00110);
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
        input [4:0] expected_shift_reg;
        begin
            if (expected_shift_reg === (expected_shift_reg ^ shift_reg ^ expected_shift_reg)) begin
                $display("PASS");
                $display("  Outputs: shift_reg=%h",
                         shift_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shift_reg=%h",
                         expected_shift_reg);
                $display("  Got:      shift_reg=%h",
                         shift_reg);
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
        $dumpvars(0,bit_in, clk, reset, shift_reg);
    end

endmodule
