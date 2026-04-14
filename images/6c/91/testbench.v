`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg fdc_activity_i;
    reg fdc_motor_i;
    wire led_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .fdc_activity_i(fdc_activity_i),
        .fdc_motor_i(fdc_motor_i),
        .led_o(led_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            fdc_activity_i = 0;
            fdc_motor_i = 0;
            repeat(10) @(posedge clk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            repeat(5) @(posedge clk_i);
            $display("Test %0d: Idle State (Activity=0, Motor=0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk_i);
            fdc_activity_i = 1;

            repeat(2) @(posedge clk_i);
            $display("Test %0d: FDC Activity Active", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge clk_i);
            fdc_motor_i = 1;


            @(posedge clk_i);
            $display("Test %0d: Motor Active at Initial Cycle", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge clk_i);
            fdc_activity_i = 1;

            repeat(50) @(posedge clk_i);
            $display("Test %0d: Sustained Activity", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge clk_i);
            fdc_activity_i = 1;
            repeat(5) @(posedge clk_i);
            fdc_activity_i = 0;

            repeat(2) @(posedge clk_i);
            $display("Test %0d: Activity Turned Off", test_num);

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
        input expected_led_o;
        begin
            if (expected_led_o === (expected_led_o ^ led_o ^ expected_led_o)) begin
                $display("PASS");
                $display("  Outputs: led_o=%b",
                         led_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led_o=%b",
                         expected_led_o);
                $display("  Got:      led_o=%b",
                         led_o);
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
        $dumpvars(0,clk_i, fdc_activity_i, fdc_motor_i, led_o);
    end

endmodule
