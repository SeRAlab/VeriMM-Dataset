`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] binary1;
    reg [3:0] binary2;
    reg clk;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary1(binary1),
        .binary2(binary2),
        .clk(clk),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            binary1 = 0;
            binary2 = 0;
            repeat(4) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            binary1 = 4'd1;
            binary2 = 4'd1;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase 001: 1 + 1");
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            binary1 = 4'd15;
            binary2 = 4'd1;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase 002: 15 + 1 (Overflow)");
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            binary1 = 4'd15;
            binary2 = 4'd15;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase 003: 15 + 15 (Overflow)");
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            binary1 = 4'd0;
            binary2 = 4'd0;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase 004: 0 + 0");
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            binary1 = 4'd8;
            binary2 = 4'd8;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase 005: 8 + 8 (Overflow)");
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            binary1 = 4'd7;
            binary2 = 4'd4;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase 006: 7 + 4");
            #1;

            check_outputs(4'd11);
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
        input [3:0] expected_sum;
        begin
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
        $dumpvars(0,binary1, binary2, clk, sum);
    end

endmodule
