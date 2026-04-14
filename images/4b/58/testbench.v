`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg button_in;
    reg clk;
    reg n_reset;
    wire DB_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .button_in(button_in),
        .clk(clk),
        .n_reset(n_reset),
        .DB_out(DB_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        n_reset = 0;
        button_in = 0;
        repeat(5) @(posedge clk);
        #1 n_reset = 1;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Initial State after Reset", test_num);
        reset_dut();
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Stable Button Press", test_num);
        reset_dut();
        button_in = 1;

        repeat(150) @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: High-going Glitch Filtering", test_num);
        reset_dut();

        button_in = 1;
        repeat(2) @(posedge clk);
        button_in = 0;

        repeat(150) @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Stable Button Release", test_num);
        reset_dut();

        button_in = 1;
        repeat(150) @(posedge clk);

        button_in = 0;
        repeat(150) @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Low-going Glitch Filtering", test_num);
        reset_dut();

        button_in = 1;
        repeat(150) @(posedge clk);

        button_in = 0;
        repeat(2) @(posedge clk);
        button_in = 1;

        repeat(150) @(posedge clk);
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
        input expected_DB_out;
        begin
            if (expected_DB_out === (expected_DB_out ^ DB_out ^ expected_DB_out)) begin
                $display("PASS");
                $display("  Outputs: DB_out=%b",
                         DB_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DB_out=%b",
                         expected_DB_out);
                $display("  Got:      DB_out=%b",
                         DB_out);
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
        $dumpvars(0,button_in, clk, n_reset, DB_out);
    end

endmodule
