`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] SW;
    reg [3:0] button;
    reg clk;
    wire [7:0] SW_OK;
    wire [3:0] button_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SW(SW),
        .button(button),
        .clk(clk),
        .SW_OK(SW_OK),
        .button_out(button_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            SW = 8'h00;
            button = 4'b0000;
            repeat (5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Glitch Rejection...");
            reset_dut();
            SW = 8'hAA;
            button = 4'b0001;
            repeat (5) @(posedge clk);
            button = 4'b0000;
            repeat (50) @(posedge clk);
            #1;

            check_outputs(8'h00, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Sustained Press...");
            reset_dut();
            SW = 8'h55;
            button = 4'b0010;
            repeat (100) @(posedge clk);
            #1;

            check_outputs(8'h55, 4'b0010);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Multiple Buttons...");
            reset_dut();
            SW = 8'hF0;
            button = 4'b1100;
            repeat (100) @(posedge clk);
            #1;

            check_outputs(8'hF0, 4'b1100);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Sustained Release...");
            reset_dut();

            button = 4'b1000;
            SW = 8'hEE;
            repeat (100) @(posedge clk);

            button = 4'b0000;
            repeat (100) @(posedge clk);
            #1;

            check_outputs(8'hEE, 4'b0000);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Switch Change while Pressed...");
            reset_dut();
            button = 4'b0001;
            SW = 8'h11;
            repeat (100) @(posedge clk);
            SW = 8'h99;
            repeat (20) @(posedge clk);
            #1;

            check_outputs(8'h99, 4'b0001);
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
        input [7:0] expected_SW_OK;
        input [3:0] expected_button_out;
        begin
            if (expected_SW_OK === (expected_SW_OK ^ SW_OK ^ expected_SW_OK) &&
                expected_button_out === (expected_button_out ^ button_out ^ expected_button_out)) begin
                $display("PASS");
                $display("  Outputs: SW_OK=%h, button_out=%h",
                         SW_OK, button_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SW_OK=%h, button_out=%h",
                         expected_SW_OK, expected_button_out);
                $display("  Got:      SW_OK=%h, button_out=%h",
                         SW_OK, button_out);
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
        $dumpvars(0,SW, button, clk, SW_OK, button_out);
    end

endmodule
