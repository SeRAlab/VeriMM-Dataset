`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] binary_in;
    reg clk;
    wire EN1;
    wire EN2;
    wire EN3;
    wire [3:0] bcd_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_in(binary_in),
        .clk(clk),
        .EN1(EN1),
        .EN2(EN2),
        .EN3(EN3),
        .bcd_out(bcd_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            binary_in = 0;
            repeat(5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: binary_in = 0");
            reset_dut();
            test_num = test_num + 1;
            binary_in = 4'd0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: binary_in = 5");
            reset_dut();
            test_num = test_num + 1;
            binary_in = 4'd5;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 4'd5);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: binary_in = 9");
            reset_dut();
            test_num = test_num + 1;
            binary_in = 4'd9;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 4'd9);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: binary_in = 10");
            reset_dut();
            test_num = test_num + 1;
            binary_in = 4'd10;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: binary_in = 15");
            reset_dut();
            test_num = test_num + 1;
            binary_in = 4'd15;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 4'd5);
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
        input expected_EN1;
        input expected_EN2;
        input expected_EN3;
        input [3:0] expected_bcd_out;
        begin
            if (expected_EN1 === (expected_EN1 ^ EN1 ^ expected_EN1) &&
                expected_EN2 === (expected_EN2 ^ EN2 ^ expected_EN2) &&
                expected_EN3 === (expected_EN3 ^ EN3 ^ expected_EN3) &&
                expected_bcd_out === (expected_bcd_out ^ bcd_out ^ expected_bcd_out)) begin
                $display("PASS");
                $display("  Outputs: EN1=%b, EN2=%b, EN3=%b, bcd_out=%h",
                         EN1, EN2, EN3, bcd_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EN1=%b, EN2=%b, EN3=%b, bcd_out=%h",
                         expected_EN1, expected_EN2, expected_EN3, expected_bcd_out);
                $display("  Got:      EN1=%b, EN2=%b, EN3=%b, bcd_out=%h",
                         EN1, EN2, EN3, bcd_out);
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
        $dumpvars(0,binary_in, clk, EN1, EN2, EN3, bcd_out);
    end

endmodule
