`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in;
    reg [7:0] read_addr;
    reg rst_n;
    reg [1:0] select;
    reg [7:0] write_addr;
    reg [3:0] write_data;
    wire [7:0] out_hi;
    wire [7:0] out_lo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .read_addr(read_addr),
        .rst_n(rst_n),
        .select(select),
        .write_addr(write_addr),
        .write_data(write_data),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            in = 0;
            select = 0;
            write_addr = 0;
            write_data = 0;
            read_addr = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Reset Functionality");
            reset_dut();
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Bitwise AND");
            reset_dut();
            in = 16'hFFFF;
            select = 2'b00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFF, 8'hE0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Bitwise OR + RAM Write/Read");
            reset_dut();
            in = 16'h0F0F;
            select = 2'b01;
            write_addr = 8'h03;
            write_data = 4'hA;
            @(posedge clk);
            read_addr = 8'h03;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h1F, 8'h1A);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Bitwise XOR + RAM Address Mapping");
            reset_dut();
            in = 16'hAAAA;
            select = 2'b10;
            write_addr = 8'h07;
            write_data = 4'h5;
            @(posedge clk);
            read_addr = 8'h07;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFF, 8'hE5);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Complex Pattern");
            reset_dut();
            in = 16'h1234;
            select = 2'b01;
            write_addr = 8'h00;
            write_data = 4'hF;
            @(posedge clk);
            read_addr = 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h36, 8'h7F);
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
        input [7:0] expected_out_hi;
        input [7:0] expected_out_lo;
        begin
            if (expected_out_hi === (expected_out_hi ^ out_hi ^ expected_out_hi) &&
                expected_out_lo === (expected_out_lo ^ out_lo ^ expected_out_lo)) begin
                $display("PASS");
                $display("  Outputs: out_hi=%h, out_lo=%h",
                         out_hi, out_lo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_hi=%h, out_lo=%h",
                         expected_out_hi, expected_out_lo);
                $display("  Got:      out_hi=%h, out_lo=%h",
                         out_hi, out_lo);
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
        $dumpvars(0,clk, in, read_addr, rst_n, select, write_addr, write_data, out_hi, out_lo);
    end

endmodule
