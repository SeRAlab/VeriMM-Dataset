`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg RW;
    reg clk;
    reg [5:0] didx;
    reg [15:0] din;
    wire [15:0] di;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RW(RW),
        .clk(clk),
        .didx(didx),
        .din(din),
        .di(di)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            RW = 0;
            didx = 0;
            din = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test 001: Basic Write and Read at Address 0");
            reset_dut();

            RW = 1;
            didx = 6'd0;
            din = 16'hABCD;
            @(posedge clk);
            #1;

            RW = 0;
            didx = 6'd0;
            #2;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            $display("Test 002: Write and Read at Boundary Address 63");
            reset_dut();

            RW = 1;
            didx = 6'd63;
            din = 16'h55AA;
            @(posedge clk);
            #1;

            RW = 0;
            didx = 6'd63;
            #2;
            #1;

            check_outputs(16'h55AA);
        end
        endtask

    task testcase003;

        begin
            $display("Test 003: Overwriting data at Address 10");
            reset_dut();

            RW = 1;
            didx = 6'd10;
            din = 16'h1111;
            @(posedge clk);
            #1;

            din = 16'hFFFF;
            @(posedge clk);
            #1;

            RW = 0;
            #2;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Test 004: Multi-address Integrity Check");
            reset_dut();

            RW = 1;
            didx = 6'd5;
            din = 16'hAAAA;
            @(posedge clk);
            #1;

            didx = 6'd6;
            din = 16'hBBBB;
            @(posedge clk);
            #1;

            RW = 0;
            didx = 6'd5;
            #2;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase005;

        begin
            $display("Test 005: Read stability when inputs change but RW is low");
            reset_dut();

            RW = 1;
            didx = 6'd20;
            din = 16'h1234;
            @(posedge clk);
            #1;

            RW = 0;
            didx = 6'd20;

            din = 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
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
        input [15:0] expected_di;
        begin
            if (expected_di === (expected_di ^ di ^ expected_di)) begin
                $display("PASS");
                $display("  Outputs: di=%h",
                         di);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: di=%h",
                         expected_di);
                $display("  Got:      di=%h",
                         di);
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
        $dumpvars(0,RW, clk, didx, din, di);
    end

endmodule
