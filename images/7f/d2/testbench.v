`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] data_in;
    reg rd_enb;
    reg [2:0] rd_ptr;
    reg rst;
    reg wr_enb;
    reg [2:0] wr_ptr;
    wire [9:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rd_enb(rd_enb),
        .rd_ptr(rd_ptr),
        .rst(rst),
        .wr_enb(wr_enb),
        .wr_ptr(wr_ptr),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        wr_enb = 0;
        rd_enb = 0;
        rd_ptr = 0;
        wr_ptr = 0;
        data_in = 0;
        @(posedge clk);
        #2 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Basic Write and Read");
        reset_dut();


        @(negedge clk);
        wr_enb = 1;
        wr_ptr = 3'd2;
        data_in = 10'h1A5;
        @(posedge clk);
        #1 wr_enb = 0;


        rd_enb = 1;
        rd_ptr = 3'd2;
        @(posedge clk);
        #1 #1;
 check_outputs(10'h1A5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Reset clearing memory");
        reset_dut();


        @(negedge clk);
        wr_enb = 1;
        wr_ptr = 3'd5;
        data_in = 10'h3FF;
        @(posedge clk);
        #1 wr_enb = 0;


        reset_dut();


        rd_enb = 1;
        rd_ptr = 3'd5;
        @(posedge clk);
        #1 #1;
 check_outputs(10'h000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Multiple sequential writes");
        reset_dut();


        @(negedge clk);
        wr_enb = 1; wr_ptr = 3'd0; data_in = 10'h001; @(posedge clk);
        #1 wr_ptr = 3'd1; data_in = 10'h002; @(posedge clk);
        #1 wr_ptr = 3'd7; data_in = 10'h3FF; @(posedge clk);
        #1 wr_enb = 0;


        rd_enb = 1;
        rd_ptr = 3'd7;
        @(posedge clk);
        #1 #1;
 check_outputs(10'h3FF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Simultaneous Read and Write");
        reset_dut();


        @(negedge clk);
        wr_enb = 1; wr_ptr = 3'd1; data_in = 10'h0AA; @(posedge clk);
        #1 wr_enb = 0;


        @(negedge clk);
        wr_enb = 1; wr_ptr = 3'd2; data_in = 10'h0BB;
        rd_enb = 1; rd_ptr = 3'd1;
        @(posedge clk);

        #1 #1;
 check_outputs(10'h0AA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Overwrite data at same address");
        reset_dut();


        @(negedge clk);
        wr_enb = 1; wr_ptr = 3'd4; data_in = 10'h111; @(posedge clk);

        #1 wr_ptr = 3'd4; data_in = 10'h222; @(posedge clk);
        #1 wr_enb = 0;


        rd_enb = 1; rd_ptr = 3'd4;
        @(posedge clk);
        #1 #1;
 check_outputs(10'h222);
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
        input [9:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, rd_enb, rd_ptr, rst, wr_enb, wr_ptr, data_out);
    end

endmodule
