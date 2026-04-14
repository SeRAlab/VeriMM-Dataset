`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg rx_clk;
    reg [3:0] rx_eof;
    reg [31:0] rx_fdata;
    reg [3:0] rx_ferr;
    reg [3:0] rx_sof;
    wire [31:0] rx_data;
    wire rx_err;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rx_clk(rx_clk),
        .rx_eof(rx_eof),
        .rx_fdata(rx_fdata),
        .rx_ferr(rx_ferr),
        .rx_sof(rx_sof),
        .rx_data(rx_data),
        .rx_err(rx_err)
    );

    // Clock generation (10ns period)
    initial begin
        rx_clk = 0;
        forever #5 rx_clk = ~rx_clk;
    end

        task reset_dut;

        begin
            rx_sof   <= 4'b0000;
            rx_eof   <= 4'b0000;
            rx_ferr  <= 4'b0000;
            rx_fdata <= 32'h0;
            repeat(2) @(posedge rx_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Valid SOF at Byte 0 (Standard Data)", test_num);

            @(negedge rx_clk);
            rx_sof   <= 4'b0001;
            rx_fdata <= 32'hAABBCCDD;
            rx_ferr  <= 4'b0000;

            @(posedge rx_clk);
            #1;
            #1;

            check_outputs(32'hAABBCCDD, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Reordering Case (SOF at Byte 1)", test_num);


            @(negedge rx_clk);
            rx_fdata <= 32'h11223344;
            rx_sof   <= 4'b0000;


            @(negedge rx_clk);
            rx_sof   <= 4'b0010;
            rx_fdata <= 32'h55667788;

            @(posedge rx_clk);
            #1;


            #1;



            check_outputs(32'h66778811, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Frame Error Condition (rx_ferr active)", test_num);

            @(negedge rx_clk);
            rx_sof   <= 4'b0001;
            rx_fdata <= 32'hDEADBEEF;
            rx_ferr  <= 4'b0001;

            @(posedge rx_clk);
            #1;

            #1;


            check_outputs(32'hFFFFFFFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Invalid Alignment Case (SOF = 4'b1000)", test_num);

            @(negedge rx_clk);
            rx_sof   <= 4'b1000;
            rx_fdata <= 32'h12345678;

            @(posedge rx_clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Idle state followed by valid SOF", test_num);

            @(negedge rx_clk);
            rx_sof   <= 4'b0000;

            @(negedge rx_clk);
            rx_sof   <= 4'b0001;
            rx_fdata <= 32'h13572468;

            @(posedge rx_clk);
            #1;
            #1;

            check_outputs(32'h13572468, 1'b0);
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
        input [31:0] expected_rx_data;
        input expected_rx_err;
        begin
            if (expected_rx_data === (expected_rx_data ^ rx_data ^ expected_rx_data) &&
                expected_rx_err === (expected_rx_err ^ rx_err ^ expected_rx_err)) begin
                $display("PASS");
                $display("  Outputs: rx_data=%h, rx_err=%b",
                         rx_data, rx_err);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rx_data=%h, rx_err=%b",
                         expected_rx_data, expected_rx_err);
                $display("  Got:      rx_data=%h, rx_err=%b",
                         rx_data, rx_err);
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
        $dumpvars(0,rx_clk, rx_eof, rx_fdata, rx_ferr, rx_sof, rx_data, rx_err);
    end

endmodule
