`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [23:0] data_in;
    reg rst;
    wire [5:0] LED_ctrl_rev;
    wire [7:0] LED_out_rev;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .LED_ctrl_rev(LED_ctrl_rev),
        .LED_out_rev(LED_out_rev)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 24'b0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Check Digit 0 (Value 6) immediately after reset");
            test_num = 1;
            reset_dut();
            data_in = 24'h123456;
            @(posedge clk);
            #1;

            #1;


            check_outputs(6'b111110, 8'h82);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Wait for transition to Digit 1 (Value 5)");
            test_num = 2;
            reset_dut();
            data_in = 24'h123456;

            repeat (100000) begin
                @(posedge clk);
                if (LED_ctrl_rev == 6'b111101) break;
            end
            #1;

            #1;


            check_outputs(6'b111101, 8'h92);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Wait for transition to Digit 5 (Value A)");
            test_num = 3;
            reset_dut();
            data_in = 24'hABCDEF;

            repeat (200000) begin
                @(posedge clk);
                if (LED_ctrl_rev == 6'b011111) break;
            end
            #1;

            #1;


            check_outputs(6'b011111, 8'h88);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Check Digit 3 (Value 3)");
            test_num = 4;
            reset_dut();
            data_in = 24'h123456;
            repeat (100000) begin
                @(posedge clk);
                if (LED_ctrl_rev == 6'b110111) break;
            end
            #1;

            #1;


            check_outputs(6'b110111, 8'hB0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Check Digit 0 (Value 1) after data change");
            test_num = 5;
            reset_dut();
            data_in = 24'h654321;
            @(posedge clk);
            #1;

            #1;


            check_outputs(6'b111110, 8'hF9);
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
        input [5:0] expected_LED_ctrl_rev;
        input [7:0] expected_LED_out_rev;
        begin
            if (expected_LED_ctrl_rev === (expected_LED_ctrl_rev ^ LED_ctrl_rev ^ expected_LED_ctrl_rev) &&
                expected_LED_out_rev === (expected_LED_out_rev ^ LED_out_rev ^ expected_LED_out_rev)) begin
                $display("PASS");
                $display("  Outputs: LED_ctrl_rev=%h, LED_out_rev=%h",
                         LED_ctrl_rev, LED_out_rev);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED_ctrl_rev=%h, LED_out_rev=%h",
                         expected_LED_ctrl_rev, expected_LED_out_rev);
                $display("  Got:      LED_ctrl_rev=%h, LED_out_rev=%h",
                         LED_ctrl_rev, LED_out_rev);
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
        $dumpvars(0,clk, data_in, rst, LED_ctrl_rev, LED_out_rev);
    end

endmodule
