`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg rst;
    wire [4:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .rst(rst),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst = 1;
            enable = 0;
            @(negedge clk);
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset State");
            reset_dut();

            #1;


            check_outputs(5'b00001);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: One shift cycle");
            reset_dut();
            @(negedge clk);
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00010);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Full rotation back to start");
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Enable logic (Hold value)");
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat(2) @(posedge clk);
            @(negedge clk);
            enable = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00100);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Wraparound boundary (bit 4 high)");
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Synchronous reset while counter is active");
            reset_dut();
            @(negedge clk);
            enable = 1;
            repeat(3) @(posedge clk);
            @(negedge clk);
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00001);
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
        input [4:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, enable, rst, count);
    end

endmodule
