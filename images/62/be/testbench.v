`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock_125MHz;
    reg mac_tx_en;
    reg mac_tx_er;
    reg [7:0] mac_txd;
    reg phy_col;
    reg phy_crs;
    reg phy_rx_clk;
    reg phy_rx_dv;
    reg phy_rx_er;
    reg [7:0] phy_rxd;
    reg reset;
    wire mac_col;
    wire mac_crs;
    wire mac_rx_clk;
    wire mac_rx_dv;
    wire mac_rx_er;
    wire [7:0] mac_rxd;
    wire mac_tx_clk;
    wire phy_gtx_clk;
    wire phy_tx_en;
    wire phy_tx_er;
    wire [7:0] phy_txd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock_125MHz(clock_125MHz),
        .mac_tx_en(mac_tx_en),
        .mac_tx_er(mac_tx_er),
        .mac_txd(mac_txd),
        .phy_col(phy_col),
        .phy_crs(phy_crs),
        .phy_rx_clk(phy_rx_clk),
        .phy_rx_dv(phy_rx_dv),
        .phy_rx_er(phy_rx_er),
        .phy_rxd(phy_rxd),
        .reset(reset),
        .mac_col(mac_col),
        .mac_crs(mac_crs),
        .mac_rx_clk(mac_rx_clk),
        .mac_rx_dv(mac_rx_dv),
        .mac_rx_er(mac_rx_er),
        .mac_rxd(mac_rxd),
        .mac_tx_clk(mac_tx_clk),
        .phy_gtx_clk(phy_gtx_clk),
        .phy_tx_en(phy_tx_en),
        .phy_tx_er(phy_tx_er),
        .phy_txd(phy_txd)
    );
    task testcase001;

    begin
        test_num = 1;
        reset = 1;
        mac_tx_en = 0; mac_tx_er = 0; mac_txd = 8'h00;
        phy_col = 0; phy_crs = 0; phy_rx_dv = 0; phy_rx_er = 0; phy_rxd = 8'h00;
        #20;
        reset = 0;
        #10;

        #1;


        check_outputs(0, 0, phy_rx_clk, 0, 0, 8'h00, clock_125MHz, clock_125MHz, 0, 0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset = 1; #10; reset = 0; #10;
        mac_tx_en = 1;
        mac_tx_er = 0;
        mac_txd = 8'h55;
        #10;
        #1;

        check_outputs(0, 0, phy_rx_clk, 0, 0, 8'h00, clock_125MHz, clock_125MHz, 1, 0, 8'h55);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset = 1; #10; reset = 0; #10;
        mac_tx_en = 1;
        mac_tx_er = 1;
        mac_txd = 8'hAA;
        #10;
        #1;

        check_outputs(0, 0, phy_rx_clk, 0, 0, 8'h00, clock_125MHz, clock_125MHz, 1, 1, 8'hAA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset = 1; #10; reset = 0; #10;
        phy_rx_dv = 1;
        phy_rx_er = 0;
        phy_rxd = 8'hDE;
        #10;
        #1;

        check_outputs(0, 0, phy_rx_clk, 1, 0, 8'hDE, clock_125MHz, clock_125MHz, 0, 0, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset = 1; #10; reset = 0; #10;
        phy_rx_dv = 1;
        phy_rx_er = 1;
        phy_rxd = 8'hAD;
        #10;
        #1;

        check_outputs(0, 0, phy_rx_clk, 1, 1, 8'hAD, clock_125MHz, clock_125MHz, 0, 0, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset = 1; #10; reset = 0; #10;
        phy_col = 1;
        phy_crs = 1;
        #10;
        #1;

        check_outputs(1, 1, phy_rx_clk, 0, 0, 8'h00, clock_125MHz, clock_125MHz, 0, 0, 8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset = 1; #10; reset = 0; #10;

        mac_tx_en = 1; mac_txd = 8'h11;

        phy_rx_dv = 1; phy_rxd = 8'h22;
        #10;
        #1;

        check_outputs(0, 0, phy_rx_clk, 1, 0, 8'h22, clock_125MHz, clock_125MHz, 1, 0, 8'h11);
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
        input expected_mac_col;
        input expected_mac_crs;
        input expected_mac_rx_clk;
        input expected_mac_rx_dv;
        input expected_mac_rx_er;
        input [7:0] expected_mac_rxd;
        input expected_mac_tx_clk;
        input expected_phy_gtx_clk;
        input expected_phy_tx_en;
        input expected_phy_tx_er;
        input [7:0] expected_phy_txd;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mac_col === (expected_mac_col ^ mac_col ^ expected_mac_col) &&
                expected_mac_crs === (expected_mac_crs ^ mac_crs ^ expected_mac_crs) &&
                expected_mac_rx_clk === (expected_mac_rx_clk ^ mac_rx_clk ^ expected_mac_rx_clk) &&
                expected_mac_rx_dv === (expected_mac_rx_dv ^ mac_rx_dv ^ expected_mac_rx_dv) &&
                expected_mac_rx_er === (expected_mac_rx_er ^ mac_rx_er ^ expected_mac_rx_er) &&
                expected_mac_rxd === (expected_mac_rxd ^ mac_rxd ^ expected_mac_rxd) &&
                expected_mac_tx_clk === (expected_mac_tx_clk ^ mac_tx_clk ^ expected_mac_tx_clk) &&
                expected_phy_gtx_clk === (expected_phy_gtx_clk ^ phy_gtx_clk ^ expected_phy_gtx_clk) &&
                expected_phy_tx_en === (expected_phy_tx_en ^ phy_tx_en ^ expected_phy_tx_en) &&
                expected_phy_tx_er === (expected_phy_tx_er ^ phy_tx_er ^ expected_phy_tx_er) &&
                expected_phy_txd === (expected_phy_txd ^ phy_txd ^ expected_phy_txd)) begin
                $display("PASS");
                $display("  Outputs: mac_col=%b, mac_crs=%b, mac_rx_clk=%b, mac_rx_dv=%b, mac_rx_er=%b, mac_rxd=%h, mac_tx_clk=%b, phy_gtx_clk=%b, phy_tx_en=%b, phy_tx_er=%b, phy_txd=%h",
                         mac_col, mac_crs, mac_rx_clk, mac_rx_dv, mac_rx_er, mac_rxd, mac_tx_clk, phy_gtx_clk, phy_tx_en, phy_tx_er, phy_txd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mac_col=%b, mac_crs=%b, mac_rx_clk=%b, mac_rx_dv=%b, mac_rx_er=%b, mac_rxd=%h, mac_tx_clk=%b, phy_gtx_clk=%b, phy_tx_en=%b, phy_tx_er=%b, phy_txd=%h",
                         expected_mac_col, expected_mac_crs, expected_mac_rx_clk, expected_mac_rx_dv, expected_mac_rx_er, expected_mac_rxd, expected_mac_tx_clk, expected_phy_gtx_clk, expected_phy_tx_en, expected_phy_tx_er, expected_phy_txd);
                $display("  Got:      mac_col=%b, mac_crs=%b, mac_rx_clk=%b, mac_rx_dv=%b, mac_rx_er=%b, mac_rxd=%h, mac_tx_clk=%b, phy_gtx_clk=%b, phy_tx_en=%b, phy_tx_er=%b, phy_txd=%h",
                         mac_col, mac_crs, mac_rx_clk, mac_rx_dv, mac_rx_er, mac_rxd, mac_tx_clk, phy_gtx_clk, phy_tx_en, phy_tx_er, phy_txd);
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

endmodule
