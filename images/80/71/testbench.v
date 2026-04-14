`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg new_des_one;
    reg rd_dma_done_one;
    reg rst;
    reg transferstart_one;
    wire [23:0] round_trip_latency;
    wire [23:0] transfer_duration;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .new_des_one(new_des_one),
        .rd_dma_done_one(rd_dma_done_one),
        .rst(rst),
        .transferstart_one(transferstart_one),
        .round_trip_latency(round_trip_latency),
        .transfer_duration(transfer_duration)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            new_des_one = 0;
            rd_dma_done_one = 0;
            transferstart_one = 0;
            repeat(5) @(posedge clk);
            rst = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic functional check", test_num);
            reset_dut();

            @(posedge clk);
            new_des_one = 1;
            @(posedge clk);
            new_des_one = 0;

            repeat (10) @(posedge clk);
            transferstart_one = 1;
            @(posedge clk);
            transferstart_one = 0;

            repeat (24) @(posedge clk);
            rd_dma_done_one = 1;
            @(posedge clk);
            rd_dma_done_one = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(24'd11, 24'd25);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Long latency, short duration", test_num);
            reset_dut();

            @(posedge clk);
            new_des_one = 1;
            @(posedge clk);
            new_des_one = 0;

            repeat (99) @(posedge clk);
            transferstart_one = 1;
            @(posedge clk);
            transferstart_one = 0;

            repeat (4) @(posedge clk);
            rd_dma_done_one = 1;
            @(posedge clk);
            rd_dma_done_one = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(24'd100, 24'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Minimal delay (1 cycle gaps)", test_num);
            reset_dut();

            @(posedge clk);
            new_des_one = 1;
            @(posedge clk);
            new_des_one = 0;

            transferstart_one = 1;
            @(posedge clk);
            transferstart_one = 0;

            rd_dma_done_one = 1;
            @(posedge clk);
            rd_dma_done_one = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(24'd1, 24'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large counter values", test_num);
            reset_dut();

            @(posedge clk);
            new_des_one = 1;
            @(posedge clk);
            new_des_one = 0;

            repeat (499) @(posedge clk);
            transferstart_one = 1;
            @(posedge clk);
            transferstart_one = 0;

            repeat (999) @(posedge clk);
            rd_dma_done_one = 1;
            @(posedge clk);
            rd_dma_done_one = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(24'd500, 24'd1000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Consecutive operations", test_num);
            reset_dut();


            @(posedge clk);
            new_des_one = 1; @(posedge clk); new_des_one = 0;
            repeat(4) @(posedge clk);
            transferstart_one = 1; @(posedge clk); transferstart_one = 0;
            repeat(4) @(posedge clk);
            rd_dma_done_one = 1; @(posedge clk); rd_dma_done_one = 0;


            repeat(5) @(posedge clk);
            new_des_one = 1; @(posedge clk); new_des_one = 0;
            repeat(19) @(posedge clk);
            transferstart_one = 1; @(posedge clk); transferstart_one = 0;
            repeat(29) @(posedge clk);
            rd_dma_done_one = 1; @(posedge clk); rd_dma_done_one = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(24'd20, 24'd30);
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
        input [23:0] expected_round_trip_latency;
        input [23:0] expected_transfer_duration;
        begin
            if (expected_round_trip_latency === (expected_round_trip_latency ^ round_trip_latency ^ expected_round_trip_latency) &&
                expected_transfer_duration === (expected_transfer_duration ^ transfer_duration ^ expected_transfer_duration)) begin
                $display("PASS");
                $display("  Outputs: round_trip_latency=%h, transfer_duration=%h",
                         round_trip_latency, transfer_duration);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: round_trip_latency=%h, transfer_duration=%h",
                         expected_round_trip_latency, expected_transfer_duration);
                $display("  Got:      round_trip_latency=%h, transfer_duration=%h",
                         round_trip_latency, transfer_duration);
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
        $dumpvars(0,clk, new_des_one, rd_dma_done_one, rst, transferstart_one, round_trip_latency, transfer_duration);
    end

endmodule
