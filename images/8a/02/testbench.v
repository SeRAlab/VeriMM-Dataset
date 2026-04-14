`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg generated_clk;
    reg mac_tx_en;
    reg mac_tx_er;
    reg [7:0] mac_txd;
    reg phy_rx_clk;
    reg phy_rx_ctl_falling;
    reg phy_rx_ctl_rising;
    reg [3:0] phy_rxd_falling;
    reg [3:0] phy_rxd_rising;
    reg reset;
    wire mac_col;
    wire mac_crs;
    wire mac_rx_clk;
    wire mac_rx_dv;
    wire mac_rx_er;
    wire [7:0] mac_rxd;
    wire mac_tx_clk;
    wire phy_gtx_clk;
    wire phy_tx_ctl_falling;
    wire phy_tx_ctl_rising;
    wire [3:0] phy_txd_falling;
    wire [3:0] phy_txd_rising;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .generated_clk(generated_clk),
        .mac_tx_en(mac_tx_en),
        .mac_tx_er(mac_tx_er),
        .mac_txd(mac_txd),
        .phy_rx_clk(phy_rx_clk),
        .phy_rx_ctl_falling(phy_rx_ctl_falling),
        .phy_rx_ctl_rising(phy_rx_ctl_rising),
        .phy_rxd_falling(phy_rxd_falling),
        .phy_rxd_rising(phy_rxd_rising),
        .reset(reset),
        .mac_col(mac_col),
        .mac_crs(mac_crs),
        .mac_rx_clk(mac_rx_clk),
        .mac_rx_dv(mac_rx_dv),
        .mac_rx_er(mac_rx_er),
        .mac_rxd(mac_rxd),
        .mac_tx_clk(mac_tx_clk),
        .phy_gtx_clk(phy_gtx_clk),
        .phy_tx_ctl_falling(phy_tx_ctl_falling),
        .phy_tx_ctl_rising(phy_tx_ctl_rising),
        .phy_txd_falling(phy_txd_falling),
        .phy_txd_rising(phy_txd_rising)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset / Idle State", test_num);
            reset = 1;
            generated_clk = 0;
            phy_rx_clk = 0;
            mac_tx_en = 0;
            mac_tx_er = 0;
            mac_txd = 8'h00;
            phy_rx_ctl_rising = 0;
            phy_rx_ctl_falling = 0;
            phy_rxd_rising = 4'h0;
            phy_rxd_falling = 4'h0;
            #10;
            reset = 0;
            #10;

            #1;


            check_outputs(0, 0, 0, 0, 0, 8'h00, 0, 0, 0, 0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Transmit Data (Normal)", test_num);
            reset = 0;
            generated_clk = 1;
            mac_tx_en = 1;
            mac_tx_er = 0;
            mac_txd = 8'hA5;
            #10;

            #1;


            check_outputs(0, 1, 0, 0, 0, 8'h00, 1, 1, 1, 1, 4'hA, 4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Transmit Data (with Error)", test_num);
            reset = 0;
            generated_clk = 0;
            mac_tx_en = 1;
            mac_tx_er = 1;
            mac_txd = 8'h3C;
            #10;

            #1;


            check_outputs(0, 1, 0, 0, 0, 8'h00, 0, 0, 0, 1, 4'h3, 4'hC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Receive Data (Normal)", test_num);
            reset = 0;
            phy_rx_clk = 1;
            mac_tx_en = 0;
            phy_rx_ctl_rising = 1;
            phy_rx_ctl_falling = 1;
            phy_rxd_rising = 4'hB;
            phy_rxd_falling = 4'hD;
            #10;

            #1;


            check_outputs(0, 1, 1, 1, 0, 8'hDB, 0, 0, 0, 0, 4'h0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Receive Data (with Error)", test_num);
            reset = 0;
            phy_rx_clk = 0;
            mac_tx_en = 0;
            phy_rx_ctl_rising = 1;
            phy_rx_ctl_falling = 0;
            phy_rxd_rising = 4'h2;
            phy_rxd_falling = 4'hF;
            #10;

            #1;


            check_outputs(0, 1, 0, 1, 1, 8'hF2, 0, 0, 0, 0, 4'h0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Collision Detection", test_num);
            reset = 0;
            generated_clk = 1;
            phy_rx_clk = 1;
            mac_tx_en = 1;
            phy_rx_ctl_rising = 1;
            #10;


            if (mac_col === 1'b1 && mac_crs === 1'b1) begin
                pass_count = pass_count + 1;
                $display("PASS: Collision and Carrier Sense detected");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Collision/Carrier Sense logic incorrect. Col: %b, Crs: %b", mac_col, mac_crs);
            end
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Transmit Carrier Extension (Idle TX_EN=0, TX_ER=1)", test_num);
            reset = 0;
            generated_clk = 0;
            mac_tx_en = 0;
            mac_tx_er = 1;
            mac_txd = 8'h0F;
            #10;

            #1;


            check_outputs(0, 0, 0, 0, 0, 8'h00, 0, 0, 1, 0, 4'h0, 4'hF);
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
        input expected_phy_tx_ctl_falling;
        input expected_phy_tx_ctl_rising;
        input [3:0] expected_phy_txd_falling;
        input [3:0] expected_phy_txd_rising;
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
                expected_phy_tx_ctl_falling === (expected_phy_tx_ctl_falling ^ phy_tx_ctl_falling ^ expected_phy_tx_ctl_falling) &&
                expected_phy_tx_ctl_rising === (expected_phy_tx_ctl_rising ^ phy_tx_ctl_rising ^ expected_phy_tx_ctl_rising) &&
                expected_phy_txd_falling === (expected_phy_txd_falling ^ phy_txd_falling ^ expected_phy_txd_falling) &&
                expected_phy_txd_rising === (expected_phy_txd_rising ^ phy_txd_rising ^ expected_phy_txd_rising)) begin
                $display("PASS");
                $display("  Outputs: mac_col=%b, mac_crs=%b, mac_rx_clk=%b, mac_rx_dv=%b, mac_rx_er=%b, mac_rxd=%h, mac_tx_clk=%b, phy_gtx_clk=%b, phy_tx_ctl_falling=%b, phy_tx_ctl_rising=%b, phy_txd_falling=%h, phy_txd_rising=%h",
                         mac_col, mac_crs, mac_rx_clk, mac_rx_dv, mac_rx_er, mac_rxd, mac_tx_clk, phy_gtx_clk, phy_tx_ctl_falling, phy_tx_ctl_rising, phy_txd_falling, phy_txd_rising);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mac_col=%b, mac_crs=%b, mac_rx_clk=%b, mac_rx_dv=%b, mac_rx_er=%b, mac_rxd=%h, mac_tx_clk=%b, phy_gtx_clk=%b, phy_tx_ctl_falling=%b, phy_tx_ctl_rising=%b, phy_txd_falling=%h, phy_txd_rising=%h",
                         expected_mac_col, expected_mac_crs, expected_mac_rx_clk, expected_mac_rx_dv, expected_mac_rx_er, expected_mac_rxd, expected_mac_tx_clk, expected_phy_gtx_clk, expected_phy_tx_ctl_falling, expected_phy_tx_ctl_rising, expected_phy_txd_falling, expected_phy_txd_rising);
                $display("  Got:      mac_col=%b, mac_crs=%b, mac_rx_clk=%b, mac_rx_dv=%b, mac_rx_er=%b, mac_rxd=%h, mac_tx_clk=%b, phy_gtx_clk=%b, phy_tx_ctl_falling=%b, phy_tx_ctl_rising=%b, phy_txd_falling=%h, phy_txd_rising=%h",
                         mac_col, mac_crs, mac_rx_clk, mac_rx_dv, mac_rx_er, mac_rxd, mac_tx_clk, phy_gtx_clk, phy_tx_ctl_falling, phy_tx_ctl_rising, phy_txd_falling, phy_txd_rising);
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
