`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ena;
    reg nrst;
    wire [11:0] word;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ena(ena),
        .nrst(nrst),
        .word(word)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        ena = 0;
        nrst = 0;
        repeat(2) @(posedge clk);
        #1 nrst = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Checking Reset Initialization", test_num);
        reset_dut();

        #1;


        check_outputs(RESET_SEED);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Checking Enable = 0 (No Shifting)", test_num);
        reset_dut();
        ena = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(RESET_SEED);
    end
        endtask

    task testcase003;

    reg [11:0] expected;
    begin
        test_num = 3;
        $display("Testcase %03d: Checking Single Cycle Shift", test_num);
        reset_dut();
        expected = RESET_SEED;

        ena = 1;
        @(posedge clk);
        #1;
        expected = lfsr_step(expected);
        #1;

        check_outputs(expected);
    end
        endtask

    task testcase004;

    reg [11:0] expected;
    integer i;
    begin
        test_num = 4;
        $display("Testcase %03d: Checking 20 Cycles of Shifting", test_num);
        reset_dut();
        expected = RESET_SEED;

        ena = 1;
        for (i = 0; i < 20; i = i + 1) begin
            @(posedge clk);
            expected = lfsr_step(expected);
        end
        #1;
        #1;

        check_outputs(expected);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Checking Async/Sync Reset mid-sequence", test_num);
        reset_dut();
        ena = 1;
        repeat(10) @(posedge clk);


        nrst = 0;
        #2;
        nrst = 1;
        ena = 0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(RESET_SEED);
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
        input [11:0] expected_word;
        begin
            if (expected_word === (expected_word ^ word ^ expected_word)) begin
                $display("PASS");
                $display("  Outputs: word=%h",
                         word);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: word=%h",
                         expected_word);
                $display("  Got:      word=%h",
                         word);
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
        $dumpvars(0,clk, ena, nrst, word);
    end

endmodule
