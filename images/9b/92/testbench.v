`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire clk_100mhz_o;
    wire clk_200mhz_o;
    wire clk_adc2x_o;
    wire clk_adc_o;
    wire clk_sys_o;
    wire rstn_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_100mhz_o(clk_100mhz_o),
        .clk_200mhz_o(clk_200mhz_o),
        .clk_adc2x_o(clk_adc2x_o),
        .clk_adc_o(clk_adc_o),
        .clk_sys_o(clk_sys_o),
        .rstn_o(rstn_o)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Checking initial state at t=2ns", test_num);
        #1;

        #1;


        check_outputs(0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Checking clk_200mhz high phase at t=4ns", test_num);
        #2;
        #1;

        check_outputs(0, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Checking clk_100mhz high phase at t=7ns", test_num);
        #3;
        #1;

        check_outputs(1, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Checking reset release and clk_sys at t=12ns", test_num);
        #5;
        #1;

        check_outputs(0, 0, 0, 0, 1, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Checking clk_adc at t=32ns", test_num);
        #20;
        #1;

        check_outputs(0, 0, 0, 1, 1, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Checking clk_adc2x at t=72ns", test_num);
        #40;
        #1;

        check_outputs(0, 0, 1, 1, 1, 1);
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
        input expected_clk_100mhz_o;
        input expected_clk_200mhz_o;
        input expected_clk_adc2x_o;
        input expected_clk_adc_o;
        input expected_clk_sys_o;
        input expected_rstn_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clk_100mhz_o === (expected_clk_100mhz_o ^ clk_100mhz_o ^ expected_clk_100mhz_o) &&
                expected_clk_200mhz_o === (expected_clk_200mhz_o ^ clk_200mhz_o ^ expected_clk_200mhz_o) &&
                expected_clk_adc2x_o === (expected_clk_adc2x_o ^ clk_adc2x_o ^ expected_clk_adc2x_o) &&
                expected_clk_adc_o === (expected_clk_adc_o ^ clk_adc_o ^ expected_clk_adc_o) &&
                expected_clk_sys_o === (expected_clk_sys_o ^ clk_sys_o ^ expected_clk_sys_o) &&
                expected_rstn_o === (expected_rstn_o ^ rstn_o ^ expected_rstn_o)) begin
                $display("PASS");
                $display("  Outputs: clk_100mhz_o=%b, clk_200mhz_o=%b, clk_adc2x_o=%b, clk_adc_o=%b, clk_sys_o=%b, rstn_o=%b",
                         clk_100mhz_o, clk_200mhz_o, clk_adc2x_o, clk_adc_o, clk_sys_o, rstn_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_100mhz_o=%b, clk_200mhz_o=%b, clk_adc2x_o=%b, clk_adc_o=%b, clk_sys_o=%b, rstn_o=%b",
                         expected_clk_100mhz_o, expected_clk_200mhz_o, expected_clk_adc2x_o, expected_clk_adc_o, expected_clk_sys_o, expected_rstn_o);
                $display("  Got:      clk_100mhz_o=%b, clk_200mhz_o=%b, clk_adc2x_o=%b, clk_adc_o=%b, clk_sys_o=%b, rstn_o=%b",
                         clk_100mhz_o, clk_200mhz_o, clk_adc2x_o, clk_adc_o, clk_sys_o, rstn_o);
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

endmodule
