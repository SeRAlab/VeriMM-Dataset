`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] duty;
    reg en;
    reg [15:0] freq;
    reg rst;
    wire clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .duty(duty),
        .en(en),
        .freq(freq),
        .rst(rst),
        .clk(clk)
    );

    // Clock generation (10ns period)
    initial begin
        rst = 0;
        forever #5 rst = ~rst;
    end

        task reset_dut;

        begin
            en = 1'b0;
            freq = 16'd0;
            duty = 16'd0;

            repeat(2) @(posedge rst);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: 50%% Duty Cycle, High Phase", test_num);
            freq = 16'd10;
            duty = 16'd50;
            en = 1'b1;

            repeat(3) @(posedge rst);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: 50%% Duty Cycle, Low Phase", test_num);
            freq = 16'd10;
            duty = 16'd50;
            en = 1'b1;

            repeat(8) @(posedge rst);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: 20%% Duty Cycle, Low Phase", test_num);
            freq = 16'd10;
            duty = 16'd20;
            en = 1'b1;

            repeat(5) @(posedge rst);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: 80%% Duty Cycle, High Phase", test_num);
            freq = 16'd10;
            duty = 16'd80;
            en = 1'b1;

            repeat(6) @(posedge rst);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: Module Disabled (en=0)", test_num);
            freq = 16'd10;
            duty = 16'd50;
            en = 1'b0;
            repeat(5) @(posedge rst);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case %0d: 100%% Duty Cycle", test_num);
            freq = 16'd10;
            duty = 16'd100;
            en = 1'b1;
            repeat(9) @(posedge rst);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test Case %0d: 0%% Duty Cycle", test_num);
            freq = 16'd10;
            duty = 16'd0;
            en = 1'b1;
            repeat(5) @(posedge rst);
            #1;
            #1;

            check_outputs(1'b0);
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
        input expected_clk;
        begin
            if (expected_clk === (expected_clk ^ clk ^ expected_clk)) begin
                $display("PASS");
                $display("  Outputs: clk=%b",
                         clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk=%b",
                         expected_clk);
                $display("  Got:      clk=%b",
                         clk);
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
        $dumpvars(0,duty, en, freq, rst, clk);
    end

endmodule
