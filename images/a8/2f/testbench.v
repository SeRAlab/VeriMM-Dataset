`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] cfg;
    reg clk;
    reg empty;
    reg full;
    reg full_empty;
    reg re;
    reg rst;
    reg [1:0] status;
    reg we;
    wire [2:0] int_set;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cfg(cfg),
        .clk(clk),
        .empty(empty),
        .full(full),
        .full_empty(full_empty),
        .re(re),
        .rst(rst),
        .status(status),
        .we(we),
        .int_set(int_set)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            cfg = 8'h00;
            status = 2'b00;
            full_empty = 0;
            full = 0;
            empty = 0;
            re = 0;
            we = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            full = 1;
            empty = 1;
            status = 2'b11;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            cfg = 8'h01;
            full = 1;
            we = 1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            cfg = 8'h02;
            empty = 1;
            re = 1;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            cfg = 8'h04;
            status = 2'b10;
            full_empty = 1;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            cfg = 8'h07;
            full = 1;
            empty = 1;
            status = 2'b01;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            cfg = 8'h00;
            full = 1;
            empty = 1;
            status = 2'b11;
            #1;

            check_outputs(3'b000);
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
        input [2:0] expected_int_set;
        begin
            if (expected_int_set === (expected_int_set ^ int_set ^ expected_int_set)) begin
                $display("PASS");
                $display("  Outputs: int_set=%h",
                         int_set);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: int_set=%h",
                         expected_int_set);
                $display("  Got:      int_set=%h",
                         int_set);
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
        $dumpvars(0,cfg, clk, empty, full, full_empty, re, rst, status, we, int_set);
    end

endmodule
