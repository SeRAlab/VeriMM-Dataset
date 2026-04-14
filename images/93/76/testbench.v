`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in;
    reg [7:0] p_in;
    reg rst;
    reg shift_dir;
    wire out;
    wire [7:0] p_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .p_in(p_in),
        .rst(rst),
        .shift_dir(shift_dir),
        .out(out),
        .p_out(p_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        in = 0;
        p_in = 0;
        shift_dir = 0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Reset Check");
        reset_dut();

        #1;


        check_outputs(0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Parallel Load Mode");
        reset_dut();
        shift_dir = 1;
        p_in = 8'hA5;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1, 8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Serial Shift (Single)");
        reset_dut();
        shift_dir = 0;
        in = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 8'h80);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Serial Shift (Full Sequence)");
        reset_dut();
        shift_dir = 0;

        in = 1; @(posedge clk); #1;
        in = 0; @(posedge clk); #1;
        in = 1; @(posedge clk); #1;
        in = 1; @(posedge clk); #1;
        #1;

        check_outputs(1'b0, 8'hD0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Parallel Load then Serial Shift Out");
        reset_dut();

        shift_dir = 1;
        p_in = 8'h01;
        @(posedge clk);
        #1;

        shift_dir = 0;
        in = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Reset during operation");
        reset_dut();
        shift_dir = 1;
        p_in = 8'hFF;
        @(posedge clk);
        #1;
        rst = 1;
        @(posedge clk);
        #1;
        rst = 0;
        #1;

        check_outputs(1'b0, 8'h00);
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
        input expected_out;
        input [7:0] expected_p_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_p_out === (expected_p_out ^ p_out ^ expected_p_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b, p_out=%h",
                         out, p_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, p_out=%h",
                         expected_out, expected_p_out);
                $display("  Got:      out=%b, p_out=%h",
                         out, p_out);
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
        $dumpvars(0,clk, in, p_in, rst, shift_dir, out, p_out);
    end

endmodule
