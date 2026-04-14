`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aud_adcdat_i;
    reg aud_bclk_i;
    reg aud_daclrck_i;
    reg clk_i;
    reg [15:0] datal_i;
    reg [15:0] datar_i;
    reg rst_i;
    wire aud_dacdat_o;
    wire [15:0] datal_o;
    wire [15:0] datar_o;
    wire ready_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aud_adcdat_i(aud_adcdat_i),
        .aud_bclk_i(aud_bclk_i),
        .aud_daclrck_i(aud_daclrck_i),
        .clk_i(clk_i),
        .datal_i(datal_i),
        .datar_i(datar_i),
        .rst_i(rst_i),
        .aud_dacdat_o(aud_dacdat_o),
        .datal_o(datal_o),
        .datar_o(datar_o),
        .ready_o(ready_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            aud_adcdat_i = 0;
            aud_bclk_i = 0;
            aud_daclrck_i = 1;
            datal_i = 0;
            datar_i = 0;
            repeat(5) @(posedge clk_i);
            rst_i = 0;
            repeat(2) @(posedge clk_i);
        end
        endtask
    task drive_adc_frame;

        input [15:0] left_val;
        input [15:0] right_val;
        integer i;
        begin

            aud_daclrck_i = 0;
            for (i = 15; i >= 0; i = i - 1) begin
                aud_adcdat_i = left_val[i];
                #20 aud_bclk_i = 1; #20 aud_bclk_i = 0;
            end

            aud_daclrck_i = 1;
            for (i = 15; i >= 0; i = i - 1) begin
                aud_adcdat_i = right_val[i];
                #20 aud_bclk_i = 1; #20 aud_bclk_i = 0;
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset Verification");
            reset_dut();

            #1;


            check_outputs(1'b0, 16'h0000, 16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Serial to Parallel (ADC) - Basic Patterns");
            reset_dut();


            drive_adc_frame(16'h1234, 16'h5678);


            repeat(10) @(posedge clk_i);



            #1;




            check_outputs(aud_dacdat_o, 16'h1234, 16'h5678, ready_o);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Signed Maximum and Minimum values");
            reset_dut();


            drive_adc_frame(16'h8000, 16'h7FFF);

            repeat(10) @(posedge clk_i);

            #1;


            check_outputs(aud_dacdat_o, 16'h8000, 16'h7FFF, ready_o);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Alternating bit patterns (0xAAAA, 0x5555)");
            reset_dut();

            drive_adc_frame(16'hAAAA, 16'h5555);

            repeat(10) @(posedge clk_i);

            #1;


            check_outputs(aud_dacdat_o, 16'hAAAA, 16'h5555, ready_o);
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
        input expected_aud_dacdat_o;
        input [15:0] expected_datal_o;
        input [15:0] expected_datar_o;
        input expected_ready_o;
        begin
            if (expected_aud_dacdat_o === (expected_aud_dacdat_o ^ aud_dacdat_o ^ expected_aud_dacdat_o) &&
                expected_datal_o === (expected_datal_o ^ datal_o ^ expected_datal_o) &&
                expected_datar_o === (expected_datar_o ^ datar_o ^ expected_datar_o) &&
                expected_ready_o === (expected_ready_o ^ ready_o ^ expected_ready_o)) begin
                $display("PASS");
                $display("  Outputs: aud_dacdat_o=%b, datal_o=%h, datar_o=%h, ready_o=%b",
                         aud_dacdat_o, datal_o, datar_o, ready_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aud_dacdat_o=%b, datal_o=%h, datar_o=%h, ready_o=%b",
                         expected_aud_dacdat_o, expected_datal_o, expected_datar_o, expected_ready_o);
                $display("  Got:      aud_dacdat_o=%b, datal_o=%h, datar_o=%h, ready_o=%b",
                         aud_dacdat_o, datal_o, datar_o, ready_o);
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
        $dumpvars(0,aud_adcdat_i, aud_bclk_i, aud_daclrck_i, clk_i, datal_i, datar_i, rst_i, aud_dacdat_o, datal_o, datar_o, ready_o);
    end

endmodule
