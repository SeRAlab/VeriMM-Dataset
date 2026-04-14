`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [7:0] out_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .out_value(out_value)
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
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Reset Verification", test_num);
        reset_dut();

        #1;


        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Single Increment", test_num);
        reset_dut();
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Multiple Increments (15)", test_num);
        reset_dut();
        repeat(15) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Reach Max Value (255)", test_num);
        reset_dut();
        repeat(255) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Rollover Behavior (256 cycles)", test_num);
        reset_dut();
        repeat(256) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Mid-range value (128)", test_num);
        reset_dut();
        repeat(128) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd128);
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
        input [7:0] expected_out_value;
        begin
            if (expected_out_value === (expected_out_value ^ out_value ^ expected_out_value)) begin
                $display("PASS");
                $display("  Outputs: out_value=%h",
                         out_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_value=%h",
                         expected_out_value);
                $display("  Got:      out_value=%h",
                         out_value);
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
        $dumpvars(0,clk, reset, out_value);
    end

endmodule
