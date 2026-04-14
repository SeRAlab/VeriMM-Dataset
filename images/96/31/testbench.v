`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] fifo_data_i;
    reg fifo_empty_i;
    reg link_active;
    reg rst;
    reg tx_dst_rdy_n;
    wire fifo_read_o;
    wire [31:0] tx_d;
    wire tx_src_rdy_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .fifo_data_i(fifo_data_i),
        .fifo_empty_i(fifo_empty_i),
        .link_active(link_active),
        .rst(rst),
        .tx_dst_rdy_n(tx_dst_rdy_n),
        .fifo_read_o(fifo_read_o),
        .tx_d(tx_d),
        .tx_src_rdy_n(tx_src_rdy_n)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            fifo_data_i = 32'h0;
            fifo_empty_i = 1;
            link_active = 0;
            tx_dst_rdy_n = 1;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Default state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 32'h0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Link inactive, source data available", test_num);
            reset_dut();
            fifo_data_i = 32'hAAAA_BBBB;
            fifo_empty_i = 0;
            link_active = 0;
            tx_dst_rdy_n = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 32'hAAAA_BBBB, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Destination busy (Ready_n=1)", test_num);
            reset_dut();
            fifo_data_i = 32'hCCCC_DDDD;
            fifo_empty_i = 0;
            link_active = 1;
            tx_dst_rdy_n = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 32'hCCCC_DDDD, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Successful transmission", test_num);
            reset_dut();
            fifo_data_i = 32'h1234_5678;
            fifo_empty_i = 0;
            link_active = 1;
            tx_dst_rdy_n = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 32'h1234_5678, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: FIFO empty", test_num);
            reset_dut();
            fifo_data_i = 32'h0;
            fifo_empty_i = 1;
            link_active = 1;
            tx_dst_rdy_n = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 32'h0, 1'b1);
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
        input expected_fifo_read_o;
        input [31:0] expected_tx_d;
        input expected_tx_src_rdy_n;
        begin
            if (expected_fifo_read_o === (expected_fifo_read_o ^ fifo_read_o ^ expected_fifo_read_o) &&
                expected_tx_d === (expected_tx_d ^ tx_d ^ expected_tx_d) &&
                expected_tx_src_rdy_n === (expected_tx_src_rdy_n ^ tx_src_rdy_n ^ expected_tx_src_rdy_n)) begin
                $display("PASS");
                $display("  Outputs: fifo_read_o=%b, tx_d=%h, tx_src_rdy_n=%b",
                         fifo_read_o, tx_d, tx_src_rdy_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fifo_read_o=%b, tx_d=%h, tx_src_rdy_n=%b",
                         expected_fifo_read_o, expected_tx_d, expected_tx_src_rdy_n);
                $display("  Got:      fifo_read_o=%b, tx_d=%h, tx_src_rdy_n=%b",
                         fifo_read_o, tx_d, tx_src_rdy_n);
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
        $dumpvars(0,clk, fifo_data_i, fifo_empty_i, link_active, rst, tx_dst_rdy_n, fifo_read_o, tx_d, tx_src_rdy_n);
    end

endmodule
