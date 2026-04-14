`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg en;
    reg reset;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .en(en),
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
        reset = 0;
        a = 0;
        b = 0;
        en = 0;
        @(negedge clk);
        reset = 1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: en=1, a!=0 (out should be a)", test_num);
        reset_dut();
        @(negedge clk);
        a = 8'hA5;
        b = 8'h5A;
        en = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: en=1, a=0 (out should be b)", test_num);
        reset_dut();
        @(negedge clk);
        a = 8'h00;
        b = 8'h3C;
        en = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h3C);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: en=0 (out should be 0)", test_num);
        reset_dut();
        @(negedge clk);
        a = 8'hFF;
        b = 8'hEE;
        en = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Reset priority (out should be 0)", test_num);
        reset_dut();
        @(negedge clk);
        reset = 0;
        a = 8'h11;
        b = 8'h22;
        en = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: en=1, a=0, b=0 (out should be 0)", test_num);
        reset_dut();
        @(negedge clk);
        a = 8'h00;
        b = 8'h00;
        en = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h00);
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
        input [7:0] expected_out;
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
        $dumpvars(0,a, b, clk, en, reset, out);
    end

endmodule
