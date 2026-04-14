`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg reset;
    wire [15:0] prod;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .prod(prod)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            a = 0;
            b = 0;
            @(posedge clk);
            #1;
            reset = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: 5 * 10");
            reset_dut();
            a = 8'sd5;
            b = 8'sd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd50);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: 0 * 50");
            reset_dut();
            a = 8'sd0;
            b = 8'sd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: -7 * 3");
            reset_dut();
            a = -8'sd7;
            b = 8'sd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-16'sd21);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: 12 * -4");
            reset_dut();
            a = 8'sd12;
            b = -8'sd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-16'sd48);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: -10 * -5");
            reset_dut();
            a = -8'sd10;
            b = -8'sd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd50);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: 127 * 127");
            reset_dut();
            a = 8'sd127;
            b = 8'sd127;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd16129);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: -128 * -128");
            reset_dut();
            a = -8'sd128;
            b = -8'sd128;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd16384);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: -128 * 127");
            reset_dut();
            a = -8'sd128;
            b = 8'sd127;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-16'sd16256);
        end
        endtask

    task testcase009;

        begin
            $display("Running Testcase 009: -45 * 1");
            reset_dut();
            a = -8'sd45;
            b = 8'sd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-16'sd45);
        end
        endtask

    task testcase010;

        begin
            $display("Running Testcase 010: 88 * -1");
            reset_dut();
            a = 8'sd88;
            b = -8'sd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-16'sd88);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_prod;
        begin
            if (expected_prod === (expected_prod ^ prod ^ expected_prod)) begin
                $display("PASS");
                $display("  Outputs: prod=%h",
                         prod);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: prod=%h",
                         expected_prod);
                $display("  Got:      prod=%h",
                         prod);
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
        $dumpvars(0,a, b, clk, reset, prod);
    end

endmodule
