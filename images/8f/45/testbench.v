`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cross_lo;
    reg pck_divclk;
    reg ssp_dout;
    wire adc_clk;
    wire dbg;
    wire pwr_hi;
    wire pwr_lo;
    wire pwr_oe1;
    wire pwr_oe2;
    wire pwr_oe3;
    wire pwr_oe4;
    wire ssp_din;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cross_lo(cross_lo),
        .pck_divclk(pck_divclk),
        .ssp_dout(ssp_dout),
        .adc_clk(adc_clk),
        .dbg(dbg),
        .pwr_hi(pwr_hi),
        .pwr_lo(pwr_lo),
        .pwr_oe1(pwr_oe1),
        .pwr_oe2(pwr_oe2),
        .pwr_oe3(pwr_oe3),
        .pwr_oe4(pwr_oe4),
        .ssp_din(ssp_din)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: All inputs Low", test_num);
        pck_divclk = 0;
        ssp_dout = 0;
        cross_lo = 0;

        #1;


        check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Cross-connect routing", test_num);
        pck_divclk = 0;
        ssp_dout = 0;
        cross_lo = 1;

        #1;


        check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: SSP Data activation (divclk Low)", test_num);
        pck_divclk = 0;
        ssp_dout = 1;
        cross_lo = 0;

        #1;


        check_outputs(0, 1, 0, 0, 1, 1, 1, 1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Power-Low activation (divclk and ssp_dout High)", test_num);
        pck_divclk = 1;
        ssp_dout = 1;
        cross_lo = 0;

        #1;


        check_outputs(0, 1, 0, 1, 1, 1, 1, 1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Clock active, Data inactive", test_num);
        pck_divclk = 1;
        ssp_dout = 0;
        cross_lo = 0;

        #1;


        check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: All signals High", test_num);
        pck_divclk = 1;
        ssp_dout = 1;
        cross_lo = 1;

        #1;


        check_outputs(0, 1, 0, 1, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Toggle Cross-connect with Power enabled", test_num);
        pck_divclk = 1;
        ssp_dout = 1;
        cross_lo = 0;
        #5;
        cross_lo = 1;

        #1;


        check_outputs(0, 1, 0, 1, 1, 1, 1, 1, 1);
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
        input expected_adc_clk;
        input expected_dbg;
        input expected_pwr_hi;
        input expected_pwr_lo;
        input expected_pwr_oe1;
        input expected_pwr_oe2;
        input expected_pwr_oe3;
        input expected_pwr_oe4;
        input expected_ssp_din;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_adc_clk === (expected_adc_clk ^ adc_clk ^ expected_adc_clk) &&
                expected_dbg === (expected_dbg ^ dbg ^ expected_dbg) &&
                expected_pwr_hi === (expected_pwr_hi ^ pwr_hi ^ expected_pwr_hi) &&
                expected_pwr_lo === (expected_pwr_lo ^ pwr_lo ^ expected_pwr_lo) &&
                expected_pwr_oe1 === (expected_pwr_oe1 ^ pwr_oe1 ^ expected_pwr_oe1) &&
                expected_pwr_oe2 === (expected_pwr_oe2 ^ pwr_oe2 ^ expected_pwr_oe2) &&
                expected_pwr_oe3 === (expected_pwr_oe3 ^ pwr_oe3 ^ expected_pwr_oe3) &&
                expected_pwr_oe4 === (expected_pwr_oe4 ^ pwr_oe4 ^ expected_pwr_oe4) &&
                expected_ssp_din === (expected_ssp_din ^ ssp_din ^ expected_ssp_din)) begin
                $display("PASS");
                $display("  Outputs: adc_clk=%b, dbg=%b, pwr_hi=%b, pwr_lo=%b, pwr_oe1=%b, pwr_oe2=%b, pwr_oe3=%b, pwr_oe4=%b, ssp_din=%b",
                         adc_clk, dbg, pwr_hi, pwr_lo, pwr_oe1, pwr_oe2, pwr_oe3, pwr_oe4, ssp_din);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adc_clk=%b, dbg=%b, pwr_hi=%b, pwr_lo=%b, pwr_oe1=%b, pwr_oe2=%b, pwr_oe3=%b, pwr_oe4=%b, ssp_din=%b",
                         expected_adc_clk, expected_dbg, expected_pwr_hi, expected_pwr_lo, expected_pwr_oe1, expected_pwr_oe2, expected_pwr_oe3, expected_pwr_oe4, expected_ssp_din);
                $display("  Got:      adc_clk=%b, dbg=%b, pwr_hi=%b, pwr_lo=%b, pwr_oe1=%b, pwr_oe2=%b, pwr_oe3=%b, pwr_oe4=%b, ssp_din=%b",
                         adc_clk, dbg, pwr_hi, pwr_lo, pwr_oe1, pwr_oe2, pwr_oe3, pwr_oe4, ssp_din);
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
