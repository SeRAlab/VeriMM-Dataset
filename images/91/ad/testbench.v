`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in_val;
    reg rst;
    wire [3:0] out_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_val(in_val),
        .rst(rst),
        .out_val(out_val)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        in_val = 0;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        in_val = 4'd5;
        @(posedge clk);
        #1;
        $display("Testcase %03d: Input 5 -> Expected 7", test_num);
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        in_val = 4'd0;
        @(posedge clk);
        #1;
        $display("Testcase %03d: Input 0 -> Expected 2", test_num);
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        in_val = 4'd15;
        @(posedge clk);
        #1;
        $display("Testcase %03d: Input 15 -> Expected 1 (Overflow)", test_num);
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        in_val = 4'd14;
        @(posedge clk);
        #1;
        $display("Testcase %03d: Input 14 -> Expected 0 (Overflow)", test_num);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        in_val = 4'd13;
        @(posedge clk);
        #1;
        $display("Testcase %03d: Input 13 -> Expected 15", test_num);
        #1;

        check_outputs(4'd15);
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
        input [3:0] expected_out_val;
        begin
            if (expected_out_val === (expected_out_val ^ out_val ^ expected_out_val)) begin
                $display("PASS");
                $display("  Outputs: out_val=%h",
                         out_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_val=%h",
                         expected_out_val);
                $display("  Got:      out_val=%h",
                         out_val);
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
        $dumpvars(0,clk, in_val, rst, out_val);
    end

endmodule
