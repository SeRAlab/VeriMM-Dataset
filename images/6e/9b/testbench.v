`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg enable;
    reg load;
    reg [9:0] load_value;
    wire [9:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .enable(enable),
        .load(load),
        .load_value(load_value),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clear = 1;
            enable = 0;
            load = 0;
            load_value = 0;
            @(posedge clk);
            #1 clear = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Incrementing for 10 cycles");
            reset_dut();
            enable = 1;
            repeat(10) @(posedge clk);
            #1 enable = 0;
            #1;

            check_outputs(10'd10);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Loading a specific value");
            reset_dut();
            load_value = 10'h2AA;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(10'h2AA);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Priority - Clear should override Load and Enable");
            reset_dut();
            load_value = 10'hFFF;
            load = 1;
            enable = 1;
            clear = 1;
            @(posedge clk);
            #1 clear = 0; load = 0; enable = 0;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Priority - Load should override Enable");
            reset_dut();
            load_value = 10'h123;
            load = 1;
            enable = 1;
            @(posedge clk);
            #1 load = 0; enable = 0;
            #1;

            check_outputs(10'h123);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Testing overflow/wrap around at 1023");
            reset_dut();
            load_value = 10'h3FF;
            load = 1;
            @(posedge clk);
            #1 load = 0; enable = 1;
            @(posedge clk);
            #1 enable = 0;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Testing Enable=0 holds the value");
            reset_dut();
            load_value = 10'd50;
            load = 1;
            @(posedge clk);
            #1 load = 0; enable = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(10'd50);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Load value then increment multiple times");
            reset_dut();
            load_value = 10'd100;
            load = 1;
            @(posedge clk);
            #1 load = 0; enable = 1;
            repeat(5) @(posedge clk);
            #1 enable = 0;
            #1;

            check_outputs(10'd105);
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
        input [9:0] expected_count;
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
        $dumpvars(0,clear, clk, enable, load, load_value, count);
    end

endmodule
