`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_hi;
    reg [7:0] in_lo;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_hi(in_hi),
        .in_lo(in_lo),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        in_hi = 8'h0;
        in_lo = 8'h0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Basic Concatenation (0xAA, 0x55)", test_num);
        reset_dut();
        in_hi = 8'hAA;
        in_lo = 8'h55;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'hAA55);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: All Zeros", test_num);
        reset_dut();
        in_hi = 8'h00;
        in_lo = 8'h00;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: All Ones", test_num);
        reset_dut();
        in_hi = 8'hFF;
        in_lo = 8'hFF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Alternating Patterns", test_num);
        reset_dut();
        in_hi = 8'hF0;
        in_lo = 8'h0F;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'hF00F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Arbitrary Data (0x12, 0x34)", test_num);
        reset_dut();
        in_hi = 8'h12;
        in_lo = 8'h34;
        @(posedge clk);
        #2;
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
        $dumpvars(0,clk, in_hi, in_lo, out);
    end

endmodule
