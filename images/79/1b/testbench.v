`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg wr_en;
    wire [7:0] data_out;
    wire rd_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .wr_en(wr_en),
        .data_out(data_out),
        .rd_en(rd_en)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            wr_en = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Write", test_num);
            reset_dut();
            wr_en = 1;
            data_in = 8'hA5;
            @(posedge clk);
            #1;
            wr_en = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: LIFO Property (Multiple Writes)", test_num);
            reset_dut();
            wr_en = 1;
            data_in = 8'h11; @(posedge clk); #1;
            data_in = 8'h22; @(posedge clk); #1;
            data_in = 8'h33; @(posedge clk); #1;
            wr_en = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h33, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Sequential Write and Logic Check", test_num);
            reset_dut();
            wr_en = 1;
            data_in = 8'hAA; @(posedge clk); #1;
            data_in = 8'hBB; @(posedge clk); #1;
            wr_en = 0;
            @(posedge clk); #1;

            if (data_out !== 8'hBB) $display("Warning: Intermediate LIFO state unexpected");

            wr_en = 1;
            data_in = 8'hCC; @(posedge clk); #1;
            wr_en = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(8'hCC, 1'b1);
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
        input [7:0] expected_data_out;
        input expected_rd_en;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_rd_en === (expected_rd_en ^ rd_en ^ expected_rd_en)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, rd_en=%b",
                         data_out, rd_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, rd_en=%b",
                         expected_data_out, expected_rd_en);
                $display("  Got:      data_out=%h, rd_en=%b",
                         data_out, rd_en);
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
        $dumpvars(0,clk, data_in, rst, wr_en, data_out, rd_en);
    end

endmodule
