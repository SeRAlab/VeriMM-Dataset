`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] temperature;
    wire fan_on;
    wire [7:0] fan_speed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .temperature(temperature),
        .fan_on(fan_on),
        .fan_speed(fan_speed)
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
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset State");
            reset_dut();

            #1;


            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Temperature below Threshold");
            reset_dut();
            temperature = 8'd25;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Gradual Ramp Up");
            reset_dut();
            temperature = 8'd100;


            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'd10);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Reaching Target Speed");
            reset_dut();
            temperature = 8'd50;
            repeat(60) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'd50);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Gradual Ramp Down");
            reset_dut();
            temperature = 8'd100;
            repeat(110) @(posedge clk);
            temperature = 8'd80;
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'd90);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Deactivation");
            reset_dut();
            temperature = 8'd50;
            repeat(60) @(posedge clk);
            temperature = 8'd10;
            repeat(60) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Max Speed Limit");
            reset_dut();
            temperature = 8'hFF;
            repeat(260) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'hFF);
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
        input expected_fan_on;
        input [7:0] expected_fan_speed;
        begin
            if (expected_fan_on === (expected_fan_on ^ fan_on ^ expected_fan_on) &&
                expected_fan_speed === (expected_fan_speed ^ fan_speed ^ expected_fan_speed)) begin
                $display("PASS");
                $display("  Outputs: fan_on=%b, fan_speed=%h",
                         fan_on, fan_speed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fan_on=%b, fan_speed=%h",
                         expected_fan_on, expected_fan_speed);
                $display("  Got:      fan_on=%b, fan_speed=%h",
                         fan_on, fan_speed);
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
        $dumpvars(0,clk, reset, temperature, fan_on, fan_speed);
    end

endmodule
