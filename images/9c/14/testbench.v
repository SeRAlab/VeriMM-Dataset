`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        reset = 1;
        @(negedge clk);
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %03d: Reset State Verification", test_num);
        reset_dut();

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %03d: Increment by 1", test_num);
        reset_dut();
        @(negedge clk);
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %03d: Count to 5", test_num);
        reset_dut();
        repeat(5) @(negedge clk);
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %03d: Count to Max (15)", test_num);
        reset_dut();
        repeat(15) @(negedge clk);
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %03d: Rollover 15 to 0", test_num);
        reset_dut();
        repeat(16) @(negedge clk);
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %03d: Count to 20 (Result 4)", test_num);
        reset_dut();
        repeat(20) @(negedge clk);
        #1;

        check_outputs(4'h4);
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
        input [3:0] expected_out;
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
        $dumpvars(0,clk, reset, out);
    end

endmodule
