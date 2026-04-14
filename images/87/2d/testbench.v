`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [2:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(posedge clk);
        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Checking reset value...");
        reset_dut();
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Checking single step down (7 to 6)...");
        reset_dut();
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Checking down count after 4 cycles (7 to 3)...");
        reset_dut();
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Checking reaching zero (7 cycles)...");
        reset_dut();
        repeat(7) @(posedge clk);
        #1;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Checking wrap-around (8 cycles)...");
        reset_dut();
        repeat(8) @(posedge clk);
        #1;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Checking multiple wraps (11 cycles)...");
        reset_dut();
        repeat(11) @(posedge clk);
        #1;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Checking reset during counting...");
        reset_dut();
        repeat(3) @(posedge clk);
        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;
        #1;

        check_outputs(3'b111);
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
        input [2:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
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
        $dumpvars(0,clk, reset, q);
    end

endmodule
