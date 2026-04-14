`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg E;
    reg RS;
    reg RW;
    reg clk;
    reg [7:0] data;
    wire [7:0] LCD_DATA;
    wire LCD_E;
    wire LCD_RS;
    wire LCD_RW;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .E(E),
        .RS(RS),
        .RW(RW),
        .clk(clk),
        .data(data),
        .LCD_DATA(LCD_DATA),
        .LCD_E(LCD_E),
        .LCD_RS(LCD_RS),
        .LCD_RW(LCD_RW)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            RS = 0;
            RW = 0;
            E = 0;
            data = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Write Function Set Command (0x38)");
            reset_dut();
            data = 8'h38;
            RS = 0;
            RW = 0;
            E = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h38, 1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write Data Character 'A' (0x41)");
            reset_dut();
            data = 8'h41;
            RS = 1;
            RW = 0;
            E = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h41, 1, 1, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Simulation of Read Busy Flag / Address");
            reset_dut();
            data = 8'hZZ;
            RS = 0;
            RW = 1;
            E = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hZZ, 1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Clear Display Command (0x01)");
            reset_dut();
            data = 8'h01;
            RS = 0;
            RW = 0;
            E = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h01, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Verify logic with Enable low");
            reset_dut();
            data = 8'hAA;
            RS = 1;
            RW = 0;
            E = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hAA, 0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Write boundary value 0xFF");
            reset_dut();
            data = 8'hFF;
            RS = 1;
            RW = 1;
            E = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFF, 1, 1, 1);
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
        input [7:0] expected_LCD_DATA;
        input expected_LCD_E;
        input expected_LCD_RS;
        input expected_LCD_RW;
        begin
            if (expected_LCD_DATA === (expected_LCD_DATA ^ LCD_DATA ^ expected_LCD_DATA) &&
                expected_LCD_E === (expected_LCD_E ^ LCD_E ^ expected_LCD_E) &&
                expected_LCD_RS === (expected_LCD_RS ^ LCD_RS ^ expected_LCD_RS) &&
                expected_LCD_RW === (expected_LCD_RW ^ LCD_RW ^ expected_LCD_RW)) begin
                $display("PASS");
                $display("  Outputs: LCD_DATA=%h, LCD_E=%b, LCD_RS=%b, LCD_RW=%b",
                         LCD_DATA, LCD_E, LCD_RS, LCD_RW);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LCD_DATA=%h, LCD_E=%b, LCD_RS=%b, LCD_RW=%b",
                         expected_LCD_DATA, expected_LCD_E, expected_LCD_RS, expected_LCD_RW);
                $display("  Got:      LCD_DATA=%h, LCD_E=%b, LCD_RS=%b, LCD_RW=%b",
                         LCD_DATA, LCD_E, LCD_RS, LCD_RW);
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
        $dumpvars(0,E, RS, RW, clk, data, LCD_DATA, LCD_E, LCD_RS, LCD_RW);
    end

endmodule
