`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rd_en;
    reg rst;
    reg wr_en;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rd_en(rd_en),
        .rst(rst),
        .wr_en(wr_en),
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
            wr_en = 0;
            rd_en = 0;
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Single Write/Read", test_num);
            reset_dut();


            data_in = 8'hA5;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;


            rd_en = 1;
            @(posedge clk);
            rd_en = 0;

            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Fill and Empty FIFO", test_num);
            reset_dut();


            for (i = 1; i <= 16; i = i + 1) begin
                data_in = i[7:0];
                wr_en = 1;
                @(posedge clk);
            end
            wr_en = 0;


            rd_en = 1;
            for (i = 1; i <= 16; i = i + 1) begin
                @(posedge clk);
            end
            rd_en = 0;

            #1;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pointer Wrap Around Logic", test_num);
            reset_dut();


            for (i = 1; i <= 12; i = i + 1) begin
                data_in = i[7:0];
                wr_en = 1;
                @(posedge clk);
            end
            wr_en = 0;


            rd_en = 1;
            for (i = 1; i <= 8; i = i + 1) @(posedge clk);
            rd_en = 0;


            for (i = 1; i <= 10; i = i + 1) begin
                data_in = 8'hD0 + i[7:0];
                wr_en = 1;
                @(posedge clk);
            end
            wr_en = 0;


            rd_en = 1;
            for (i = 1; i <= 14; i = i + 1) @(posedge clk);
            rd_en = 0;

            #1;
            #1;

            check_outputs(8'hDA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous Read and Write", test_num);
            reset_dut();


            data_in = 8'h11;
            wr_en = 1;
            @(posedge clk);


            data_in = 8'h22;
            wr_en = 1;
            rd_en = 1;
            @(posedge clk);


            wr_en = 0;
            rd_en = 0;

            #1;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset mid-operation", test_num);
            reset_dut();


            data_in = 8'hEE;
            wr_en = 1;
            @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;


            data_in = 8'hFF;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;
            rd_en = 1;
            @(posedge clk);
            rd_en = 0;

            #1;
            #1;

            check_outputs(8'hFF);
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, rd_en, rst, wr_en, data_out);
    end

endmodule
