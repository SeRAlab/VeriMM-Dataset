`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg AR;
    reg E;
    reg ext_spi_clk;
    reg [3:0] rd_pntr_bin_reg;
    wire [3:0] Q;
    wire ram_full_fb_i_reg;
    wire [3:0] wr_pntr_gc_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AR(AR),
        .E(E),
        .ext_spi_clk(ext_spi_clk),
        .rd_pntr_bin_reg(rd_pntr_bin_reg),
        .Q(Q),
        .ram_full_fb_i_reg(ram_full_fb_i_reg),
        .wr_pntr_gc_reg(wr_pntr_gc_reg)
    );

    // Clock generation (10ns period)
    initial begin
        ext_spi_clk = 0;
        forever #5 ext_spi_clk = ~ext_spi_clk;
    end

        task reset_dut;

        begin
            AR = 1;
            E = 0;
            rd_pntr_bin_reg = 0;
            #15;
            AR = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset verification...");
            reset_dut();

            #1;


            check_outputs(4'h0, 1'b1, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Q increment only (E=0)...");
            reset_dut();
            E = 0;
            rd_pntr_bin_reg = 4'hF;

            repeat(5) @(posedge ext_spi_clk);
            #2;

            #1;


            check_outputs(4'h5, 1'b0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Q and wr_pntr increment (E=1)...");
            reset_dut();
            E = 1;
            rd_pntr_bin_reg = 4'hF;

            repeat(4) @(posedge ext_spi_clk);
            #2;

            #1;


            check_outputs(4'h4, 1'b0, 4'h8);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Full flag detection logic...");
            reset_dut();
            E = 1;

            repeat(3) @(posedge ext_spi_clk);
            #2;
            rd_pntr_bin_reg = 4'h6;
            #2;

            #1;


            check_outputs(4'h3, 1'b1, 4'h6);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Write pointer wrapping (14 -> 0)...");
            reset_dut();
            E = 1;
            rd_pntr_bin_reg = 4'hF;

            repeat(8) @(posedge ext_spi_clk);
            #2;

            #1;


            check_outputs(4'h8, 1'b0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Extended operation and wrap check...");
            reset_dut();
            E = 1;
            rd_pntr_bin_reg = 4'h2;



            repeat(10) @(posedge ext_spi_clk);
            #2;

            #1;


            check_outputs(4'hA, 1'b0, 4'h4);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Toggle Enable mid-stream...");
            reset_dut();
            rd_pntr_bin_reg = 4'hF;

            E = 1;
            repeat(2) @(posedge ext_spi_clk);

            E = 0;
            repeat(2) @(posedge ext_spi_clk);

            E = 1;
            repeat(1) @(posedge ext_spi_clk);
            #2;
            #1;

            check_outputs(4'h5, 1'b0, 4'h6);
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
        input [3:0] expected_Q;
        input expected_ram_full_fb_i_reg;
        input [3:0] expected_wr_pntr_gc_reg;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_ram_full_fb_i_reg === (expected_ram_full_fb_i_reg ^ ram_full_fb_i_reg ^ expected_ram_full_fb_i_reg) &&
                expected_wr_pntr_gc_reg === (expected_wr_pntr_gc_reg ^ wr_pntr_gc_reg ^ expected_wr_pntr_gc_reg)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, ram_full_fb_i_reg=%b, wr_pntr_gc_reg=%h",
                         Q, ram_full_fb_i_reg, wr_pntr_gc_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, ram_full_fb_i_reg=%b, wr_pntr_gc_reg=%h",
                         expected_Q, expected_ram_full_fb_i_reg, expected_wr_pntr_gc_reg);
                $display("  Got:      Q=%h, ram_full_fb_i_reg=%b, wr_pntr_gc_reg=%h",
                         Q, ram_full_fb_i_reg, wr_pntr_gc_reg);
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
        $dumpvars(0,AR, E, ext_spi_clk, rd_pntr_bin_reg, Q, ram_full_fb_i_reg, wr_pntr_gc_reg);
    end

endmodule
