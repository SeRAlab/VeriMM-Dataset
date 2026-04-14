`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] ambient_light;
    reg [7:0] brightness_level;
    reg clk;
    reg rst;
    wire [7:0] brightness;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ambient_light(ambient_light),
        .brightness_level(brightness_level),
        .clk(clk),
        .rst(rst),
        .brightness(brightness)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        ambient_light = 0;
        brightness_level = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        ambient_light = 8'd45;
        brightness_level = 8'd100;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(8'd45);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        ambient_light = 8'd200;
        brightness_level = 8'd120;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(8'd120);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        ambient_light = 8'd75;
        brightness_level = 8'd75;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(8'd75);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        ambient_light = 8'd0;
        brightness_level = 8'd255;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        ambient_light = 8'd150;
        brightness_level = 8'd0;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        ambient_light = 8'hFF;
        brightness_level = 8'hFF;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase007;

    begin

        ambient_light = 8'd100;
        brightness_level = 8'd100;
        @(posedge clk);

        rst = 1;
        test_num = 7;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(8'd0);
        rst = 0;
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
        input [7:0] expected_brightness;
        begin
            if (expected_brightness === (expected_brightness ^ brightness ^ expected_brightness)) begin
                $display("PASS");
                $display("  Outputs: brightness=%h",
                         brightness);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: brightness=%h",
                         expected_brightness);
                $display("  Got:      brightness=%h",
                         brightness);
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
        $dumpvars(0,ambient_light, brightness_level, clk, rst, brightness);
    end

endmodule
