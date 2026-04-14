`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] blue_intensity;
    reg clk;
    reg [3:0] green_intensity;
    reg [3:0] red_intensity;
    reg reset;
    wire [9:0] blue_voltage;
    wire [9:0] green_voltage;
    wire [9:0] red_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .blue_intensity(blue_intensity),
        .clk(clk),
        .green_intensity(green_intensity),
        .red_intensity(red_intensity),
        .reset(reset),
        .blue_voltage(blue_voltage),
        .green_voltage(green_voltage),
        .red_voltage(red_voltage)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            red_intensity = 0;
            green_intensity = 0;
            blue_intensity = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initialization (Reset)", test_num);
            reset_dut();

            #1;


            check_outputs(10'd0, 10'd0, 10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum Non-Zero Intensity (1 * 64)", test_num);
            reset_dut();
            red_intensity   = 4'd1;
            green_intensity = 4'd1;
            blue_intensity  = 4'd1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(10'd64, 10'd64, 10'd64);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Intensity (15 * 64)", test_num);
            reset_dut();
            red_intensity   = 4'd15;
            green_intensity = 4'd15;
            blue_intensity  = 4'd15;
            @(posedge clk);
            #1;

            #1;


            check_outputs(10'd960, 10'd960, 10'd960);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Intensities", test_num);
            reset_dut();
            red_intensity   = 4'd2;
            green_intensity = 4'd8;
            blue_intensity  = 4'd14;
            @(posedge clk);
            #1;

            #1;


            check_outputs(10'd896, 10'd512, 10'd128);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset during operation", test_num);
            reset_dut();
            red_intensity   = 4'd10;
            green_intensity = 4'd10;
            blue_intensity  = 4'd10;
            @(posedge clk);
            #1;

            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;

            #1;


            check_outputs(10'd0, 10'd0, 10'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Middle Intensity Values", test_num);
            reset_dut();
            red_intensity   = 4'd4;
            green_intensity = 4'd7;
            blue_intensity  = 4'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'd192, 10'd448, 10'd256);
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
        input [9:0] expected_blue_voltage;
        input [9:0] expected_green_voltage;
        input [9:0] expected_red_voltage;
        begin
            if (expected_blue_voltage === (expected_blue_voltage ^ blue_voltage ^ expected_blue_voltage) &&
                expected_green_voltage === (expected_green_voltage ^ green_voltage ^ expected_green_voltage) &&
                expected_red_voltage === (expected_red_voltage ^ red_voltage ^ expected_red_voltage)) begin
                $display("PASS");
                $display("  Outputs: blue_voltage=%h, green_voltage=%h, red_voltage=%h",
                         blue_voltage, green_voltage, red_voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: blue_voltage=%h, green_voltage=%h, red_voltage=%h",
                         expected_blue_voltage, expected_green_voltage, expected_red_voltage);
                $display("  Got:      blue_voltage=%h, green_voltage=%h, red_voltage=%h",
                         blue_voltage, green_voltage, red_voltage);
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
        $dumpvars(0,blue_intensity, clk, green_intensity, red_intensity, reset, blue_voltage, green_voltage, red_voltage);
    end

endmodule
