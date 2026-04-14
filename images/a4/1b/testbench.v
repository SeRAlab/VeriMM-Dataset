`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [31:0] U1;
    wire [31:0] U2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .U1(U1),
        .U2(U2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
            $display("\n[System] Reset Applied");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase 001: Initial state check...");
            reset_dut();

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h12345678, 32'h87654321);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase 002: First clock transition...");
            reset_dut();
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(32'hA5A5A5A5, 32'h5A5A5A5A);
        end
        endtask

    task testcase003;

        reg [31:0] first_U1, first_U2;
        begin
            test_num = 3;
            $display("Running Testcase 003: Determinism/Repeatability check...");


            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            first_U1 = U1;
            first_U2 = U2;


            reset_dut();
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(first_U1, first_U2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase 004: 10-cycle progression check...");
            reset_dut();
            repeat(11) @(posedge clk);
            #1;

            #1;


            check_outputs(32'hDEADBEEF, 32'hCAFEBABE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase 005: Non-zero stability check...");
            reset_dut();
            repeat(100) @(posedge clk);
            #1;
            if (U1 != 32'h0 && U2 != 32'h0) begin
                pass_count = pass_count + 1;
                $display("PASS: Test 5 (Output stable and non-zero)");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Test 5 (Output collapsed to zero)");
            end
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
        input [31:0] expected_U1;
        input [31:0] expected_U2;
        begin
            if (expected_U1 === (expected_U1 ^ U1 ^ expected_U1) &&
                expected_U2 === (expected_U2 ^ U2 ^ expected_U2)) begin
                $display("PASS");
                $display("  Outputs: U1=%h, U2=%h",
                         U1, U2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: U1=%h, U2=%h",
                         expected_U1, expected_U2);
                $display("  Got:      U1=%h, U2=%h",
                         U1, U2);
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
        $dumpvars(0,clk, rst, U1, U2);
    end

endmodule
