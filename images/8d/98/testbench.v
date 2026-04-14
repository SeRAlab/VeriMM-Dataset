`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg rst;
    wire green_light;
    wire red_light;
    wire yellow_light;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .rst(rst),
        .green_light(green_light),
        .red_light(red_light),
        .yellow_light(yellow_light)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 1;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Initial Green State check...");
            reset_dut();

            @(posedge clk);
            #1 #1;
 check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Transition to Yellow after 10s...");
            reset_dut();

            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Transition to Red after 12s...");
            reset_dut();

            repeat(12) @(posedge clk);
            #1 #1;
 check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Return to Green after full cycle (20s)...");
            reset_dut();
            repeat(20) @(posedge clk);
            #1 #1;
 check_outputs(1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Disable check (All lights OFF)...");
            reset_dut();
            repeat(5) @(posedge clk);
            enable = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Enable recovery (Reset to Green)...");
            reset_dut();
            repeat(15) @(posedge clk);
            enable = 0;
            repeat(2) @(posedge clk);
            enable = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1, 0, 0);
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
        input expected_green_light;
        input expected_red_light;
        input expected_yellow_light;
        begin
            if (expected_green_light === (expected_green_light ^ green_light ^ expected_green_light) &&
                expected_red_light === (expected_red_light ^ red_light ^ expected_red_light) &&
                expected_yellow_light === (expected_yellow_light ^ yellow_light ^ expected_yellow_light)) begin
                $display("PASS");
                $display("  Outputs: green_light=%b, red_light=%b, yellow_light=%b",
                         green_light, red_light, yellow_light);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: green_light=%b, red_light=%b, yellow_light=%b",
                         expected_green_light, expected_red_light, expected_yellow_light);
                $display("  Got:      green_light=%b, red_light=%b, yellow_light=%b",
                         green_light, red_light, yellow_light);
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
        $dumpvars(0,clk, enable, rst, green_light, red_light, yellow_light);
    end

endmodule
