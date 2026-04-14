`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a;
    reg clk;
    reg [7:0] d;
    reg re;
    reg we;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .d(d),
        .re(re),
        .we(we),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 16'h0;
            d = 8'h0;
            we = 0;
            re = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read...");
            reset_dut();

            a = 16'h0010; d = 8'hA5; we = 1; re = 0;
            @(posedge clk);
            #1 we = 0;

            a = 16'h0010; re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Check boundary 15-bit address (0x7FFF)...");
            reset_dut();

            a = 16'h7FFF; d = 8'h5A; we = 1; re = 0;
            @(posedge clk);
            #1 we = 0;

            a = 16'h7FFF; re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Address Aliasing (bit 15 ignored)...");
            reset_dut();

            a = 16'h0001; d = 8'h33; we = 1; re = 0;
            @(posedge clk);
            #1 we = 0;

            a = 16'h8001; re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Verify data is not written when we is low...");
            reset_dut();

            a = 16'h0020; d = 8'hBB; we = 1;
            @(posedge clk);
            #1;

            a = 16'h0020; d = 8'hCC; we = 0;
            @(posedge clk);
            #1;

            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Multiple sequential writes and reads...");
            reset_dut();

            a = 16'h0100; d = 8'h11; we = 1;
            @(posedge clk);
            #1;

            a = 16'h0200; d = 8'h22; we = 1;
            @(posedge clk);
            #1 we = 0;

            a = 16'h0100; re = 1;
            @(posedge clk);
            #1;

            a = 16'h0200; re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h22);
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
        input [7:0] expected_q;
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
        $dumpvars(0,a, clk, d, re, we, q);
    end

endmodule
