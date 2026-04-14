`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] C;
    reg [7:0] R1;
    reg [7:0] R2;
    reg clk;
    reg reset;
    wire pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C(C),
        .R1(R1),
        .R2(R2),
        .clk(clk),
        .reset(reset),
        .pulse(pulse)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        R1 = 8'd0;
        R2 = 8'd0;
        C = 8'd0;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset = 1;
        R1 = 8'd10; R2 = 8'd10; C = 8'd10;
        #20;
        $display("Testcase 001: Checking pulse during reset...");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();

        R1 = 8'd1; R2 = 8'd1; C = 8'd1;

        @(posedge clk);
        #2;
        $display("Testcase 002: Checking if pulse starts high after reset...");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        R1 = 8'd1; R2 = 8'd1; C = 8'd1;


        repeat (6) @(posedge clk);
        #2;
        $display("Testcase 003: Checking if pulse toggled to low after short duration...");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        R1 = 8'd20; R2 = 8'd2; C = 8'd2;

        repeat (6) @(posedge clk);
        #2;
        $display("Testcase 004: Checking if larger R1 keeps pulse high longer...");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        R1 = 8'd2; R2 = 8'd2; C = 8'd20;

        repeat (15) @(posedge clk);
        #2;
        $display("Testcase 005: Checking if large C significantly delays toggling...");
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
        input expected_pulse;
        begin
            if (expected_pulse === (expected_pulse ^ pulse ^ expected_pulse)) begin
                $display("PASS");
                $display("  Outputs: pulse=%b",
                         pulse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pulse=%b",
                         expected_pulse);
                $display("  Got:      pulse=%b",
                         pulse);
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
        $dumpvars(0,C, R1, R2, clk, reset, pulse);
    end

endmodule
