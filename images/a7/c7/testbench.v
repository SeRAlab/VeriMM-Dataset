`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [23:0] fifo_size;
    reg [1:0] ready;
    reg rst;
    reg [23:0] write_count;
    wire [1:0] activate;
    wire [31:0] fifo_data;
    wire finished;
    wire strobe;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .fifo_size(fifo_size),
        .ready(ready),
        .rst(rst),
        .write_count(write_count),
        .activate(activate),
        .fifo_data(fifo_data),
        .finished(finished),
        .strobe(strobe)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        enable = 0;
        fifo_size = 0;
        ready = 0;
        write_count = 0;
        @(posedge clk);
        #2 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Single write Channel 0", test_num);
        reset_dut();

        fifo_size = 24'd10;
        write_count = 24'd1;
        ready = 2'b01;
        enable = 1;


        while (!finished) @(posedge clk);


        @(posedge clk);
        #1 #1;
 check_outputs(2'b00, 32'hXXXXXXXX, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Single write Channel 1", test_num);
        reset_dut();

        fifo_size = 24'd10;
        write_count = 24'd1;
        ready = 2'b10;
        enable = 1;

        while (!finished) @(posedge clk);

        @(posedge clk);
        #1 #1;
 check_outputs(2'b00, 32'hXXXXXXXX, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Multiple writes (Count 4)", test_num);
        reset_dut();

        fifo_size = 24'd10;
        write_count = 24'd4;
        ready = 2'b01;
        enable = 1;

        while (!finished) @(posedge clk);

        @(posedge clk);
        #1 #1;
 check_outputs(2'b00, 32'hXXXXXXXX, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: FIFO Size Limit (Size 2, Count 5)", test_num);
        reset_dut();

        fifo_size = 24'd2;
        write_count = 24'd5;
        ready = 2'b01;
        enable = 1;


        while (!finished) @(posedge clk);

        @(posedge clk);
        #1 #1;
 check_outputs(2'b00, 32'hXXXXXXXX, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Stall behavior", test_num);
        reset_dut();

        fifo_size = 24'd10;
        write_count = 24'd1;
        ready = 2'b00;
        enable = 1;


        repeat(5) @(posedge clk);

        ready = 2'b10;

        while (!finished) @(posedge clk);

        @(posedge clk);
        #1 #1;
 check_outputs(2'b00, 32'hXXXXXXXX, 1'b1, 1'b0);
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
        input [1:0] expected_activate;
        input [31:0] expected_fifo_data;
        input expected_finished;
        input expected_strobe;
        begin
            if (expected_activate === (expected_activate ^ activate ^ expected_activate) &&
                expected_fifo_data === (expected_fifo_data ^ fifo_data ^ expected_fifo_data) &&
                expected_finished === (expected_finished ^ finished ^ expected_finished) &&
                expected_strobe === (expected_strobe ^ strobe ^ expected_strobe)) begin
                $display("PASS");
                $display("  Outputs: activate=%h, fifo_data=%h, finished=%b, strobe=%b",
                         activate, fifo_data, finished, strobe);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: activate=%h, fifo_data=%h, finished=%b, strobe=%b",
                         expected_activate, expected_fifo_data, expected_finished, expected_strobe);
                $display("  Got:      activate=%h, fifo_data=%h, finished=%b, strobe=%b",
                         activate, fifo_data, finished, strobe);
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
        $dumpvars(0,clk, enable, fifo_size, ready, rst, write_count, activate, fifo_data, finished, strobe);
    end

endmodule
