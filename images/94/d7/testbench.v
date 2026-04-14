`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] D;
    reg L;
    reg clk;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .L(L),
        .clk(clk),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        L <= 1;
        D <= 16'h0000;
        @(posedge clk);
        L <= 0;
        D <= 16'h0000;
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Testcase 001: Loading 0xAAAA");
        @(posedge clk);
        L <= 1;
        D <= 16'hAAAA;
        @(posedge clk);
        L <= 0;
        #1;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Testcase 002: Load 0x0001 and Shift Left Once");
        @(posedge clk);
        L <= 1;
        D <= 16'h0001;
        @(posedge clk);
        L <= 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Testcase 003: Load 0x000F and Shift Left 4 times");
        @(posedge clk);
        L <= 1;
        D <= 16'h000F;
        @(posedge clk);
        L <= 0;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(16'h00F0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Testcase 004: Shift 0x8001 Left Once");
        @(posedge clk);
        L <= 1;
        D <= 16'h8001;
        @(posedge clk);
        L <= 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Testcase 005: Load 0xFFFF and Shift Left Once");
        @(posedge clk);
        L <= 1;
        D <= 16'hFFFF;
        @(posedge clk);
        L <= 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        $display("Testcase 006: Load 0xFFFF and Shift Left 16 times");
        @(posedge clk);
        L <= 1;
        D <= 16'hFFFF;
        @(posedge clk);
        L <= 0;
        repeat(16) @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        $display("Testcase 007: Load 0x1, Shift, then Load 0xABCD");
        @(posedge clk);
        L <= 1; D <= 16'h0001;
        @(posedge clk);
        L <= 0;
        @(posedge clk);
        L <= 1; D <= 16'hABCD;
        @(posedge clk);
        L <= 0;
        #1;
        #1;

        check_outputs(16'hABCD);
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
        input [15:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,D, L, clk, out);
    end

endmodule
