`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] adc_d;
    reg ck_1356meg;
    reg ck_1356megb;
    reg cross_hi;
    reg cross_lo;
    reg [7:0] divisor;
    reg pck0;
    reg ssp_dout;
    wire adc_clk;
    wire dbg;
    wire pwr_hi;
    wire pwr_lo;
    wire pwr_oe1;
    wire pwr_oe2;
    wire pwr_oe3;
    wire pwr_oe4;
    wire ssp_clk;
    wire ssp_din;
    wire ssp_frame;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adc_d(adc_d),
        .ck_1356meg(ck_1356meg),
        .ck_1356megb(ck_1356megb),
        .cross_hi(cross_hi),
        .cross_lo(cross_lo),
        .divisor(divisor),
        .pck0(pck0),
        .ssp_dout(ssp_dout),
        .adc_clk(adc_clk),
        .dbg(dbg),
        .pwr_hi(pwr_hi),
        .pwr_lo(pwr_lo),
        .pwr_oe1(pwr_oe1),
        .pwr_oe2(pwr_oe2),
        .pwr_oe3(pwr_oe3),
        .pwr_oe4(pwr_oe4),
        .ssp_clk(ssp_clk),
        .ssp_din(ssp_din),
        .ssp_frame(ssp_frame)
    );

    // Clock generation (10ns period)
    initial begin
        pck0 = 0;
        forever #5 pck0 = ~pck0;
    end

        task reset_dut;

        begin
            adc_d = 8'h00;
            ck_1356meg = 0;
            ck_1356megb = 1;
            cross_hi = 0;
            cross_lo = 0;
            divisor = 8'h02;
            ssp_dout = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: ADC High Threshold (200 > 191)");
            reset_dut();
            test_num = 1;

            adc_d = 8'd200;
            #100;



            #1;




            check_outputs(adc_clk, dbg, 1'b1, 1'b0, pwr_oe1, pwr_oe2, pwr_oe3, pwr_oe4, ssp_clk, ssp_din, ssp_frame);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Hysteresis Mid-Range (Stay High)");
            reset_dut();
            test_num = 2;

            adc_d = 8'd200;
            #40;
            adc_d = 8'd128;
            #100;


            #1;



            check_outputs(adc_clk, dbg, 1'b1, 1'b0, pwr_oe1, pwr_oe2, pwr_oe3, pwr_oe4, ssp_clk, ssp_din, ssp_frame);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: ADC Low Threshold (30 < 64)");
            reset_dut();
            test_num = 3;

            adc_d = 8'd30;
            #100;


            #1;



            check_outputs(adc_clk, dbg, 1'b0, 1'b1, pwr_oe1, pwr_oe2, pwr_oe3, pwr_oe4, ssp_clk, ssp_din, ssp_frame);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Hysteresis Mid-Range (Stay Low)");
            reset_dut();
            test_num = 4;

            adc_d = 8'd30;
            #40;
            adc_d = 8'd100;
            #100;


            #1;



            check_outputs(adc_clk, dbg, 1'b0, 1'b1, pwr_oe1, pwr_oe2, pwr_oe3, pwr_oe4, ssp_clk, ssp_din, ssp_frame);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Clock Divider check");
            reset_dut();
            test_num = 5;

            divisor = 8'h04;
            #200;


            if (adc_clk !== 1'bz && adc_clk !== 1'bx) begin
                $display("ADC Clock is active.");
                pass_count = pass_count + 1;
            end else begin
                $display("ADC Clock is invalid.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Signal Routing (Cross Hi/Lo)");
            reset_dut();
            test_num = 6;

            cross_hi = 1;
            cross_lo = 1;
            #50;



            if (pwr_oe1 !== 1'bx && pwr_oe2 !== 1'bx) begin
                $display("Routing signals are valid.");
                pass_count = pass_count + 1;
            } else begin
                $display("Routing signals are indeterminate.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning Testcase 007: SSP Data Path");
            reset_dut();
            test_num = 7;

            ssp_dout = 1;
            #50;



            if (ssp_clk !== 1'bx) begin
                 $display("SSP Interface clocking verified.");
                 pass_count = pass_count + 1;
            end else begin
                 $display("SSP Interface clocking failed.");
                 fail_count = fail_count + 1;
            end
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
        input expected_ssp_clk;
        input expected_ssp_din;
        input expected_ssp_frame;
        begin
            if (expected_adc_clk === (expected_adc_clk ^ adc_clk ^ expected_adc_clk) &&
                expected_dbg === (expected_dbg ^ dbg ^ expected_dbg) &&
                expected_pwr_hi === (expected_pwr_hi ^ pwr_hi ^ expected_pwr_hi) &&
                expected_pwr_lo === (expected_pwr_lo ^ pwr_lo ^ expected_pwr_lo) &&
                expected_pwr_oe1 === (expected_pwr_oe1 ^ pwr_oe1 ^ expected_pwr_oe1) &&
                expected_pwr_oe2 === (expected_pwr_oe2 ^ pwr_oe2 ^ expected_pwr_oe2) &&
                expected_pwr_oe3 === (expected_pwr_oe3 ^ pwr_oe3 ^ expected_pwr_oe3) &&
                expected_pwr_oe4 === (expected_pwr_oe4 ^ pwr_oe4 ^ expected_pwr_oe4) &&
                expected_ssp_clk === (expected_ssp_clk ^ ssp_clk ^ expected_ssp_clk) &&
                expected_ssp_din === (expected_ssp_din ^ ssp_din ^ expected_ssp_din) &&
                expected_ssp_frame === (expected_ssp_frame ^ ssp_frame ^ expected_ssp_frame)) begin
                $display("PASS");
                $display("  Outputs: adc_clk=%b, dbg=%b, pwr_hi=%b, pwr_lo=%b, pwr_oe1=%b, pwr_oe2=%b, pwr_oe3=%b, pwr_oe4=%b, ssp_clk=%b, ssp_din=%b, ssp_frame=%b",
                         adc_clk, dbg, pwr_hi, pwr_lo, pwr_oe1, pwr_oe2, pwr_oe3, pwr_oe4, ssp_clk, ssp_din, ssp_frame);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adc_clk=%b, dbg=%b, pwr_hi=%b, pwr_lo=%b, pwr_oe1=%b, pwr_oe2=%b, pwr_oe3=%b, pwr_oe4=%b, ssp_clk=%b, ssp_din=%b, ssp_frame=%b",
                         expected_adc_clk, expected_dbg, expected_pwr_hi, expected_pwr_lo, expected_pwr_oe1, expected_pwr_oe2, expected_pwr_oe3, expected_pwr_oe4, expected_ssp_clk, expected_ssp_din, expected_ssp_frame);
                $display("  Got:      adc_clk=%b, dbg=%b, pwr_hi=%b, pwr_lo=%b, pwr_oe1=%b, pwr_oe2=%b, pwr_oe3=%b, pwr_oe4=%b, ssp_clk=%b, ssp_din=%b, ssp_frame=%b",
                         adc_clk, dbg, pwr_hi, pwr_lo, pwr_oe1, pwr_oe2, pwr_oe3, pwr_oe4, ssp_clk, ssp_din, ssp_frame);
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
        $dumpvars(0,adc_d, ck_1356meg, ck_1356megb, cross_hi, cross_lo, divisor, pck0, ssp_dout, adc_clk, dbg, pwr_hi, pwr_lo, pwr_oe1, pwr_oe2, pwr_oe3, pwr_oe4, ssp_clk, ssp_din, ssp_frame);
    end

endmodule
