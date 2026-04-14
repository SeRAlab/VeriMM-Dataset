`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr_i;
    reg clk;
    reg [31:0] data_i;
    reg rst;
    reg tx_pop_i;
    reg we_i;
    wire [31:0] data_o;
    wire tx_ack_o;
    wire [23:0] tx_data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_i(addr_i),
        .clk(clk),
        .data_i(data_i),
        .rst(rst),
        .tx_pop_i(tx_pop_i),
        .we_i(we_i),
        .data_o(data_o),
        .tx_ack_o(tx_ack_o),
        .tx_data_o(tx_data_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        addr_i = 0;
        data_i = 0;
        we_i = 0;
        tx_pop_i = 0;
        #20;
        rst = 0;
        #20;
    end
    endtask
    task testcase001;

    begin
        $display("Testcase 001: Checking idle state after reset");
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(32'h0, 1'b0, 24'h0);
    end
    endtask

    task testcase002;

    begin
        $display("Testcase 002: Single write and pop");
        test_num = 2;
        reset_dut();


        @(posedge clk);
        addr_i = 32'h0;
        data_i = 32'h00AABBCC;
        we_i = 1;
        @(posedge clk);
        we_i = 0;


        @(posedge clk);
        tx_pop_i = 1;
        @(posedge clk);

        #1;
        #1;

        check_outputs(32'h0, 1'b1, 24'hAABBCC);
        tx_pop_i = 0;
    end
    endtask

    task testcase003;

    begin
        $display("Testcase 003: Truncation check (32-bit to 24-bit)");
        test_num = 3;
        reset_dut();


        @(posedge clk);
        addr_i = 32'h0;
        data_i = 32'hFF123456;
        we_i = 1;
        @(posedge clk);
        we_i = 0;


        @(posedge clk);
        tx_pop_i = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0, 1'b1, 24'h123456);
        tx_pop_i = 0;
    end
    endtask

    task testcase004;

    begin
        $display("Testcase 004: Multiple writes and sequential pops");
        test_num = 4;
        reset_dut();


        @(posedge clk);
        addr_i = 32'h0; data_i = 32'h00111111; we_i = 1;
        @(posedge clk);

        data_i = 32'h00222222;
        @(posedge clk);
        we_i = 0;


        @(posedge clk);
        tx_pop_i = 1;
        @(posedge clk);

        tx_pop_i = 1;
        @(posedge clk);

        #1;
        #1;

        check_outputs(32'h0, 1'b1, 24'h222222);
        tx_pop_i = 0;
    end
    endtask

    task testcase005;

    begin
        $display("Testcase 005: Pop from empty FIFO");
        test_num = 5;
        reset_dut();


        @(posedge clk);
        tx_pop_i = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h0, 1'b0, 24'h0);
        tx_pop_i = 0;
    end
    endtask

    task testcase006;

    begin
        $display("Testcase 006: Write to control address");
        test_num = 6;
        reset_dut();


        @(posedge clk);
        addr_i = 32'h4;
        data_i = 32'hDEADBEEF;
        we_i = 1;
        @(posedge clk);
        we_i = 0;


        @(posedge clk);
        tx_pop_i = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0, 1'b0, 24'h000000);
        tx_pop_i = 0;
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
        input [31:0] expected_data_o;
        input expected_tx_ack_o;
        input [23:0] expected_tx_data_o;
        begin
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o) &&
                expected_tx_ack_o === (expected_tx_ack_o ^ tx_ack_o ^ expected_tx_ack_o) &&
                expected_tx_data_o === (expected_tx_data_o ^ tx_data_o ^ expected_tx_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h, tx_ack_o=%b, tx_data_o=%h",
                         data_o, tx_ack_o, tx_data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h, tx_ack_o=%b, tx_data_o=%h",
                         expected_data_o, expected_tx_ack_o, expected_tx_data_o);
                $display("  Got:      data_o=%h, tx_ack_o=%b, tx_data_o=%h",
                         data_o, tx_ack_o, tx_data_o);
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
        $dumpvars(0,addr_i, clk, data_i, rst, tx_pop_i, we_i, data_o, tx_ack_o, tx_data_o);
    end

endmodule
