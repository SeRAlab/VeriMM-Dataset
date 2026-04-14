`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in1;
    reg [7:0] in2;
    reg reset;
    wire [15:0] out;
    wire [7:0] out_lo;

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
        .out(out),
        .out_lo(out_lo)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        in1 = 0;
        in2 = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: 0 * 25", test_num);
        reset_dut();
        in1 = 8'd0;
        in2 = 8'd25;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(16'd0, 8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: 255 * 255", test_num);
        reset_dut();
        in1 = 8'hFF;
        in2 = 8'hFF;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(16'hFE01, 8'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: 1 * 123", test_num);
        reset_dut();
        in1 = 8'd1;
        in2 = 8'd123;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(16'd123, 8'd123);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: 12 * 12", test_num);
        reset_dut();
        in1 = 8'd12;
        in2 = 8'd12;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(16'd144, 8'd144);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: 16 * 16", test_num);
        reset_dut();
        in1 = 8'd16;
        in2 = 8'd16;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(16'd256, 8'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: 200 * 2", test_num);
        reset_dut();
        in1 = 8'd200;
        in2 = 8'd2;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(16'd400, 8'd144);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: 13 * 17", test_num);
        reset_dut();
        in1 = 8'd13;
        in2 = 8'd17;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(16'd221, 8'd221);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: 64 * 8", test_num);
        reset_dut();
        in1 = 8'd64;
        in2 = 8'd8;
        repeat(10) @(posedge clk);
        #1;

        check_outputs(16'd512, 8'd0);
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
        testcase008();
        
        
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
        input [15:0] expected_out;
        input [7:0] expected_out_lo;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_out_lo === (expected_out_lo ^ out_lo ^ expected_out_lo)) begin
                $display("PASS");
                $display("  Outputs: out=%h, out_lo=%h",
                         out, out_lo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, out_lo=%h",
                         expected_out, expected_out_lo);
                $display("  Got:      out=%h, out_lo=%h",
                         out, out_lo);
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
        $dumpvars(0,clk, in1, in2, reset, out, out_lo);
    end

endmodule
