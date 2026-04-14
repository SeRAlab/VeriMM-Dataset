`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr;
    reg clk;
    reg re;
    reg [15:0] wd;
    reg we;
    wire [15:0] rd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .re(re),
        .wd(wd),
        .we(we),
        .rd(rd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        we = 0;
        re = 0;
        addr = 0;
        wd = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Basic Write and Read", test_num);
        reset_dut();

        we = 1; addr = 3'd0; wd = 16'h1234; re = 0;
        @(posedge clk); #1;

        we = 0; re = 1; addr = 3'd0;
        @(posedge clk); #1;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Write/Read at Address 7", test_num);
        reset_dut();

        we = 1; addr = 3'd7; wd = 16'hABCD; re = 0;
        @(posedge clk); #1;

        we = 0; re = 1; addr = 3'd7;
        @(posedge clk); #1;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Output Zero when re=0", test_num);
        reset_dut();

        we = 1; addr = 3'd2; wd = 16'h5555; re = 0;
        @(posedge clk); #1;

        we = 0; re = 0; addr = 3'd2;
        @(posedge clk); #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Overwrite Data", test_num);
        reset_dut();

        we = 1; addr = 3'd3; wd = 16'h1111;
        @(posedge clk); #1;

        we = 1; addr = 3'd3; wd = 16'h2222;
        @(posedge clk); #1;

        we = 0; re = 1; addr = 3'd3;
        @(posedge clk); #1;
        #1;

        check_outputs(16'h2222);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Write Enable Control", test_num);
        reset_dut();

        we = 1; addr = 3'd4; wd = 16'hAAAA;
        @(posedge clk); #1;

        we = 0; addr = 3'd4; wd = 16'hBBBB;
        @(posedge clk); #1;

        we = 0; re = 1; addr = 3'd4;
        @(posedge clk); #1;
        #1;

        check_outputs(16'hAAAA);
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
        input [15:0] expected_rd;
        begin
            if (expected_rd === (expected_rd ^ rd ^ expected_rd)) begin
                $display("PASS");
                $display("  Outputs: rd=%h",
                         rd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd=%h",
                         expected_rd);
                $display("  Got:      rd=%h",
                         rd);
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
        $dumpvars(0,addr, clk, re, wd, we, rd);
    end

endmodule
