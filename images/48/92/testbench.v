`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg tdd_rx_rf_en;
    reg tdd_rx_vco_en;
    reg tdd_tx_rf_en;
    reg tdd_tx_vco_en;
    wire ad9361_enable;
    wire [7:0] ad9361_tdd_status;
    wire ad9361_txnrx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .tdd_rx_rf_en(tdd_rx_rf_en),
        .tdd_rx_vco_en(tdd_rx_vco_en),
        .tdd_tx_rf_en(tdd_tx_rf_en),
        .tdd_tx_vco_en(tdd_tx_vco_en),
        .ad9361_enable(ad9361_enable),
        .ad9361_tdd_status(ad9361_tdd_status),
        .ad9361_txnrx(ad9361_txnrx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            tdd_rx_rf_en = 0;
            tdd_rx_vco_en = 0;
            tdd_tx_rf_en = 0;
            tdd_tx_vco_en = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: System Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: RX Mode Activation", test_num);
            reset_dut();
            @(posedge clk);
            tdd_rx_vco_en = 1;
            tdd_rx_rf_en = 1;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'h05, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: TX Mode Activation", test_num);
            reset_dut();
            @(posedge clk);
            tdd_tx_vco_en = 1;
            tdd_tx_rf_en = 1;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'h0A, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: RF Overlap Detection", test_num);
            reset_dut();
            @(posedge clk);
            tdd_rx_rf_en = 1;
            tdd_tx_rf_en = 1;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b0, 8'h20, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: VCO Overlap Detection", test_num);
            reset_dut();
            @(posedge clk);
            tdd_rx_vco_en = 1;
            tdd_tx_vco_en = 1;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b0, 8'h10, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: RX to TX Transition", test_num);
            reset_dut();

            tdd_rx_vco_en = 1;
            tdd_rx_rf_en = 1;
            repeat(3) @(posedge clk);

            tdd_rx_vco_en = 0;
            tdd_rx_rf_en = 0;
            tdd_tx_vco_en = 1;
            tdd_tx_rf_en = 1;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'h0A, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Partial Path (RF Only)", test_num);
            reset_dut();
            @(posedge clk);
            tdd_rx_rf_en = 1;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'h04, 1'b0);
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
        testcase007();
        
        
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
        input expected_ad9361_enable;
        input [7:0] expected_ad9361_tdd_status;
        input expected_ad9361_txnrx;
        begin
            if (expected_ad9361_enable === (expected_ad9361_enable ^ ad9361_enable ^ expected_ad9361_enable) &&
                expected_ad9361_tdd_status === (expected_ad9361_tdd_status ^ ad9361_tdd_status ^ expected_ad9361_tdd_status) &&
                expected_ad9361_txnrx === (expected_ad9361_txnrx ^ ad9361_txnrx ^ expected_ad9361_txnrx)) begin
                $display("PASS");
                $display("  Outputs: ad9361_enable=%b, ad9361_tdd_status=%h, ad9361_txnrx=%b",
                         ad9361_enable, ad9361_tdd_status, ad9361_txnrx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ad9361_enable=%b, ad9361_tdd_status=%h, ad9361_txnrx=%b",
                         expected_ad9361_enable, expected_ad9361_tdd_status, expected_ad9361_txnrx);
                $display("  Got:      ad9361_enable=%b, ad9361_tdd_status=%h, ad9361_txnrx=%b",
                         ad9361_enable, ad9361_tdd_status, ad9361_txnrx);
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
        $dumpvars(0,clk, rst, tdd_rx_rf_en, tdd_rx_vco_en, tdd_tx_rf_en, tdd_tx_vco_en, ad9361_enable, ad9361_tdd_status, ad9361_txnrx);
    end

endmodule
