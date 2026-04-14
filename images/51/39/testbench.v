`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] D;
    reg clk;
    reg rst;
    wire [4:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .clk(clk),
        .rst(rst),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            D = 5'b00000;
            @(posedge clk);
            #2;
            rst = 1;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Reset state verification");
            reset_dut();
            #1;

            check_outputs(5'b01111);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Shift in logic 1s for 5 cycles");
            reset_dut();
            D = 5'b00001;
            repeat (4) @(posedge clk);
            D = 5'b00001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Shift in single pulse (10000)");
            reset_dut();
            D = 5'b00001; @(posedge clk);
            D = 5'b00000; @(posedge clk);
            D = 5'b00000; @(posedge clk);
            D = 5'b00000; @(posedge clk);
            D = 5'b00000; @(posedge clk);
            #2;
            #1;

            check_outputs(5'b11110);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Shift in 1s then clear with 0s");
            reset_dut();
            D = 5'b00001; repeat (5) @(posedge clk);
            D = 5'b00000; repeat (5) @(posedge clk);
            #2;
            #1;

            check_outputs(5'b01111);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Verify D[4:1] bits are ignored in shift");
            reset_dut();
            D = 5'b11111; repeat (5) @(posedge clk);
            #2;

            #1;


            check_outputs(5'b10000);
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
        input [4:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, clk, rst, Q);
    end

endmodule
