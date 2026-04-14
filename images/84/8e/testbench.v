`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] a;
    reg [9:0] b;
    reg clk;
    wire [23:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            a = 12'd0;
            b = 10'd0;
            @(posedge clk);
            #1;
            $display("Test Case 001: Zero Multiplication (0 * 0)");
            #1;

            check_outputs(24'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            a = 12'hFFF;
            b = 10'h3FF;
            @(posedge clk);
            #1;
            $display("Test Case 002: Maximum Values (4095 * 1023)");
            #1;

            check_outputs(24'd4189185);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            a = 12'd1234;
            b = 10'd1;
            @(posedge clk);
            #1;
            $display("Test Case 003: Identity (1234 * 1)");
            #1;

            check_outputs(24'd1234);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            a = 12'd500;
            b = 10'd256;
            @(posedge clk);
            #1;
            $display("Test Case 004: General Multiplication (500 * 256)");
            #1;

            check_outputs(24'd128000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            a = 12'd4000;
            b = 10'd2;
            @(posedge clk);
            #1;
            $display("Test Case 005: Large A, Small B (4000 * 2)");
            #1;

            check_outputs(24'd8000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            a = 12'hAAA;
            b = 10'h2AA;
            @(posedge clk);
            #1;
            $display("Test Case 006: Bit Patterns (2730 * 682)");
            #1;

            check_outputs(24'd1861860);
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
        input [23:0] expected_p;
        begin
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%h",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h",
                         expected_p);
                $display("  Got:      p=%h",
                         p);
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
        $dumpvars(0,a, b, clk, p);
    end

endmodule
