`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg rd_clk;
    reg rd_read;
    reg [2:0] rd_wr_gray_pointer;
    reg reset;
    wire [1:0] rd_addr;
    wire rd_fifo_empty;
    wire [2:0] rd_gray_pointer;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rd_clk(rd_clk),
        .rd_read(rd_read),
        .rd_wr_gray_pointer(rd_wr_gray_pointer),
        .reset(reset),
        .rd_addr(rd_addr),
        .rd_fifo_empty(rd_fifo_empty),
        .rd_gray_pointer(rd_gray_pointer)
    );

    // Clock generation (10ns period)
    initial begin
        rd_clk = 0;
        forever #5 rd_clk = ~rd_clk;
    end

        task reset_dut;

        begin
            rd_clk = 0;
            rd_read = 0;
            rd_wr_gray_pointer = 3'b000;
            reset = 1;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Reset and Initial Empty State", test_num);
            reset_dut();
            rd_wr_gray_pointer = 3'b000;
            #10;

            #1;


            check_outputs(2'b00, 1'b1, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: FIFO Not Empty State", test_num);
            reset_dut();
            rd_wr_gray_pointer = 3'b001;
            #10;

            #1;


            check_outputs(2'b00, 1'b0, 3'b000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Read Operation", test_num);
            reset_dut();
            rd_wr_gray_pointer = 3'b011;
            #5;
            rd_read = 1;
            #10;
            rd_read = 0;
            #5;

            #1;


            check_outputs(2'b01, 1'b0, 3'b001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Read Until Empty", test_num);
            reset_dut();
            rd_wr_gray_pointer = 3'b011;
            #5;
            rd_read = 1;
            #20;
            rd_read = 0;
            #5;

            #1;


            check_outputs(2'b10, 1'b1, 3'b011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pointer Wrap Around and Rollover", test_num);
            reset_dut();
            rd_wr_gray_pointer = 3'b110;
            #5;
            rd_read = 1;
            #40;
            rd_read = 0;
            #5;

            #1;


            check_outputs(2'b00, 1'b1, 3'b110);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Underflow Prevention", test_num);
            reset_dut();
            rd_wr_gray_pointer = 3'b000;
            #5;
            rd_read = 1;
            #20;
            rd_read = 0;
            #5;

            #1;


            check_outputs(2'b00, 1'b1, 3'b000);
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
        input [1:0] expected_rd_addr;
        input expected_rd_fifo_empty;
        input [2:0] expected_rd_gray_pointer;
        begin
            if (expected_rd_addr === (expected_rd_addr ^ rd_addr ^ expected_rd_addr) &&
                expected_rd_fifo_empty === (expected_rd_fifo_empty ^ rd_fifo_empty ^ expected_rd_fifo_empty) &&
                expected_rd_gray_pointer === (expected_rd_gray_pointer ^ rd_gray_pointer ^ expected_rd_gray_pointer)) begin
                $display("PASS");
                $display("  Outputs: rd_addr=%h, rd_fifo_empty=%b, rd_gray_pointer=%h",
                         rd_addr, rd_fifo_empty, rd_gray_pointer);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_addr=%h, rd_fifo_empty=%b, rd_gray_pointer=%h",
                         expected_rd_addr, expected_rd_fifo_empty, expected_rd_gray_pointer);
                $display("  Got:      rd_addr=%h, rd_fifo_empty=%b, rd_gray_pointer=%h",
                         rd_addr, rd_fifo_empty, rd_gray_pointer);
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
        $dumpvars(0,rd_clk, rd_read, rd_wr_gray_pointer, reset, rd_addr, rd_fifo_empty, rd_gray_pointer);
    end

endmodule
