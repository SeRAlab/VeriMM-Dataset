`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg in;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .in(in),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        in = 0;
        repeat(5) @(posedge clock);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test %0d: Checking initial state...", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test %0d: Checking pulse detection...", test_num);
        @(posedge clock);
        in <= 1;
        @(posedge clock);
        in <= 0;
        @(posedge clock);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test %0d: Checking pulse stretching (cycle 2)...", test_num);
        @(posedge clock);
        in <= 1;
        @(posedge clock);
        in <= 0;
        repeat(2) @(posedge clock);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test %0d: Checking recovery to zero...", test_num);
        @(posedge clock);
        in <= 1;
        @(posedge clock);
        in <= 0;
        repeat(20) @(posedge clock);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test %0d: Checking long pulse behavior...", test_num);
        @(posedge clock);
        in <= 1;
        repeat(10) @(posedge clock);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Test %0d: Checking consecutive pulses...", test_num);
        @(posedge clock);
        in <= 1; @(posedge clock); in <= 0;
        repeat(2) @(posedge clock);
        in <= 1; @(posedge clock); in <= 0;
        @(posedge clock);
        #1;

        check_outputs(1'b1);
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
        input expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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
        $dumpvars(0,clock, in, out);
    end

endmodule
