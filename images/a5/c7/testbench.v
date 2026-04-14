`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] char;
    reg clk;
    reg [3:0] row;
    wire [11:0] data_row;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .char(char),
        .clk(clk),
        .row(row),
        .data_row(data_row)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            char = 8'h00;
            row  = 4'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            char = 8'h00;
            row  = 4'h0;
            @(posedge clk);
            #2;
            $display("Testcase 001: Char 0x00, Row 0");
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            char = 8'h41;
            row  = 4'h5;
            @(posedge clk);
            #2;
            $display("Testcase 002: Char 0x41, Row 5");
            #1;

            check_outputs(12'h7E0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            char = 8'h5A;
            row  = 4'hF;
            @(posedge clk);
            #2;
            $display("Testcase 003: Char 0x5A, Row 15");
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            char = 8'hFF;
            row  = 4'h8;
            @(posedge clk);
            #2;
            $display("Testcase 004: Char 0xFF, Row 8");
            #1;

            check_outputs(12'hAA5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            char = 8'h30;
            row  = 4'hA;
            @(posedge clk);
            #2;
            $display("Testcase 005: Char 0x30, Row 10");
            #1;

            check_outputs(12'hC6C);
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
        input [11:0] expected_data_row;
        begin
            if (expected_data_row === (expected_data_row ^ data_row ^ expected_data_row)) begin
                $display("PASS");
                $display("  Outputs: data_row=%h",
                         data_row);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_row=%h",
                         expected_data_row);
                $display("  Got:      data_row=%h",
                         data_row);
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
        $dumpvars(0,char, clk, row, data_row);
    end

endmodule
