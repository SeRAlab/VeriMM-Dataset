`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cal_blk_clk;
    reg fixedclk;
    reg [5:0] fixedclk_fast;
    reg gxb_powerdown;
    reg pll_inclk;
    reg reconfig_clk;
    reg [3:0] reconfig_togxb;
    reg rx_analogreset;
    reg rx_cruclk;
    reg rx_datain;
    reg rx_digitalreset;
    reg rx_seriallpbken;
    reg tx_ctrlenable;
    reg [7:0] tx_datain;
    reg tx_digitalreset;
    wire [16:0] reconfig_fromgxb;
    wire rx_clkout;
    wire rx_ctrldetect;
    wire [7:0] rx_dataout;
    wire rx_disperr;
    wire rx_errdetect;
    wire rx_patterndetect;
    wire rx_rlv;
    wire rx_rmfifodatadeleted;
    wire rx_rmfifodatainserted;
    wire rx_runningdisp;
    wire rx_syncstatus;
    wire tx_clkout;
    wire tx_dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cal_blk_clk(cal_blk_clk),
        .fixedclk(fixedclk),
        .fixedclk_fast(fixedclk_fast),
        .gxb_powerdown(gxb_powerdown),
        .pll_inclk(pll_inclk),
        .reconfig_clk(reconfig_clk),
        .reconfig_togxb(reconfig_togxb),
        .rx_analogreset(rx_analogreset),
        .rx_cruclk(rx_cruclk),
        .rx_datain(rx_datain),
        .rx_digitalreset(rx_digitalreset),
        .rx_seriallpbken(rx_seriallpbken),
        .tx_ctrlenable(tx_ctrlenable),
        .tx_datain(tx_datain),
        .tx_digitalreset(tx_digitalreset),
        .reconfig_fromgxb(reconfig_fromgxb),
        .rx_clkout(rx_clkout),
        .rx_ctrldetect(rx_ctrldetect),
        .rx_dataout(rx_dataout),
        .rx_disperr(rx_disperr),
        .rx_errdetect(rx_errdetect),
        .rx_patterndetect(rx_patterndetect),
        .rx_rlv(rx_rlv),
        .rx_rmfifodatadeleted(rx_rmfifodatadeleted),
        .rx_rmfifodatainserted(rx_rmfifodatainserted),
        .rx_runningdisp(rx_runningdisp),
        .rx_syncstatus(rx_syncstatus),
        .tx_clkout(tx_clkout),
        .tx_dataout(tx_dataout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: System Reset and Powerdown", test_num);


            gxb_powerdown = 1'b1;
            rx_analogreset = 1'b1;
            rx_digitalreset = 1'b1;
            tx_digitalreset = 1'b1;
            tx_datain = 8'h00;
            tx_ctrlenable = 1'b0;
            rx_seriallpbken = 1'b0;
            fixedclk_fast = 6'b0;
            reconfig_togxb = 4'b0;
            rx_datain = 1'b0;

            #100;



            #1;




            check_outputs(
                17'hx,
                1'bx,
                1'b0,
                8'h00,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'b0,
                1'bx,
                1'b0
            );
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Power Up and Initialization", test_num);


            gxb_powerdown = 1'b1;
            rx_analogreset = 1'b1;
            rx_digitalreset = 1'b1;
            tx_digitalreset = 1'b1;
            #40;

            gxb_powerdown = 1'b0;
            #100;
            rx_analogreset = 1'b0;
            #100;
            tx_digitalreset = 1'b0;
            rx_digitalreset = 1'b0;

            #500;

            #1;


            check_outputs(
                17'hx,
                1'bx,
                1'bx,
                8'hx,
                1'bx,
                1'bx,
                1'bx,
                1'bx,
                1'bx,
                1'bx,
                1'bx,
                1'bx,
                1'bx,
                1'bx
            );
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Basic Data Transmission", test_num);


            gxb_powerdown = 1'b0;
            rx_analogreset = 1'b0;
            rx_digitalreset = 1'b0;
            tx_digitalreset = 1'b0;


            tx_datain = 8'h55;
            tx_ctrlenable = 1'b0;

            #200;


            #1;



            check_outputs(
                17'hx, 1'bx, 1'bx, 8'hx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx
            );
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Control Character Transmission", test_num);


            tx_digitalreset = 1'b1;
            #20;
            tx_digitalreset = 1'b0;


            tx_datain = 8'hBC;
            tx_ctrlenable = 1'b1;

            #200;

            #1;


            check_outputs(
                17'hx, 1'bx, 1'bx, 8'hx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx
            );
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Serial Loopback Enable", test_num);


            gxb_powerdown = 1'b0;
            rx_analogreset = 1'b0;
            rx_digitalreset = 1'b0;
            tx_digitalreset = 1'b0;


            rx_seriallpbken = 1'b1;
            tx_datain = 8'hAA;
            tx_ctrlenable = 1'b0;

            #1000;


            #1;



            check_outputs(
                17'hx, 1'bx, 1'bx, 8'hx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx
            );
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
        input [16:0] expected_reconfig_fromgxb;
        input expected_rx_clkout;
        input expected_rx_ctrldetect;
        input [7:0] expected_rx_dataout;
        input expected_rx_disperr;
        input expected_rx_errdetect;
        input expected_rx_patterndetect;
        input expected_rx_rlv;
        input expected_rx_rmfifodatadeleted;
        input expected_rx_rmfifodatainserted;
        input expected_rx_runningdisp;
        input expected_rx_syncstatus;
        input expected_tx_clkout;
        input expected_tx_dataout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_reconfig_fromgxb === (expected_reconfig_fromgxb ^ reconfig_fromgxb ^ expected_reconfig_fromgxb) &&
                expected_rx_clkout === (expected_rx_clkout ^ rx_clkout ^ expected_rx_clkout) &&
                expected_rx_ctrldetect === (expected_rx_ctrldetect ^ rx_ctrldetect ^ expected_rx_ctrldetect) &&
                expected_rx_dataout === (expected_rx_dataout ^ rx_dataout ^ expected_rx_dataout) &&
                expected_rx_disperr === (expected_rx_disperr ^ rx_disperr ^ expected_rx_disperr) &&
                expected_rx_errdetect === (expected_rx_errdetect ^ rx_errdetect ^ expected_rx_errdetect) &&
                expected_rx_patterndetect === (expected_rx_patterndetect ^ rx_patterndetect ^ expected_rx_patterndetect) &&
                expected_rx_rlv === (expected_rx_rlv ^ rx_rlv ^ expected_rx_rlv) &&
                expected_rx_rmfifodatadeleted === (expected_rx_rmfifodatadeleted ^ rx_rmfifodatadeleted ^ expected_rx_rmfifodatadeleted) &&
                expected_rx_rmfifodatainserted === (expected_rx_rmfifodatainserted ^ rx_rmfifodatainserted ^ expected_rx_rmfifodatainserted) &&
                expected_rx_runningdisp === (expected_rx_runningdisp ^ rx_runningdisp ^ expected_rx_runningdisp) &&
                expected_rx_syncstatus === (expected_rx_syncstatus ^ rx_syncstatus ^ expected_rx_syncstatus) &&
                expected_tx_clkout === (expected_tx_clkout ^ tx_clkout ^ expected_tx_clkout) &&
                expected_tx_dataout === (expected_tx_dataout ^ tx_dataout ^ expected_tx_dataout)) begin
                $display("PASS");
                $display("  Outputs: reconfig_fromgxb=%h, rx_clkout=%b, rx_ctrldetect=%b, rx_dataout=%h, rx_disperr=%b, rx_errdetect=%b, rx_patterndetect=%b, rx_rlv=%b, rx_rmfifodatadeleted=%b, rx_rmfifodatainserted=%b, rx_runningdisp=%b, rx_syncstatus=%b, tx_clkout=%b, tx_dataout=%b",
                         reconfig_fromgxb, rx_clkout, rx_ctrldetect, rx_dataout, rx_disperr, rx_errdetect, rx_patterndetect, rx_rlv, rx_rmfifodatadeleted, rx_rmfifodatainserted, rx_runningdisp, rx_syncstatus, tx_clkout, tx_dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reconfig_fromgxb=%h, rx_clkout=%b, rx_ctrldetect=%b, rx_dataout=%h, rx_disperr=%b, rx_errdetect=%b, rx_patterndetect=%b, rx_rlv=%b, rx_rmfifodatadeleted=%b, rx_rmfifodatainserted=%b, rx_runningdisp=%b, rx_syncstatus=%b, tx_clkout=%b, tx_dataout=%b",
                         expected_reconfig_fromgxb, expected_rx_clkout, expected_rx_ctrldetect, expected_rx_dataout, expected_rx_disperr, expected_rx_errdetect, expected_rx_patterndetect, expected_rx_rlv, expected_rx_rmfifodatadeleted, expected_rx_rmfifodatainserted, expected_rx_runningdisp, expected_rx_syncstatus, expected_tx_clkout, expected_tx_dataout);
                $display("  Got:      reconfig_fromgxb=%h, rx_clkout=%b, rx_ctrldetect=%b, rx_dataout=%h, rx_disperr=%b, rx_errdetect=%b, rx_patterndetect=%b, rx_rlv=%b, rx_rmfifodatadeleted=%b, rx_rmfifodatainserted=%b, rx_runningdisp=%b, rx_syncstatus=%b, tx_clkout=%b, tx_dataout=%b",
                         reconfig_fromgxb, rx_clkout, rx_ctrldetect, rx_dataout, rx_disperr, rx_errdetect, rx_patterndetect, rx_rlv, rx_rmfifodatadeleted, rx_rmfifodatainserted, rx_runningdisp, rx_syncstatus, tx_clkout, tx_dataout);
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
