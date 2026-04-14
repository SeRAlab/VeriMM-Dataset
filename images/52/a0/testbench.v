`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg channel_in_ack;
    reg [31:0] channel_out_data;
    reg channel_out_en;
    reg clk;
    reg rst;
    wire [31:0] channel_in_data;
    wire channel_in_en;
    wire channel_out_ack;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .channel_in_ack(channel_in_ack),
        .channel_out_data(channel_out_data),
        .channel_out_en(channel_out_en),
        .clk(clk),
        .rst(rst),
        .channel_in_data(channel_in_data),
        .channel_in_en(channel_in_en),
        .channel_out_ack(channel_out_ack)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            channel_in_ack = 0;
            channel_out_data = 0;
            channel_out_en = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Data Propagation (TRANSMIT)", test_num);
            reset_dut();
            @(posedge clk);
            channel_out_en = 1;
            channel_out_data = 32'hDEADBEEF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hDEADBEEF, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Full Handshake (RECEIVE)", test_num);
            reset_dut();
            @(posedge clk);
            channel_out_en = 1;
            channel_out_data = 32'hA5A5A5A5;
            @(posedge clk);
            #1 channel_in_ack = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hA5A5A5A5, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Stall Check (No In Ack)", test_num);
            reset_dut();
            @(posedge clk);
            channel_out_en = 1;
            channel_out_data = 32'h12345678;
            repeat(5) @(posedge clk);
            #2;

            #1;


            check_outputs(32'h12345678, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Cycle Completion", test_num);
            reset_dut();
            @(posedge clk);
            channel_out_en = 1;
            channel_out_data = 32'hFFFFFFFF;
            @(posedge clk);
            #1 channel_in_ack = 1;
            @(posedge clk);
            #1 channel_out_en = 0;
            channel_in_ack = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0, 0, 0);
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
        input [31:0] expected_channel_in_data;
        input expected_channel_in_en;
        input expected_channel_out_ack;
        begin
            if (expected_channel_in_data === (expected_channel_in_data ^ channel_in_data ^ expected_channel_in_data) &&
                expected_channel_in_en === (expected_channel_in_en ^ channel_in_en ^ expected_channel_in_en) &&
                expected_channel_out_ack === (expected_channel_out_ack ^ channel_out_ack ^ expected_channel_out_ack)) begin
                $display("PASS");
                $display("  Outputs: channel_in_data=%h, channel_in_en=%b, channel_out_ack=%b",
                         channel_in_data, channel_in_en, channel_out_ack);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: channel_in_data=%h, channel_in_en=%b, channel_out_ack=%b",
                         expected_channel_in_data, expected_channel_in_en, expected_channel_out_ack);
                $display("  Got:      channel_in_data=%h, channel_in_en=%b, channel_out_ack=%b",
                         channel_in_data, channel_in_en, channel_out_ack);
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
        $dumpvars(0,channel_in_ack, channel_out_data, channel_out_en, clk, rst, channel_in_data, channel_in_en, channel_out_ack);
    end

endmodule
