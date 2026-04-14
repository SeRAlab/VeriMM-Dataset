`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in;
    reg rst;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .rst(rst),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Reset=1 (Double), Input=10", test_num);
            in = 32'd10;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd20);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Reset=0 (Half), Input=100", test_num);
            in = 32'd100;
            rst = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd50);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Reset=0 (Half), Input=7 (Odd)", test_num);
            in = 32'd7;
            rst = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd3);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Reset=1 (Double), Input=0x7FFFFFFF", test_num);
            in = 32'h7FFFFFFF;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Reset=0 (Half), Input=0xFFFFFFFF", test_num);
            in = 32'hFFFFFFFF;
            rst = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h7FFFFFFF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %03d: Reset=1 (Double), Input=0", test_num);
            in = 32'd0;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

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
        input [31:0] expected_out;
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
        $dumpvars(0,clk, in, rst, out);
    end

endmodule
