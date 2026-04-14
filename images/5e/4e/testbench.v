`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in;
    reg rst_n;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .rst_n(rst_n),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        in = 16'h0000;
        #20;
        rst_n = 1;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase001: Input 0x0000");
        reset_dut();
        in = 16'h0000;
        #200;
        #1;

        check_outputs(16'h0262);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase002: Input 0x0001");
        reset_dut();
        in = 16'h0001;
        #200;
        #1;

        check_outputs(16'h0263);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase003: Input 0x0002");
        reset_dut();
        in = 16'h0002;
        #200;
        #1;

        check_outputs(16'h0261);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase004: Input 0x000F");
        reset_dut();
        in = 16'h000F;
        #200;
        #1;

        check_outputs(16'h026A);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase005: Input 0x1234");
        reset_dut();
        in = 16'h1234;
        #200;
        #1;

        check_outputs(16'h194C);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running Testcase006: Input 0xFFFF");
        reset_dut();
        in = 16'hFFFF;
        #200;
        #1;

        check_outputs(16'h8262);
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
        $dumpvars(0,clk, in, rst_n, out);
    end

endmodule
