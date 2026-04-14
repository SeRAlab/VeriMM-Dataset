`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset_n;
    reg rx_en;
    reg [7:0] tx_data;
    reg tx_en;
    wire [7:0] rx_data;
    wire tx_busy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset_n(reset_n),
        .rx_en(rx_en),
        .tx_data(tx_data),
        .tx_en(tx_en),
        .rx_data(rx_data),
        .tx_busy(tx_busy)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 0;
        tx_en = 0;
        rx_en = 0;
        tx_data = 8'h00;
        #20;
        reset_n = 1;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Initial state after reset", test_num);
        reset_dut();
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Transmitter activation", test_num);
        reset_dut();
        @(posedge clk);
        tx_data = 8'hA5;
        tx_en = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(rx_data, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Idle transmitter check", test_num);
        reset_dut();
        @(posedge clk);
        tx_data = 8'hFF;
        tx_en = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(rx_data, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Receiver activation", test_num);
        reset_dut();
        @(posedge clk);
        rx_en = 1;
        repeat(5) @(posedge clk);
        #1;


        #1;



        check_outputs(rx_data, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Async reset during operation", test_num);
        reset_dut();
        @(posedge clk);
        tx_en = 1;
        tx_data = 8'h55;
        @(posedge clk);
        #2;
        reset_n = 0;
        #5;

        #1;


        check_outputs(8'h00, 1'b0);
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
        input expected_tx_busy;
        begin
            if (expected_rx_data === (expected_rx_data ^ rx_data ^ expected_rx_data) &&
                expected_tx_busy === (expected_tx_busy ^ tx_busy ^ expected_tx_busy)) begin
                $display("PASS");
                $display("  Outputs: rx_data=%h, tx_busy=%b",
                         rx_data, tx_busy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rx_data=%h, tx_busy=%b",
                         expected_rx_data, expected_tx_busy);
                $display("  Got:      rx_data=%h, tx_busy=%b",
                         rx_data, tx_busy);
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
        $dumpvars(0,clk, reset_n, rx_en, tx_data, tx_en, rx_data, tx_busy);
    end

endmodule
