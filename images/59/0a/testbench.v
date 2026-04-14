`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg fmc_clkd_resetn;
    reg fmc_clkd_spi_csb;
    reg fmc_clkd_spi_sclk;
    reg fmc_clkd_syncn;
    reg [13:0] fmc_dac_db;
    reg fmc_dac_sleep;
    wire clkd_resetn;
    wire clkd_spi_csb;
    wire clkd_spi_sclk;
    wire clkd_syncn;
    wire [13:0] dac_db;
    wire dac_sleep;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .fmc_clkd_resetn(fmc_clkd_resetn),
        .fmc_clkd_spi_csb(fmc_clkd_spi_csb),
        .fmc_clkd_spi_sclk(fmc_clkd_spi_sclk),
        .fmc_clkd_syncn(fmc_clkd_syncn),
        .fmc_dac_db(fmc_dac_db),
        .fmc_dac_sleep(fmc_dac_sleep),
        .clkd_resetn(clkd_resetn),
        .clkd_spi_csb(clkd_spi_csb),
        .clkd_spi_sclk(clkd_spi_sclk),
        .clkd_syncn(clkd_syncn),
        .dac_db(dac_db),
        .dac_sleep(dac_sleep)
    );

    // Clock generation (10ns period)
    initial begin
        fmc_clkd_spi_csb = 0;
        forever #5 fmc_clkd_spi_csb = ~fmc_clkd_spi_csb;
    end

        task reset_dut;

        begin
            fmc_clkd_resetn   = 1'b0;
            fmc_clkd_spi_sclk = 1'b0;
            fmc_clkd_syncn    = 1'b0;
            fmc_dac_db        = 14'h0;
            fmc_dac_sleep     = 1'b0;
            #20;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Propagation of High Logic Levels");
            test_num = test_num + 1;
            reset_dut();

            fmc_clkd_resetn   = 1'b1;
            fmc_clkd_spi_sclk = 1'b1;
            fmc_clkd_syncn    = 1'b1;
            fmc_dac_db        = 14'h3FFF;
            fmc_dac_sleep     = 1'b1;

            #10;

            #1;


            check_outputs(1'b1, fmc_clkd_spi_csb, 1'b1, 1'b1, 14'h3FFF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Propagation of Low Logic Levels");
            test_num = test_num + 1;
            reset_dut();

            fmc_clkd_resetn   = 1'b0;
            fmc_clkd_spi_sclk = 1'b0;
            fmc_clkd_syncn    = 1'b0;
            fmc_dac_db        = 14'h0000;
            fmc_dac_sleep     = 1'b0;

            #10;
            #1;

            check_outputs(1'b0, fmc_clkd_spi_csb, 1'b0, 1'b0, 14'h0000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: DAC Data Bus Pattern 0x2AAA");
            test_num = test_num + 1;
            reset_dut();

            fmc_clkd_resetn   = 1'b1;
            fmc_clkd_spi_sclk = 1'b0;
            fmc_clkd_syncn    = 1'b1;
            fmc_dac_db        = 14'h2AAA;
            fmc_dac_sleep     = 1'b0;

            #10;
            #1;

            check_outputs(1'b1, fmc_clkd_spi_csb, 1'b0, 1'b1, 14'h2AAA, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: DAC Data Bus Pattern 0x1555");
            test_num = test_num + 1;
            reset_dut();

            fmc_clkd_resetn   = 1'b1;
            fmc_clkd_spi_sclk = 1'b1;
            fmc_clkd_syncn    = 1'b1;
            fmc_dac_db        = 14'h1555;
            fmc_dac_sleep     = 1'b0;

            #10;
            #1;

            check_outputs(1'b1, fmc_clkd_spi_csb, 1'b1, 1'b1, 14'h1555, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Control Signal Independent Toggling");
            test_num = test_num + 1;
            reset_dut();


            fmc_dac_sleep = 1'b1;
            #5;
            #1;

            check_outputs(1'b0, fmc_clkd_spi_csb, 1'b0, 1'b0, 14'h0, 1'b1);


            fmc_clkd_resetn = 1'b1;
            #5;
            #1;

            check_outputs(1'b1, fmc_clkd_spi_csb, 1'b0, 1'b0, 14'h0, 1'b1);
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
        input expected_clkd_resetn;
        input expected_clkd_spi_csb;
        input expected_clkd_spi_sclk;
        input expected_clkd_syncn;
        input [13:0] expected_dac_db;
        input expected_dac_sleep;
        begin
            if (expected_clkd_resetn === (expected_clkd_resetn ^ clkd_resetn ^ expected_clkd_resetn) &&
                expected_clkd_spi_csb === (expected_clkd_spi_csb ^ clkd_spi_csb ^ expected_clkd_spi_csb) &&
                expected_clkd_spi_sclk === (expected_clkd_spi_sclk ^ clkd_spi_sclk ^ expected_clkd_spi_sclk) &&
                expected_clkd_syncn === (expected_clkd_syncn ^ clkd_syncn ^ expected_clkd_syncn) &&
                expected_dac_db === (expected_dac_db ^ dac_db ^ expected_dac_db) &&
                expected_dac_sleep === (expected_dac_sleep ^ dac_sleep ^ expected_dac_sleep)) begin
                $display("PASS");
                $display("  Outputs: clkd_resetn=%b, clkd_spi_csb=%b, clkd_spi_sclk=%b, clkd_syncn=%b, dac_db=%h, dac_sleep=%b",
                         clkd_resetn, clkd_spi_csb, clkd_spi_sclk, clkd_syncn, dac_db, dac_sleep);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clkd_resetn=%b, clkd_spi_csb=%b, clkd_spi_sclk=%b, clkd_syncn=%b, dac_db=%h, dac_sleep=%b",
                         expected_clkd_resetn, expected_clkd_spi_csb, expected_clkd_spi_sclk, expected_clkd_syncn, expected_dac_db, expected_dac_sleep);
                $display("  Got:      clkd_resetn=%b, clkd_spi_csb=%b, clkd_spi_sclk=%b, clkd_syncn=%b, dac_db=%h, dac_sleep=%b",
                         clkd_resetn, clkd_spi_csb, clkd_spi_sclk, clkd_syncn, dac_db, dac_sleep);
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
        $dumpvars(0,fmc_clkd_resetn, fmc_clkd_spi_csb, fmc_clkd_spi_sclk, fmc_clkd_syncn, fmc_dac_db, fmc_dac_sleep, clkd_resetn, clkd_spi_csb, clkd_spi_sclk, clkd_syncn, dac_db, dac_sleep);
    end

endmodule
