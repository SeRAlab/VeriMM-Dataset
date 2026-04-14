`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg fifo_rd;
    reg rst_n;
    wire fifo_EF;
    wire [7:0] fifo_rdata;
    wire rfifo_full;
    wire [5:0] rfifo_used;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .fifo_rd(fifo_rd),
        .rst_n(rst_n),
        .fifo_EF(fifo_EF),
        .fifo_rdata(fifo_rdata),
        .rfifo_full(rfifo_full),
        .rfifo_used(rfifo_used)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            fifo_rd = 1;
            #20;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b1, fifo_rdata, 1'b0, 6'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            fifo_rd = 0;
            repeat(15) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, fifo_rdata, 1'b0, 6'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            fifo_rd = 0;
            repeat(20) @(posedge clk);
            fifo_rd = 1;
            repeat(8) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, fifo_rdata, 1'b0, 6'd12);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            fifo_rd = 0;

            repeat(63) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, fifo_rdata, 1'b1, 6'd63);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            fifo_rd = 0;
            repeat(10) @(posedge clk);
            fifo_rd = 1;
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, fifo_rdata, 1'b0, 6'd0);
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
        input expected_fifo_EF;
        input [7:0] expected_fifo_rdata;
        input expected_rfifo_full;
        input [5:0] expected_rfifo_used;
        begin
            if (expected_fifo_EF === (expected_fifo_EF ^ fifo_EF ^ expected_fifo_EF) &&
                expected_fifo_rdata === (expected_fifo_rdata ^ fifo_rdata ^ expected_fifo_rdata) &&
                expected_rfifo_full === (expected_rfifo_full ^ rfifo_full ^ expected_rfifo_full) &&
                expected_rfifo_used === (expected_rfifo_used ^ rfifo_used ^ expected_rfifo_used)) begin
                $display("PASS");
                $display("  Outputs: fifo_EF=%b, fifo_rdata=%h, rfifo_full=%b, rfifo_used=%h",
                         fifo_EF, fifo_rdata, rfifo_full, rfifo_used);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fifo_EF=%b, fifo_rdata=%h, rfifo_full=%b, rfifo_used=%h",
                         expected_fifo_EF, expected_fifo_rdata, expected_rfifo_full, expected_rfifo_used);
                $display("  Got:      fifo_EF=%b, fifo_rdata=%h, rfifo_full=%b, rfifo_used=%h",
                         fifo_EF, fifo_rdata, rfifo_full, rfifo_used);
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
        $dumpvars(0,clk, fifo_rd, rst_n, fifo_EF, fifo_rdata, rfifo_full, rfifo_used);
    end

endmodule
