`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in1;
    reg [7:0] in2;
    reg reset;
    reg [3:0] sel;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in1(in1),
        .in2(in2),
        .reset(reset),
        .sel(sel),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        in1 = 8'h00;
        in2 = 8'h00;
        sel = 4'h0;
        @(posedge clk);
        #1 reset = 0;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        in1 = 8'hA5;
        in2 = 8'h5A;
        sel = 4'b0000;
        @(posedge clk);
        #1;
        $display("Test 001: Select in1 (sel=0000)");
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        in1 = 8'hA5;
        in2 = 8'h5A;
        sel = 4'b1111;
        @(posedge clk);
        #1;
        $display("Test 002: Select in2 (sel=1111)");
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        in1 = 8'hFF;
        in2 = 8'h0F;
        sel = 4'b0001;
        @(posedge clk);
        #1;
        $display("Test 003: Bitwise AND (sel=0001)");
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        in1 = 8'hF0;
        in2 = 8'h55;
        sel = 4'b1010;
        @(posedge clk);
        #1;
        $display("Test 004: Bitwise AND (sel=1010)");
        #1;

        check_outputs(8'h50);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        in1 = 8'hAA;
        in2 = 8'h55;
        sel = 4'b1110;
        @(posedge clk);
        #1;
        $display("Test 005: Bitwise AND (sel=1110)");
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        in1 = 8'hFF;
        in2 = 8'hFF;
        sel = 4'b0000;
        reset = 1;
        @(posedge clk);
        #1;
        $display("Test 006: Reset Priority Check");
        #1;

        check_outputs(8'h00);
        reset = 0;
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
        $dumpvars(0,clk, in1, in2, reset, sel, out);
    end

endmodule
