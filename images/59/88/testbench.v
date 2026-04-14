`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg rst;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .rst(rst),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 0;
        din = 8'h00;
        @(posedge clk);
        #1;
        rst = 1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Reset Verification", test_num);
        rst = 0;
        din = 8'hFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Basic Data Load (Pattern AA)", test_num);
        reset_dut();
        din = 8'hAA;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Basic Data Load (Pattern 55)", test_num);
        reset_dut();
        din = 8'h55;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Synchronous Reset Mid-operation", test_num);
        reset_dut();
        din = 8'hCC;
        @(posedge clk);
        #1;
        rst = 0;
        din = 8'hBB;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Multi-cycle Sequence", test_num);
        reset_dut();
        din = 8'h11; @(posedge clk);
        #1;
        din = 8'h22; @(posedge clk);
        #1;
        din = 8'h33; @(posedge clk);
        #1;
        #1;

        check_outputs(8'h33);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Max Value Transfer (FF)", test_num);
        reset_dut();
        din = 8'hFF;
        @(posedge clk);
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
        input [7:0] expected_dout;
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
        $dumpvars(0,clk, din, rst, dout);
    end

endmodule
