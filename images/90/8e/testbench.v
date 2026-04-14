`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rx_en;
    reg [7:0] tx_data;
    reg tx_en;
    wire [7:0] rx_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rx_en(rx_en),
        .tx_data(tx_data),
        .tx_en(tx_en),
        .rx_data(rx_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        tx_en = 0;
        rx_en = 0;
        tx_data = 8'h00;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: High Amplitude (tx_data[0]=1)", test_num);
        tx_en = 1;
        rx_en = 1;
        tx_data = 8'hA1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Low Amplitude (tx_data[0]=0)", test_num);
        tx_en = 1;
        rx_en = 1;
        tx_data = 8'hB0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hB0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Transmitter Disabled (defaults to Low Amplitude)", test_num);
        tx_en = 0;
        rx_en = 1;
        tx_data = 8'h55;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Data 8'hFE (LSB=0)", test_num);
        tx_en = 1;
        rx_en = 1;
        tx_data = 8'hFE;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Data 8'h01 (LSB=1)", test_num);
        tx_en = 1;
        rx_en = 1;
        tx_data = 8'h01;
        @(posedge clk);
        #2;
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
        input [7:0] expected_rx_data;
        begin
            if (expected_rx_data === (expected_rx_data ^ rx_data ^ expected_rx_data)) begin
                $display("PASS");
                $display("  Outputs: rx_data=%h",
                         rx_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rx_data=%h",
                         expected_rx_data);
                $display("  Got:      rx_data=%h",
                         rx_data);
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
        $dumpvars(0,clk, rx_en, tx_data, tx_en, rx_data);
    end

endmodule
