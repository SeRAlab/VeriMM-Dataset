`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg adc_clk;
    reg [13:0] adc_dat_a_i;
    reg [13:0] adc_dat_b_i;
    reg adc_rst_i;
    wire adc_cdcs_o;
    wire [1:0] adc_clk_source;
    wire [13:0] adc_dat_a_o;
    wire [13:0] adc_dat_b_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adc_clk(adc_clk),
        .adc_dat_a_i(adc_dat_a_i),
        .adc_dat_b_i(adc_dat_b_i),
        .adc_rst_i(adc_rst_i),
        .adc_cdcs_o(adc_cdcs_o),
        .adc_clk_source(adc_clk_source),
        .adc_dat_a_o(adc_dat_a_o),
        .adc_dat_b_o(adc_dat_b_o)
    );

    // Clock generation (10ns period)
    initial begin
        adc_clk = 0;
        forever #5 adc_clk = ~adc_clk;
    end

        task reset_dut;

        begin
            adc_rst_i = 1'b0;
            adc_dat_a_i = 14'h0;
            adc_dat_b_i = 14'h0;
            repeat(2) @(posedge adc_clk);
            #1;
            adc_rst_i = 1'b1;
            @(posedge adc_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Verifying Reset State");
            adc_rst_i = 1'b0;
            adc_dat_a_i = 14'h3FFF;
            adc_dat_b_i = 14'h3FFF;
            repeat(2) @(posedge adc_clk);
            #1;


            #1;



            check_outputs(1'b1, 2'b10, 14'h0000, 14'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Zero Scale Input");
            reset_dut();
            adc_dat_a_i = 14'h0000;
            adc_dat_b_i = 14'h0000;
            repeat(2) @(posedge adc_clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b10, 14'h1FFF, 14'h1FFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Mid Scale Input");
            reset_dut();
            adc_dat_a_i = 14'h2000;
            adc_dat_b_i = 14'h2000;
            repeat(2) @(posedge adc_clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b10, 14'h3FFF, 14'h3FFF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Full Scale Input");
            reset_dut();
            adc_dat_a_i = 14'h3FFF;
            adc_dat_b_i = 14'h3FFF;
            repeat(2) @(posedge adc_clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b10, 14'h2000, 14'h2000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Mixed Channel Patterns");
            reset_dut();
            adc_dat_a_i = 14'h1555;
            adc_dat_b_i = 14'h2AAA;
            repeat(2) @(posedge adc_clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b10, 14'h0AAA, 14'h3555);
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
        input expected_adc_cdcs_o;
        input [1:0] expected_adc_clk_source;
        input [13:0] expected_adc_dat_a_o;
        input [13:0] expected_adc_dat_b_o;
        begin
            if (expected_adc_cdcs_o === (expected_adc_cdcs_o ^ adc_cdcs_o ^ expected_adc_cdcs_o) &&
                expected_adc_clk_source === (expected_adc_clk_source ^ adc_clk_source ^ expected_adc_clk_source) &&
                expected_adc_dat_a_o === (expected_adc_dat_a_o ^ adc_dat_a_o ^ expected_adc_dat_a_o) &&
                expected_adc_dat_b_o === (expected_adc_dat_b_o ^ adc_dat_b_o ^ expected_adc_dat_b_o)) begin
                $display("PASS");
                $display("  Outputs: adc_cdcs_o=%b, adc_clk_source=%h, adc_dat_a_o=%h, adc_dat_b_o=%h",
                         adc_cdcs_o, adc_clk_source, adc_dat_a_o, adc_dat_b_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adc_cdcs_o=%b, adc_clk_source=%h, adc_dat_a_o=%h, adc_dat_b_o=%h",
                         expected_adc_cdcs_o, expected_adc_clk_source, expected_adc_dat_a_o, expected_adc_dat_b_o);
                $display("  Got:      adc_cdcs_o=%b, adc_clk_source=%h, adc_dat_a_o=%h, adc_dat_b_o=%h",
                         adc_cdcs_o, adc_clk_source, adc_dat_a_o, adc_dat_b_o);
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
        $dumpvars(0,adc_clk, adc_dat_a_i, adc_dat_b_i, adc_rst_i, adc_cdcs_o, adc_clk_source, adc_dat_a_o, adc_dat_b_o);
    end

endmodule
