`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    reg [31:0] din0;
    reg [31:0] din1;
    reg reset;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .din0(din0),
        .din1(din1),
        .reset(reset),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ce = 0;
            din0 = 0;
            din1 = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Basic Multiplication (12 * 11)");
            reset_dut();
            din0 = 32'd12;
            din1 = 32'd11;
            ce = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'd132);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Multiplication by Zero (500 * 0)");
            reset_dut();
            din0 = 32'd500;
            din1 = 32'd0;
            ce = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Identity (0xFFFFFFFF * 1)");
            reset_dut();
            din0 = 32'hFFFFFFFF;
            din1 = 32'd1;
            ce = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Truncated Overflow (0x10000 * 0x10000)");
            reset_dut();


            din0 = 32'h00010000;
            din1 = 32'h00010000;
            ce = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Clock Enable Inactive (ce=0)");
            reset_dut();


            din0 = 32'd25;
            din1 = 32'd4;
            ce = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(32'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Large Values (0x12345678 * 0x2)");
            reset_dut();
            din0 = 32'h12345678;
            din1 = 32'd2;
            ce = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h2468ACF0);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Reset Priority over CE");
            reset_dut();
            din0 = 32'd10;
            din1 = 32'd10;
            ce = 1;
            reset = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'd0);
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
        input [31:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,ce, clk, din0, din1, reset, dout);
    end

endmodule
