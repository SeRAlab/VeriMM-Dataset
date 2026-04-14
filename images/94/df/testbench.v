`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] ctrl;
    reg [31:0] din;
    reg [1:0] sel;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ctrl(ctrl),
        .din(din),
        .sel(sel),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        ctrl = 5'b0;
        din = 32'b0;
        sel = 2'b0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        ctrl = 5'd1;
        din = 32'hA5A5A5A5;
        sel = 2'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        ctrl = 5'd2;
        din = 32'h12345678;
        sel = 2'd1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h12345678 | 32'h0000FFFF);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        ctrl = 5'd3;
        din = 32'hFFFFFFFF;
        sel = 2'd2;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0000FFFF);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        ctrl = 5'd4;
        din = 32'h0F0F0F0F;
        sel = 2'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(~32'h0F0F0F0F);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        ctrl = 5'd31;
        din = 32'hFFFFFFFF;
        sel = 2'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        ctrl = 5'd1;
        din = 32'hFFFFFFFF;
        sel = 2'd3;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hAAAAAAAA);
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
        $dumpvars(0,clk, ctrl, din, sel, dout);
    end

endmodule
