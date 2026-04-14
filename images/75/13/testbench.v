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
            rx_fdata <= 32'h00000000;
            @(posedge rx_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Valid SOF (4'b0001) - Normal Operation", test_num);
            reset_dut();
            rx_sof   <= 4'b0001;
            rx_eof   <= 4'b1000;
            rx_ferr  <= 4'b0000;
            rx_fdata <= 32'hAABBCCDD;
            @(posedge rx_clk);
            #1;
            #1;

            check_outputs(32'hAABBCCDD, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Valid SOF (4'b0100) - Shifted Alignment", test_num);
            reset_dut();
            rx_sof   <= 4'b0100;
            rx_eof   <= 4'b0000;
            rx_ferr  <= 4'b0000;
            rx_fdata <= 32'h12345678;
            @(posedge rx_clk);
            #1;
            #1;

            check_outputs(32'h12345678, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Frame Error Signal Detected", test_num);
            reset_dut();
            rx_sof   <= 4'b0001;
            rx_eof   <= 4'b0000;
            rx_ferr  <= 4'b0010;
            rx_fdata <= 32'hFFFFFFFF;
            @(posedge rx_clk);
            #1;

            #1;


            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Invalid SOF Pattern (Multiple Bits)", test_num);
            reset_dut();
            rx_sof   <= 4'b0011;
            rx_eof   <= 4'b0000;
            rx_ferr  <= 4'b0000;
            rx_fdata <= 32'hDEADBEEF;
            @(posedge rx_clk);
            #1;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Invalid SOF Pattern (Zero SOF)", test_num);
            reset_dut();
            rx_sof   <= 4'b0000;
            rx_eof   <= 4'b0000;
            rx_ferr  <= 4'b0000;
            rx_fdata <= 32'h11112222;
            @(posedge rx_clk);
            #1;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: SOF with concurrent Ferr", test_num);
            reset_dut();
            rx_sof   <= 4'b1000;
            rx_eof   <= 4'b0000;
            rx_ferr  <= 4'b1111;
            rx_fdata <= 32'h88776655;
            @(posedge rx_clk);
            #1;
            #1;

            check_outputs(32'h00000000, 1'b1);
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
