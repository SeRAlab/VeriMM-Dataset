`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [13:0] data_in;
    reg enable;
    reg reset;
    wire [13:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .reset(reset),
        .q(q)
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
        enable = 0;
        data_in = 0;
        @(negedge clk);
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Basic Reset", test_num);
        reset_dut();
        #1;

        check_outputs(14'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Load value 0x1234 with enable high", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        data_in = 14'h1234;
        @(negedge clk);
        enable = 0;
        #1;

        check_outputs(14'h1234);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Verify enable=0 holds the previous value", test_num);
        reset_dut();

        @(negedge clk);
        enable = 1;
        data_in = 14'h2AAA;
        @(negedge clk);

        enable = 0;
        data_in = 14'h3FFF;
        @(negedge clk);
        #1;

        check_outputs(14'h2AAA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Synchronous Reset overrides Enable", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        data_in = 14'h1FFF;
        reset = 1;
        @(negedge clk);
        reset = 0;
        #1;

        check_outputs(14'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Load maximum value (0x3FFF)", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        data_in = 14'h3FFF;
        @(negedge clk);
        enable = 0;
        #1;

        check_outputs(14'h3FFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Continuous loading across multiple cycles", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        data_in = 14'h0001;
        @(negedge clk);
        data_in = 14'h0002;
        @(negedge clk);
        data_in = 14'h0004;
        @(negedge clk);
        data_in = 14'h0008;
        @(negedge clk);
        enable = 0;
        #1;

        check_outputs(14'h0008);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Toggle Enable state", test_num);
        reset_dut();
        @(negedge clk);
        enable = 1;
        data_in = 14'h0F0F;
        @(negedge clk);
        enable = 0;
        data_in = 14'h3030;
        @(negedge clk);
        enable = 1;
        data_in = 14'h1212;
        @(negedge clk);
        enable = 0;
        #1;

        check_outputs(14'h1212);
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
        testcase007();
        
        
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
        input [13:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data_in, enable, reset, q);
    end

endmodule
