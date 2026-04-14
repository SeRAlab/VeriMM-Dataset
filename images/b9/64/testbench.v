`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg select;
    wire [63:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst_n(rst_n),
        .select(select),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        select = 0;
        @(posedge clk);
        #1;
        rst_n = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Reset check", test_num);
        reset_dut();
        #1;

        check_outputs(64'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Johnson Counter step 1", test_num);
        reset_dut();
        select = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(64'h8000000000000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Johnson Counter step 2", test_num);
        reset_dut();
        select = 1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(64'hC000000000000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Johnson Counter 64 steps (Full 1s)", test_num);
        reset_dut();
        select = 1;
        repeat(64) @(posedge clk);
        #1;
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Johnson Counter 128 steps (Back to 0)", test_num);
        reset_dut();
        select = 1;
        repeat(128) @(posedge clk);
        #1;
        #1;

        check_outputs(64'h0000000000000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Shift Register mode check", test_num);
        reset_dut();
        select = 1;
        repeat(2) @(posedge clk);
        #1;
        select = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(64'h6000000000000000);
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
        input [63:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,clk, rst_n, select, Q);
    end

endmodule
