`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [31:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(posedge clk);
        reset <= 1;
        @(posedge clk);
        reset <= 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Verifying Reset Value", test_num);
        reset_dut();


        #1;



        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Verifying Single Decrement", test_num);
        reset_dut();
        @(posedge clk);
        #1;

        check_outputs(32'hFFFFFFFE);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Verifying 10 Decrements", test_num);
        reset_dut();
        repeat(10) @(posedge clk);
        #1;

        check_outputs(32'hFFFFFFF5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Verifying Reset Mid-Count", test_num);
        reset_dut();
        repeat(5) @(posedge clk);
        @(posedge clk);
        reset <= 1;
        @(posedge clk);
        reset <= 0;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Verifying 255 Decrements", test_num);
        reset_dut();
        repeat(255) @(posedge clk);
        #1;

        check_outputs(32'hFFFFFF00);
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
        input [31:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, reset, count);
    end

endmodule
