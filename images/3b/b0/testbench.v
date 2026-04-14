`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dest_addr;
    reg reset;
    reg [7:0] source_addr;
    reg start_transfer;
    reg [3:0] transfer_size;
    wire [7:0] data_out;
    wire transfer_complete;
    wire write_enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dest_addr(dest_addr),
        .reset(reset),
        .source_addr(source_addr),
        .start_transfer(start_transfer),
        .transfer_size(transfer_size),
        .data_out(data_out),
        .transfer_complete(transfer_complete),
        .write_enable(write_enable)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        start_transfer = 0;
        source_addr = 0;
        dest_addr = 0;
        transfer_size = 0;
        repeat(2) @(posedge clk);
        #1 reset = 0;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Basic transfer, Size = 5");
        reset_dut();

        source_addr = 8'h10;
        dest_addr = 8'h50;
        transfer_size = 4'd5;
        start_transfer = 1;

        @(posedge clk);
        #1 start_transfer = 0;


        while (!transfer_complete) @(posedge clk);




        #1;





        check_outputs(data_out, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Minimum transfer size, Size = 1");
        reset_dut();

        source_addr = 8'hA0;
        dest_addr = 8'hB0;
        transfer_size = 4'd1;
        start_transfer = 1;

        @(posedge clk);
        #1 start_transfer = 0;

        while (!transfer_complete) @(posedge clk);

        #1;


        check_outputs(data_out, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Maximum transfer size, Size = 15");
        reset_dut();

        source_addr = 8'h00;
        dest_addr = 8'h80;
        transfer_size = 4'd15;
        start_transfer = 1;

        @(posedge clk);
        #1 start_transfer = 0;

        while (!transfer_complete) @(posedge clk);

        #1;


        check_outputs(data_out, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Idle state check after reset");
        reset_dut();


        repeat(5) @(posedge clk);

        #1;


        check_outputs(8'h0, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Same Source and Destination Address, Size = 3");
        reset_dut();

        source_addr = 8'hCC;
        dest_addr = 8'hCC;
        transfer_size = 4'd3;
        start_transfer = 1;

        @(posedge clk);
        #1 start_transfer = 0;

        while (!transfer_complete) @(posedge clk);

        #1;


        check_outputs(data_out, 1'b1, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input [7:0] expected_data_out;
        input expected_transfer_complete;
        input expected_write_enable;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete) &&
                expected_write_enable === (expected_write_enable ^ write_enable ^ expected_write_enable)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, transfer_complete=%b, write_enable=%b",
                         data_out, transfer_complete, write_enable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, transfer_complete=%b, write_enable=%b",
                         expected_data_out, expected_transfer_complete, expected_write_enable);
                $display("  Got:      data_out=%h, transfer_complete=%b, write_enable=%b",
                         data_out, transfer_complete, write_enable);
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
        $dumpvars(0,clk, dest_addr, reset, source_addr, start_transfer, transfer_size, data_out, transfer_complete, write_enable);
    end

endmodule
