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
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic multiplication (10 * 5)", test_num);
        reset_dut();
        din0 = 32'd10;
        din1 = 32'd5;
        ce = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'd50);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Multiplication by zero (100 * 0)", test_num);
        reset_dut();
        din0 = 32'd100;
        din1 = 32'd0;
        ce = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Multiplication with ce=0", test_num);
        reset_dut();
        din0 = 32'd25;
        din1 = 32'd4;
        ce = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Larger values (1000 * 2000)", test_num);
        reset_dut();
        din0 = 32'd1000;
        din1 = 32'd2000;
        ce = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'd2000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Hexadecimal inputs (0x10 * 0x20)", test_num);
        reset_dut();
        din0 = 32'h0000_0010;
        din1 = 32'h0000_0020;
        ce = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'd512);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: High value multiplication (0xFFFF * 2)", test_num);
        reset_dut();
        din0 = 32'h0000_FFFF;
        din1 = 32'd2;
        ce = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0001_FFFE);
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
