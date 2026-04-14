`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [7:0] fib;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .fib(fib)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Initial value after reset (Fib 1)", test_num);
        reset_dut();

        #1;


        check_outputs(8'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Sequence after 1 clock cycle", test_num);
        reset_dut();

        repeat(1) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Sequence after 2 clock cycles", test_num);
        reset_dut();
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Sequence after 5 clock cycles", test_num);
        reset_dut();
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd8);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Sequence after 10 clock cycles", test_num);
        reset_dut();
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd89);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Sequence after 12 clock cycles (Max 8-bit Fib)", test_num);
        reset_dut();
        repeat(12) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd233);
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
        input [7:0] expected_fib;
        begin
            if (expected_fib === (expected_fib ^ fib ^ expected_fib)) begin
                $display("PASS");
                $display("  Outputs: fib=%h",
                         fib);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fib=%h",
                         expected_fib);
                $display("  Got:      fib=%h",
                         fib);
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
        $dumpvars(0,clk, reset, fib);
    end

endmodule
