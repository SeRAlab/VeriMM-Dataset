`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [23:0] din_data;
    reg din_eop;
    reg din_sop;
    reg din_valid;
    reg rst;
    reg start;
    reg [8:0] usedw_fifo_out;
    wire [31:0] data_fifo_out;
    wire data_valid_fifo_out;
    wire din_ready;
    wire endf;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din_data(din_data),
        .din_eop(din_eop),
        .din_sop(din_sop),
        .din_valid(din_valid),
        .rst(rst),
        .start(start),
        .usedw_fifo_out(usedw_fifo_out),
        .data_fifo_out(data_fifo_out),
        .data_valid_fifo_out(data_valid_fifo_out),
        .din_ready(din_ready),
        .endf(endf)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            din_data = 0;
            din_valid = 0;
            din_sop = 0;
            din_eop = 0;
            usedw_fifo_out = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase%03d: Basic Frame Write", test_num);
            reset_dut();


            start = 1;
            @(posedge clk);


            din_valid = 1;
            din_sop = 1;
            din_data = 24'hAAAAAA;
            @(posedge clk);


            din_sop = 0;
            din_data = 24'hBBBBBB;
            @(posedge clk);


            din_eop = 1;
            din_data = 24'hCCCCCC;
            @(posedge clk);


            din_valid = 0;
            din_eop = 0;
            din_data = 0;


            repeat(1) @(posedge clk);



            #1;




            check_outputs(32'h00CCCCCC, 0, 1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase%03d: Start Signal Gating", test_num);
            reset_dut();


            start = 0;
            din_valid = 1;
            din_sop = 1;
            din_data = 24'h123456;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase%03d: FIFO Backpressure", test_num);
            reset_dut();

            start = 1;

            usedw_fifo_out = 9'h1FF;

            @(posedge clk);


            #1;



            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase%03d: Data Path Integrity", test_num);
            reset_dut();

            start = 1;
            @(posedge clk);


            din_valid = 1;
            din_sop = 1;
            din_data = 24'h55AAFF;


            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0055AAFF, 1, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase%03d: Mid-transaction Reset", test_num);
            reset_dut();

            start = 1;
            @(posedge clk);
            din_valid = 1;
            din_sop = 1;
            din_data = 24'hFFFFFF;
            @(posedge clk);


            rst = 1;
            @(posedge clk);


            #1;



            check_outputs(0, 0, 0, 0);
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
        input [31:0] expected_data_fifo_out;
        input expected_data_valid_fifo_out;
        input expected_din_ready;
        input expected_endf;
        begin
            if (expected_data_fifo_out === (expected_data_fifo_out ^ data_fifo_out ^ expected_data_fifo_out) &&
                expected_data_valid_fifo_out === (expected_data_valid_fifo_out ^ data_valid_fifo_out ^ expected_data_valid_fifo_out) &&
                expected_din_ready === (expected_din_ready ^ din_ready ^ expected_din_ready) &&
                expected_endf === (expected_endf ^ endf ^ expected_endf)) begin
                $display("PASS");
                $display("  Outputs: data_fifo_out=%h, data_valid_fifo_out=%b, din_ready=%b, endf=%b",
                         data_fifo_out, data_valid_fifo_out, din_ready, endf);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_fifo_out=%h, data_valid_fifo_out=%b, din_ready=%b, endf=%b",
                         expected_data_fifo_out, expected_data_valid_fifo_out, expected_din_ready, expected_endf);
                $display("  Got:      data_fifo_out=%h, data_valid_fifo_out=%b, din_ready=%b, endf=%b",
                         data_fifo_out, data_valid_fifo_out, din_ready, endf);
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
        $dumpvars(0,clk, din_data, din_eop, din_sop, din_valid, rst, start, usedw_fifo_out, data_fifo_out, data_valid_fifo_out, din_ready, endf);
    end

endmodule
