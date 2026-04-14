`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg blank;
    reg clk;
    reg [23:0] data;
    reg hs;
    reg vs;
    wire blank_out;
    wire hs_out;
    wire [7:0] vga_data;
    wire vs_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .blank(blank),
        .clk(clk),
        .data(data),
        .hs(hs),
        .vs(vs),
        .blank_out(blank_out),
        .hs_out(hs_out),
        .vga_data(vga_data),
        .vs_out(vs_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            blank = 0;
            data = 24'h0;
            hs = 0;
            vs = 0;

            #1;
        end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Testcase 001: Checking MSB (Red) Segment...");
        data = 24'hAA_BB_CC; hs = 1; vs = 1; blank = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 1, 8'hAA, 1);
        @(posedge clk);
        @(posedge clk);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Testcase 002: Checking Middle (Green) Segment...");
        data = 24'h11_22_33; hs = 1; vs = 1; blank = 0;
        @(posedge clk);
        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 1, 8'h22, 1);
        @(posedge clk);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Testcase 003: Checking LSB (Blue) Segment...");
        data = 24'hDE_AD_BE; hs = 1; vs = 1; blank = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 1, 8'hBE, 1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Testcase 004: Verifying HS propagation...");
        data = 24'h000000; hs = 1; vs = 0; blank = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 1, 8'h00, 0);
        @(posedge clk); @(posedge clk);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Testcase 005: Verifying VS propagation...");
        data = 24'h000000; hs = 0; vs = 1; blank = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 0, 8'h00, 1);
        @(posedge clk); @(posedge clk);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        $display("Testcase 006: Verifying Blank propagation...");
        data = 24'hFFFFFF; hs = 0; vs = 0; blank = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1, 0, 8'hFF, 0);
        @(posedge clk); @(posedge clk);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        $display("Testcase 007: Checking Black Color (0x000000)...");
        data = 24'h000000; hs = 1; vs = 1; blank = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 1, 8'h00, 1);
        @(posedge clk); @(posedge clk);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        $display("Testcase 008: Checking White Color (0xFFFFFF)...");
        data = 24'hFFFFFF; hs = 1; vs = 1; blank = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 1, 8'hFF, 1);
        @(posedge clk); @(posedge clk);
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
        testcase008();
        
        
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
        input expected_blank_out;
        input expected_hs_out;
        input [7:0] expected_vga_data;
        input expected_vs_out;
        begin
            if (expected_blank_out === (expected_blank_out ^ blank_out ^ expected_blank_out) &&
                expected_hs_out === (expected_hs_out ^ hs_out ^ expected_hs_out) &&
                expected_vga_data === (expected_vga_data ^ vga_data ^ expected_vga_data) &&
                expected_vs_out === (expected_vs_out ^ vs_out ^ expected_vs_out)) begin
                $display("PASS");
                $display("  Outputs: blank_out=%b, hs_out=%b, vga_data=%h, vs_out=%b",
                         blank_out, hs_out, vga_data, vs_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: blank_out=%b, hs_out=%b, vga_data=%h, vs_out=%b",
                         expected_blank_out, expected_hs_out, expected_vga_data, expected_vs_out);
                $display("  Got:      blank_out=%b, hs_out=%b, vga_data=%h, vs_out=%b",
                         blank_out, hs_out, vga_data, vs_out);
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
        $dumpvars(0,blank, clk, data, hs, vs, blank_out, hs_out, vga_data, vs_out);
    end

endmodule
