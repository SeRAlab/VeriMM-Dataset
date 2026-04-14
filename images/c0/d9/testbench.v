`timescale 1ns/1ps

module Phy_sim_tb;

    // Testbench signals (combinational circuit)
    reg Gtx_clk;
    reg [2:0] Speed;
    reg Tx_en;
    reg Tx_er;
    reg [7:0] Txd;
    wire Col;
    wire Crs;
    wire Rx_clk;
    wire Rx_dv;
    wire Rx_er;
    wire [7:0] Rxd;
    wire Tx_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Phy_sim dut (
        .Gtx_clk(Gtx_clk),
        .Speed(Speed),
        .Tx_en(Tx_en),
        .Tx_er(Tx_er),
        .Txd(Txd),
        .Col(Col),
        .Crs(Crs),
        .Rx_clk(Rx_clk),
        .Rx_dv(Rx_dv),
        .Rx_er(Rx_er),
        .Rxd(Rxd),
        .Tx_clk(Tx_clk)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Phy_sim Testbench");
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
        input expected_Col;
        input expected_Crs;
        input expected_Rx_clk;
        input expected_Rx_dv;
        input expected_Rx_er;
        input [7:0] expected_Rxd;
        input expected_Tx_clk;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Col === (expected_Col ^ Col ^ expected_Col) &&
                expected_Crs === (expected_Crs ^ Crs ^ expected_Crs) &&
                expected_Rx_clk === (expected_Rx_clk ^ Rx_clk ^ expected_Rx_clk) &&
                expected_Rx_dv === (expected_Rx_dv ^ Rx_dv ^ expected_Rx_dv) &&
                expected_Rx_er === (expected_Rx_er ^ Rx_er ^ expected_Rx_er) &&
                expected_Rxd === (expected_Rxd ^ Rxd ^ expected_Rxd) &&
                expected_Tx_clk === (expected_Tx_clk ^ Tx_clk ^ expected_Tx_clk)) begin
                $display("PASS");
                $display("  Outputs: Col=%b, Crs=%b, Rx_clk=%b, Rx_dv=%b, Rx_er=%b, Rxd=%h, Tx_clk=%b",
                         Col, Crs, Rx_clk, Rx_dv, Rx_er, Rxd, Tx_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Col=%b, Crs=%b, Rx_clk=%b, Rx_dv=%b, Rx_er=%b, Rxd=%h, Tx_clk=%b",
                         expected_Col, expected_Crs, expected_Rx_clk, expected_Rx_dv, expected_Rx_er, expected_Rxd, expected_Tx_clk);
                $display("  Got:      Col=%b, Crs=%b, Rx_clk=%b, Rx_dv=%b, Rx_er=%b, Rxd=%h, Tx_clk=%b",
                         Col, Crs, Rx_clk, Rx_dv, Rx_er, Rxd, Tx_clk);
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
