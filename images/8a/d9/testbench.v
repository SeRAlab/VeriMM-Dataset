`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] temp;
    wire [6:0] display;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .temp(temp),
        .display(display)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            temp = 8'hAA;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking reset and zero temperature...");
            reset_dut();
            temp = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'b0111111);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Checking temperature 1...");
            reset_dut();
            temp = 8'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'b0000110);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Checking temperature 4...");
            reset_dut();
            temp = 8'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'b1100110);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Checking temperature 7...");
            reset_dut();
            temp = 8'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'b0000111);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Checking temperature 8...");
            reset_dut();
            temp = 8'd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'b1111111);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Checking dynamic update from 0 to 5...");
            reset_dut();
            temp = 8'd0;
            @(posedge clk);
            temp = 8'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'b1101101);
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
        input [6:0] expected_display;
        begin
            if (expected_display === (expected_display ^ display ^ expected_display)) begin
                $display("PASS");
                $display("  Outputs: display=%h",
                         display);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: display=%h",
                         expected_display);
                $display("  Got:      display=%h",
                         display);
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
        $dumpvars(0,clk, reset, temp, display);
    end

endmodule
