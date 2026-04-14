`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg SerialIn;
    reg clk;
    reg rst;
    wire [3:0] BusOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SerialIn(SerialIn),
        .clk(clk),
        .rst(rst),
        .BusOut(BusOut)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            SerialIn = 0;
            @(negedge clk);
            rst = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Shift in 1111");
            reset_dut();

            SerialIn = 1; @(posedge clk); #1;
            SerialIn = 1; @(posedge clk); #1;
            SerialIn = 1; @(posedge clk); #1;
            SerialIn = 1; @(posedge clk); #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Shift in 1011");
            reset_dut();

            SerialIn = 1; @(posedge clk); #1;
            SerialIn = 0; @(posedge clk); #1;
            SerialIn = 1; @(posedge clk); #1;
            SerialIn = 1; @(posedge clk); #1;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Shift in 0110");
            reset_dut();

            SerialIn = 0; @(posedge clk); #1;
            SerialIn = 1; @(posedge clk); #1;
            SerialIn = 1; @(posedge clk); #1;
            SerialIn = 0; @(posedge clk); #1;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Over-shift 11110 (result 1110)");
            reset_dut();
            SerialIn = 1; @(posedge clk); #1;
            SerialIn = 1; @(posedge clk); #1;
            SerialIn = 1; @(posedge clk); #1;
            SerialIn = 1; @(posedge clk); #1;
            SerialIn = 0; @(posedge clk); #1;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Full rotation 10001 (result 0001)");
            reset_dut();
            SerialIn = 1; @(posedge clk); #1;
            SerialIn = 0; @(posedge clk); #1;
            SerialIn = 0; @(posedge clk); #1;
            SerialIn = 0; @(posedge clk); #1;
            SerialIn = 1; @(posedge clk); #1;
            #1;

            check_outputs(4'b0001);
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
        input [3:0] expected_BusOut;
        begin
            if (expected_BusOut === (expected_BusOut ^ BusOut ^ expected_BusOut)) begin
                $display("PASS");
                $display("  Outputs: BusOut=%h",
                         BusOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BusOut=%h",
                         expected_BusOut);
                $display("  Got:      BusOut=%h",
                         BusOut);
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
        $dumpvars(0,SerialIn, clk, rst, BusOut);
    end

endmodule
