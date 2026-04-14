`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [3:0] ground;
    reg rst;
    reg [3:0] voltage;
    wire ground_error;
    wire [3:0] ground_out;
    wire voltage_error;
    wire [3:0] voltage_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .ground(ground),
        .rst(rst),
        .voltage(voltage),
        .ground_error(ground_error),
        .ground_out(ground_out),
        .voltage_error(voltage_error),
        .voltage_out(voltage_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            voltage = 0;
            ground = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset Priority");
            reset_dut();
            voltage = 4'hA;
            ground = 4'h5;
            enable = 1;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 4'h0, 0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Normal Operation (Enabled)");
            reset_dut();
            voltage = 4'hC;
            ground = 4'h3;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 4'h3, 0, 4'hC);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Module Disabled");
            reset_dut();
            voltage = 4'hF;
            ground = 4'hF;
            enable = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 4'h0, 0, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Boundary Values");
            reset_dut();
            voltage = 4'd15;
            ground = 4'd0;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 4'd0, 0, 4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Enable Toggle Transition");
            reset_dut();

            voltage = 4'h7;
            ground = 4'h2;
            enable = 1;
            @(posedge clk);
            #1;

            enable = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 4'h0, 0, 4'h0);
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
        input expected_ground_error;
        input [3:0] expected_ground_out;
        input expected_voltage_error;
        input [3:0] expected_voltage_out;
        begin
            if (expected_ground_error === (expected_ground_error ^ ground_error ^ expected_ground_error) &&
                expected_ground_out === (expected_ground_out ^ ground_out ^ expected_ground_out) &&
                expected_voltage_error === (expected_voltage_error ^ voltage_error ^ expected_voltage_error) &&
                expected_voltage_out === (expected_voltage_out ^ voltage_out ^ expected_voltage_out)) begin
                $display("PASS");
                $display("  Outputs: ground_error=%b, ground_out=%h, voltage_error=%b, voltage_out=%h",
                         ground_error, ground_out, voltage_error, voltage_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ground_error=%b, ground_out=%h, voltage_error=%b, voltage_out=%h",
                         expected_ground_error, expected_ground_out, expected_voltage_error, expected_voltage_out);
                $display("  Got:      ground_error=%b, ground_out=%h, voltage_error=%b, voltage_out=%h",
                         ground_error, ground_out, voltage_error, voltage_out);
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
        $dumpvars(0,clk, enable, ground, rst, voltage, ground_error, ground_out, voltage_error, voltage_out);
    end

endmodule
