`timescale 1ns/1ps

module Phy_int_tb;

    // Testbench signals (sequential circuit)
    reg Col;
    reg Crs;
    reg Line_loop_en;
    reg MAC_rx_clk;
    reg MAC_tx_clk;
    reg [7:0] MTxD;
    reg MTxEn;
    reg Reset;
    reg Rx_dv;
    reg Rx_er;
    reg [7:0] Rxd;
    reg [2:0] Speed;
    wire MCRS;
    wire MCrs_dv;
    wire [7:0] MRxD;
    wire MRxErr;
    wire Tx_en;
    wire Tx_er;
    wire [7:0] Txd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Phy_int dut (
        .Col(Col),
        .Crs(Crs),
        .Line_loop_en(Line_loop_en),
        .MAC_rx_clk(MAC_rx_clk),
        .MAC_tx_clk(MAC_tx_clk),
        .MTxD(MTxD),
        .MTxEn(MTxEn),
        .Reset(Reset),
        .Rx_dv(Rx_dv),
        .Rx_er(Rx_er),
        .Rxd(Rxd),
        .Speed(Speed),
        .MCRS(MCRS),
        .MCrs_dv(MCrs_dv),
        .MRxD(MRxD),
        .MRxErr(MRxErr),
        .Tx_en(Tx_en),
        .Tx_er(Tx_er),
        .Txd(Txd)
    );

    // Clock generation (10ns period)
    initial begin
        MAC_rx_clk = 0;
        forever #5 MAC_rx_clk = ~MAC_rx_clk;
    end

    task reset_dut;
    //define reset task
    endtask
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Phy_int Testbench");
        $display("========================================");


        
        
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
        input expected_MCRS;
        input expected_MCrs_dv;
        input [7:0] expected_MRxD;
        input expected_MRxErr;
        input expected_Tx_en;
        input expected_Tx_er;
        input [7:0] expected_Txd;
        begin
            if (expected_MCRS === (expected_MCRS ^ MCRS ^ expected_MCRS) &&
                expected_MCrs_dv === (expected_MCrs_dv ^ MCrs_dv ^ expected_MCrs_dv) &&
                expected_MRxD === (expected_MRxD ^ MRxD ^ expected_MRxD) &&
                expected_MRxErr === (expected_MRxErr ^ MRxErr ^ expected_MRxErr) &&
                expected_Tx_en === (expected_Tx_en ^ Tx_en ^ expected_Tx_en) &&
                expected_Tx_er === (expected_Tx_er ^ Tx_er ^ expected_Tx_er) &&
                expected_Txd === (expected_Txd ^ Txd ^ expected_Txd)) begin
                $display("PASS");
                $display("  Outputs: MCRS=%b, MCrs_dv=%b, MRxD=%h, MRxErr=%b, Tx_en=%b, Tx_er=%b, Txd=%h",
                         MCRS, MCrs_dv, MRxD, MRxErr, Tx_en, Tx_er, Txd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MCRS=%b, MCrs_dv=%b, MRxD=%h, MRxErr=%b, Tx_en=%b, Tx_er=%b, Txd=%h",
                         expected_MCRS, expected_MCrs_dv, expected_MRxD, expected_MRxErr, expected_Tx_en, expected_Tx_er, expected_Txd);
                $display("  Got:      MCRS=%b, MCrs_dv=%b, MRxD=%h, MRxErr=%b, Tx_en=%b, Tx_er=%b, Txd=%h",
                         MCRS, MCrs_dv, MRxD, MRxErr, Tx_en, Tx_er, Txd);
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
        $dumpvars(0,Col, Crs, Line_loop_en, MAC_rx_clk, MAC_tx_clk, MTxD, MTxEn, Reset, Rx_dv, Rx_er, Rxd, Speed, MCRS, MCrs_dv, MRxD, MRxErr, Tx_en, Tx_er, Txd);
    end

endmodule
