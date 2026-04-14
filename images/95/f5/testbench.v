`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] binary;
    reg clk;
    wire [7:0] bcd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary(binary),
        .clk(clk),
        .bcd(bcd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            binary <= 4'b0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            binary <= 4'd0;
            repeat(4) @(posedge clk);
            $display("Test Case 001: Binary 0");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            binary <= 4'd4;
            repeat(4) @(posedge clk);
            $display("Test Case 002: Binary 4");
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            binary <= 4'd5;
            repeat(4) @(posedge clk);
            $display("Test Case 003: Binary 5");
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            binary <= 4'd9;
            repeat(4) @(posedge clk);
            $display("Test Case 004: Binary 9");
            #1;

            check_outputs(8'h09);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            binary <= 4'd10;
            repeat(4) @(posedge clk);
            $display("Test Case 005: Binary 10");
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            binary <= 4'd12;
            repeat(4) @(posedge clk);
            $display("Test Case 006: Binary 12");
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            binary <= 4'd15;
            repeat(4) @(posedge clk);
            $display("Test Case 007: Binary 15");
            #1;

            check_outputs(8'h15);
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
        input [7:0] expected_bcd;
        begin
            if (expected_bcd === (expected_bcd ^ bcd ^ expected_bcd)) begin
                $display("PASS");
                $display("  Outputs: bcd=%h",
                         bcd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd=%h",
                         expected_bcd);
                $display("  Got:      bcd=%h",
                         bcd);
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
        $dumpvars(0,binary, clk, bcd);
    end

endmodule
