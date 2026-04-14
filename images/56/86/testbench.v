`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire clk_1ms;
    wire [25:0] count_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .clk_1ms(clk_1ms),
        .count_out(count_out)
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
        #2 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();


        #1;



        check_outputs(1'b0, 26'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        repeat(15) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0, 26'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        repeat(99998) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0, 26'd99998);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        repeat(99999) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1, 26'd99999);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        repeat(100000) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0, 26'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        repeat(500) @(posedge clk);
        reset = 1;
        @(posedge clk);
        #2 reset = 0;
        #1;

        check_outputs(1'b0, 26'd0);
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
        input expected_clk_1ms;
        input [25:0] expected_count_out;
        begin
            if (expected_clk_1ms === (expected_clk_1ms ^ clk_1ms ^ expected_clk_1ms) &&
                expected_count_out === (expected_count_out ^ count_out ^ expected_count_out)) begin
                $display("PASS");
                $display("  Outputs: clk_1ms=%b, count_out=%h",
                         clk_1ms, count_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_1ms=%b, count_out=%h",
                         expected_clk_1ms, expected_count_out);
                $display("  Got:      clk_1ms=%b, count_out=%h",
                         clk_1ms, count_out);
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
        $dumpvars(0,clk, reset, clk_1ms, count_out);
    end

endmodule
