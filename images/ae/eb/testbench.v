`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] D;
    reg Load;
    reg clear;
    reg clk;
    wire [31:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .Load(Load),
        .clear(clear),
        .clk(clk),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clear = 0;
        forever #5 clear = ~clear;
    end

        task reset_dut;

    begin
        D = 32'h0;
        Load = 0;
        clear = 1;
        #10;
        clear = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Checking initial reset state...");
        reset_dut();

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Checking synchronous load (0xAAAAAAAA)...");
        reset_dut();
        D = 32'hAAAAAAAA;
        Load = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Checking multiple consecutive loads...");
        reset_dut();

        D = 32'h12345678;
        Load = 1;
        @(posedge clk);

        #1;
        D = 32'h87654321;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h87654321);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Checking hold capability (Load=0)...");
        reset_dut();

        D = 32'hDEADBEEF;
        Load = 1;
        @(posedge clk);
        #1;

        Load = 0;
        D = 32'h00000000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Checking async clear priority over Load...");
        reset_dut();

        D = 32'hFFFFFFFF;
        Load = 1;
        @(posedge clk);
        #2;

        clear = 1;
        #1;
        #1;

        check_outputs(32'h00000000);
        clear = 0;
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
        input [31:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, Load, clear, clk, Q);
    end

endmodule
