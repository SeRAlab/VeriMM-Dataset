`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [15:0] in;
    reg reset;
    reg write;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .in(in),
        .reset(reset),
        .write(write),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        enable = 0;
        write = 0;
        in = 0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Reset check", test_num);
        reset_dut();

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Basic Write (Enable=1, Write=1)", test_num);
        reset_dut();
        in = 16'hABCD;
        enable = 1;
        write = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Write Inhibition (Enable=0, Write=1)", test_num);
        reset_dut();

        in = 16'hAAAA;
        enable = 1;
        write = 1;
        @(posedge clk);
        #1;

        in = 16'h5555;
        enable = 0;
        write = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Write Inhibition (Enable=1, Write=0)", test_num);
        reset_dut();

        in = 16'h1234;
        enable = 1;
        write = 1;
        @(posedge clk);
        #1;

        in = 16'hFFFF;
        enable = 1;
        write = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Reset Priority over Write/Enable", test_num);
        reset_dut();

        in = 16'hDEAD;
        enable = 1;
        write = 1;
        reset = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Data Retention in Idle state", test_num);
        reset_dut();

        in = 16'hBEEF;
        enable = 1;
        write = 1;
        @(posedge clk);
        #1;

        enable = 0;
        write = 0;
        in = 16'h0000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hBEEF);
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
        $dumpvars(0,clk, enable, in, reset, write, out);
    end

endmodule
