`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] freq;
    reg rst;
    reg sync;
    reg test;
    wire [31:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .freq(freq),
        .rst(rst),
        .sync(sync),
        .test(test),
        .o(o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            test = 0;
            sync = 0;
            freq = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            freq = 32'd100;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(32'd400);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            freq = 32'hAABBCCDD;
            test = 1;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(32'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            freq = 32'd50;
            repeat(4) @(posedge clk);
            sync = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            freq = 32'h80000000;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(32'h80000000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            freq = 32'hFFFF;
            repeat(10) @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            freq = 32'd10;
            @(posedge clk);
            @(posedge clk);
            freq = 32'd30;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(32'd80);
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
        input [31:0] expected_o;
        begin
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
        $dumpvars(0,clk, freq, rst, sync, test, o);
    end

endmodule
