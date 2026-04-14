`timescale 1ns/1ps

module sq_pg_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] block;
    reg ce_n;
    reg clk;
    reg [10:0] fnumber;
    reg [3:0] multiple;
    reg reset_n;
    wire [9:0] phase;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sq_pg dut (
        .block(block),
        .ce_n(ce_n),
        .clk(clk),
        .fnumber(fnumber),
        .multiple(multiple),
        .reset_n(reset_n),
        .phase(phase)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task reset_dut;
    //define reset task
    endtask
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sq_pg Testbench");
        $display("========================================");


        
        
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
        input [9:0] expected_phase;
        begin
            if (expected_phase === (expected_phase ^ phase ^ expected_phase)) begin
                $display("PASS");
                $display("  Outputs: phase=%h",
                         phase);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: phase=%h",
                         expected_phase);
                $display("  Got:      phase=%h",
                         phase);
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
        $dumpvars(0,block, ce_n, clk, fnumber, multiple, reset_n, phase);
    end

endmodule
