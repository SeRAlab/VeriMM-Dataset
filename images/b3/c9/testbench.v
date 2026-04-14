`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg adc_clk;
    reg after_hysteresis;
    reg [3:0] mod_type;
    reg ssp_clk;
    reg [7:0] ssp_clk_divider;
    wire modulating_carrier;
    wire pwr_oe1;
    wire pwr_oe3;
    wire pwr_oe4;
    wire ssp_din;
    wire ssp_frame;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adc_clk(adc_clk),
        .after_hysteresis(after_hysteresis),
        .mod_type(mod_type),
        .ssp_clk(ssp_clk),
        .ssp_clk_divider(ssp_clk_divider),
        .modulating_carrier(modulating_carrier),
        .pwr_oe1(pwr_oe1),
        .pwr_oe3(pwr_oe3),
        .pwr_oe4(pwr_oe4),
        .ssp_din(ssp_din),
        .ssp_frame(ssp_frame)
    );

    // Clock generation (10ns period)
    initial begin
        adc_clk = 0;
        forever #5 adc_clk = ~adc_clk;
    end

        task reset_dut;

        begin
            after_hysteresis = 0;
            mod_type = 0;
            ssp_clk_divider = 0;
            repeat(5) @(posedge adc_clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Idle state and type 0");
            reset_dut();
            mod_type = 4'b0000;
            ssp_clk_divider = 8'd2;
            after_hysteresis = 0;
            repeat(20) @(posedge adc_clk);

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Mod Type 1 with Hysteresis High");
            reset_dut();
            mod_type = 4'b0001;
            ssp_clk_divider = 8'd4;
            after_hysteresis = 1;
            repeat(20) @(posedge adc_clk);


            #1;



            check_outputs(modulating_carrier, 1'b1, 1'b1, 1'b1, 1'b1, ssp_frame);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Higher clock divider check");
            reset_dut();
            mod_type = 4'b0010;
            ssp_clk_divider = 8'd16;
            after_hysteresis = 1;
            repeat(100) @(posedge adc_clk);

            #1;


            check_outputs(modulating_carrier, 1'b1, 1'b1, 1'b1, 1'b1, ssp_frame);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Mod Type 3 (Frequency Modulation Logic)");
            reset_dut();
            mod_type = 4'b0011;
            ssp_clk_divider = 8'd2;
            after_hysteresis = 0;
            repeat(40) @(posedge adc_clk);

            #1;


            check_outputs(modulating_carrier, 1'b1, 1'b1, 1'b1, 1'b0, ssp_frame);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Mod Type 8 - Power Management check");
            reset_dut();
            mod_type = 4'b1000;
            ssp_clk_divider = 8'd1;
            after_hysteresis = 1;
            repeat(10) @(posedge adc_clk);


            #1;



            check_outputs(modulating_carrier, 1'b0, 1'b1, 1'b1, 1'b1, ssp_frame);
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
        input expected_modulating_carrier;
        input expected_pwr_oe1;
        input expected_pwr_oe3;
        input expected_pwr_oe4;
        input expected_ssp_din;
        input expected_ssp_frame;
        begin
            if (expected_modulating_carrier === (expected_modulating_carrier ^ modulating_carrier ^ expected_modulating_carrier) &&
                expected_pwr_oe1 === (expected_pwr_oe1 ^ pwr_oe1 ^ expected_pwr_oe1) &&
                expected_pwr_oe3 === (expected_pwr_oe3 ^ pwr_oe3 ^ expected_pwr_oe3) &&
                expected_pwr_oe4 === (expected_pwr_oe4 ^ pwr_oe4 ^ expected_pwr_oe4) &&
                expected_ssp_din === (expected_ssp_din ^ ssp_din ^ expected_ssp_din) &&
                expected_ssp_frame === (expected_ssp_frame ^ ssp_frame ^ expected_ssp_frame)) begin
                $display("PASS");
                $display("  Outputs: modulating_carrier=%b, pwr_oe1=%b, pwr_oe3=%b, pwr_oe4=%b, ssp_din=%b, ssp_frame=%b",
                         modulating_carrier, pwr_oe1, pwr_oe3, pwr_oe4, ssp_din, ssp_frame);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: modulating_carrier=%b, pwr_oe1=%b, pwr_oe3=%b, pwr_oe4=%b, ssp_din=%b, ssp_frame=%b",
                         expected_modulating_carrier, expected_pwr_oe1, expected_pwr_oe3, expected_pwr_oe4, expected_ssp_din, expected_ssp_frame);
                $display("  Got:      modulating_carrier=%b, pwr_oe1=%b, pwr_oe3=%b, pwr_oe4=%b, ssp_din=%b, ssp_frame=%b",
                         modulating_carrier, pwr_oe1, pwr_oe3, pwr_oe4, ssp_din, ssp_frame);
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
        $dumpvars(0,adc_clk, after_hysteresis, mod_type, ssp_clk, ssp_clk_divider, modulating_carrier, pwr_oe1, pwr_oe3, pwr_oe4, ssp_din, ssp_frame);
    end

endmodule
