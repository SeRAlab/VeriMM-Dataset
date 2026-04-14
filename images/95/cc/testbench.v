`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in1;
    reg [7:0] in2;
    reg rst_n;
    wire [8:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in1(in1),
        .in2(in2),
        .rst_n(rst_n),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            in1 = 8'h0;
            in2 = 8'h0;
            @(posedge clk);
            #1;
            rst_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic Addition (10 + 20)", test_num);
            reset_dut();
            in1 = 8'd10;
            in2 = 8'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Addition with Zero (0 + 128)", test_num);
            reset_dut();
            in1 = 8'd0;
            in2 = 8'd128;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd128);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Carry Bit Test (255 + 1)", test_num);
            reset_dut();
            in1 = 8'hFF;
            in2 = 8'h01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'h100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Maximum Values (255 + 255)", test_num);
            reset_dut();
            in1 = 8'hFF;
            in2 = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'h1FE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Pattern Addition (0xAA + 0x55)", test_num);
            reset_dut();
            in1 = 8'hAA;
            in2 = 8'h55;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'h0FF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Large Values (200 + 150)", test_num);
            reset_dut();
            in1 = 8'd200;
            in2 = 8'd150;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd350);
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
        input [8:0] expected_out;
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
        $dumpvars(0,clk, in1, in2, rst_n, out);
    end

endmodule
