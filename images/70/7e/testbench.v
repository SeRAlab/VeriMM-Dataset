`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] value_in;
    wire [7:0] value_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .value_in(value_in),
        .value_out(value_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task reset_dut;
    //define reset task
    endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Start at 0x00, count 10 cycles", test_num);
        reset_dut(8'h00);
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd10);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Overflow check (250 + 10)", test_num);
        reset_dut(8'd250);
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd4);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Single cycle overflow (0xFF -> 0x00)", test_num);
        reset_dut(8'hFF);
        repeat(1) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Verify reset value loading (0x5A)", test_num);
        reset_dut(8'h5A);

        #1;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Full 8-bit range count (0 to 255)", test_num);
        reset_dut(8'h00);
        repeat(255) @(posedge clk);
        #1;
        #1;

        check_outputs(8'hFF);
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
        input [7:0] expected_value_out;
        begin
            if (expected_value_out === (expected_value_out ^ value_out ^ expected_value_out)) begin
                $display("PASS");
                $display("  Outputs: value_out=%h",
                         value_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: value_out=%h",
                         expected_value_out);
                $display("  Got:      value_out=%h",
                         value_out);
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
        $dumpvars(0,clk, reset, value_in, value_out);
    end

endmodule
