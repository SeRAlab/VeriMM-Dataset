`timescale 1ns/1ps

module DVFS_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] temperature;
    reg [7:0] workload;
    wire [1:0] frequency_level;
    wire [1:0] voltage_level;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DVFS_Controller dut (
        .clk(clk),
        .reset(reset),
        .temperature(temperature),
        .workload(workload),
        .frequency_level(frequency_level),
        .voltage_level(voltage_level)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            temperature = 0;
            workload = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Test Case 001: Low Workload, Low Temp");
            temperature = 8'd25;
            workload = 8'd10;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'd0, 2'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Test Case 002: Medium Workload, Normal Temp");
            temperature = 8'd45;
            workload = 8'd50;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'd1, 2'd1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Test Case 003: High Workload, Normal Temp");
            temperature = 8'd60;
            workload = 8'd90;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'd2, 2'd2);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Test Case 004: High Workload, Critical Temp (Throttling)");
            temperature = 8'd95;
            workload = 8'd95;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(2'd1, 2'd1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Test Case 005: Low Workload, High Temp");
            temperature = 8'd90;
            workload = 8'd5;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'd0, 2'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Test Case 006: Max Boundary (100% Workload, 100C Temp)");
            temperature = 8'd100;
            workload = 8'd100;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(2'd1, 2'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DVFS_Controller Testbench");
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
        input [1:0] expected_frequency_level;
        input [1:0] expected_voltage_level;
        begin
            if (expected_frequency_level === (expected_frequency_level ^ frequency_level ^ expected_frequency_level) &&
                expected_voltage_level === (expected_voltage_level ^ voltage_level ^ expected_voltage_level)) begin
                $display("PASS");
                $display("  Outputs: frequency_level=%h, voltage_level=%h",
                         frequency_level, voltage_level);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency_level=%h, voltage_level=%h",
                         expected_frequency_level, expected_voltage_level);
                $display("  Got:      frequency_level=%h, voltage_level=%h",
                         frequency_level, voltage_level);
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
        $dumpvars(0,clk, reset, temperature, workload, frequency_level, voltage_level);
    end

endmodule
