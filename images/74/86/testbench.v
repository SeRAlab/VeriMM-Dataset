`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] b;
    reg clk;
    reg [7:0] g;
    reg [7:0] r;
    reg valid;
    wire [11:0] chip_data;
    wire chip_data_enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b(b),
        .clk(clk),
        .g(g),
        .r(r),
        .valid(valid),
        .chip_data(chip_data),
        .chip_data_enable(chip_data_enable)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        r = 0;
        g = 0;
        b = 0;
        valid = 0;


        repeat(2) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Running Testcase 001: Single Pixel (Lower 12 Bits)");
        r = 8'hAA; g = 8'hBB; b = 8'hCC; valid = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(12'hBCC, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Running Testcase 002: Second Pixel (Upper 12 Bits)");

        r = 8'hAA; g = 8'hBB; b = 8'hCC; valid = 1;
        @(posedge clk);

        r = 8'h11; g = 8'h22; b = 8'h33; valid = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(12'h112, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Running Testcase 003: Valid signal de-asserted");
        r = 8'hFF; g = 8'hFF; b = 8'hFF; valid = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(chip_data, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Running Testcase 004: Max values (FFF)");
        r = 8'hFF; g = 8'hFF; b = 8'hFF; valid = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(12'hFFF, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Running Testcase 005: Min values after rotation");

        r = 8'hFF; g = 8'hFF; b = 8'hFF; valid = 1;
        @(posedge clk);

        r = 8'h00; g = 8'h00; b = 8'h00; valid = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(12'h000, 1'b1);
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
        input [11:0] expected_chip_data;
        input expected_chip_data_enable;
        begin
            if (expected_chip_data === (expected_chip_data ^ chip_data ^ expected_chip_data) &&
                expected_chip_data_enable === (expected_chip_data_enable ^ chip_data_enable ^ expected_chip_data_enable)) begin
                $display("PASS");
                $display("  Outputs: chip_data=%h, chip_data_enable=%b",
                         chip_data, chip_data_enable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: chip_data=%h, chip_data_enable=%b",
                         expected_chip_data, expected_chip_data_enable);
                $display("  Got:      chip_data=%h, chip_data_enable=%b",
                         chip_data, chip_data_enable);
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
        $dumpvars(0,b, clk, g, r, valid, chip_data, chip_data_enable);
    end

endmodule
