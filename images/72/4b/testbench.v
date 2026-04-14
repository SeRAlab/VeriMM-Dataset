`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg rst_all;
    reg rst_dev;
    wire rst_adc;
    wire rst_adc2fifod;
    wire rst_eth2mac;
    wire rst_fifoc;
    wire rst_fifoc2cs;
    wire rst_fifod;
    wire rst_fifod2mac;
    wire rst_mac;
    wire rst_mac2fifoc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rst_all(rst_all),
        .rst_dev(rst_dev),
        .rst_adc(rst_adc),
        .rst_adc2fifod(rst_adc2fifod),
        .rst_eth2mac(rst_eth2mac),
        .rst_fifoc(rst_fifoc),
        .rst_fifoc2cs(rst_fifoc2cs),
        .rst_fifod(rst_fifod),
        .rst_fifod2mac(rst_fifod2mac),
        .rst_mac(rst_mac),
        .rst_mac2fifoc(rst_mac2fifoc)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Reset Inactive", test_num);
            rst_all = 1'b0;
            rst_dev = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: System Reset (rst_all) Active", test_num);
            rst_all = 1'b1;
            rst_dev = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Device Reset (rst_dev) Active", test_num);
            rst_all = 1'b0;
            rst_dev = 1'b1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Both Resets Active", test_num);
            rst_all = 1'b1;
            rst_dev = 1'b1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Toggle Logic", test_num);
            rst_all = 1'b1;
            rst_dev = 1'b1;
            #10;
            rst_all = 1'b0;
            #10;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0);
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
        input expected_rst_adc;
        input expected_rst_adc2fifod;
        input expected_rst_eth2mac;
        input expected_rst_fifoc;
        input expected_rst_fifoc2cs;
        input expected_rst_fifod;
        input expected_rst_fifod2mac;
        input expected_rst_mac;
        input expected_rst_mac2fifoc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rst_adc === (expected_rst_adc ^ rst_adc ^ expected_rst_adc) &&
                expected_rst_adc2fifod === (expected_rst_adc2fifod ^ rst_adc2fifod ^ expected_rst_adc2fifod) &&
                expected_rst_eth2mac === (expected_rst_eth2mac ^ rst_eth2mac ^ expected_rst_eth2mac) &&
                expected_rst_fifoc === (expected_rst_fifoc ^ rst_fifoc ^ expected_rst_fifoc) &&
                expected_rst_fifoc2cs === (expected_rst_fifoc2cs ^ rst_fifoc2cs ^ expected_rst_fifoc2cs) &&
                expected_rst_fifod === (expected_rst_fifod ^ rst_fifod ^ expected_rst_fifod) &&
                expected_rst_fifod2mac === (expected_rst_fifod2mac ^ rst_fifod2mac ^ expected_rst_fifod2mac) &&
                expected_rst_mac === (expected_rst_mac ^ rst_mac ^ expected_rst_mac) &&
                expected_rst_mac2fifoc === (expected_rst_mac2fifoc ^ rst_mac2fifoc ^ expected_rst_mac2fifoc)) begin
                $display("PASS");
                $display("  Outputs: rst_adc=%b, rst_adc2fifod=%b, rst_eth2mac=%b, rst_fifoc=%b, rst_fifoc2cs=%b, rst_fifod=%b, rst_fifod2mac=%b, rst_mac=%b, rst_mac2fifoc=%b",
                         rst_adc, rst_adc2fifod, rst_eth2mac, rst_fifoc, rst_fifoc2cs, rst_fifod, rst_fifod2mac, rst_mac, rst_mac2fifoc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rst_adc=%b, rst_adc2fifod=%b, rst_eth2mac=%b, rst_fifoc=%b, rst_fifoc2cs=%b, rst_fifod=%b, rst_fifod2mac=%b, rst_mac=%b, rst_mac2fifoc=%b",
                         expected_rst_adc, expected_rst_adc2fifod, expected_rst_eth2mac, expected_rst_fifoc, expected_rst_fifoc2cs, expected_rst_fifod, expected_rst_fifod2mac, expected_rst_mac, expected_rst_mac2fifoc);
                $display("  Got:      rst_adc=%b, rst_adc2fifod=%b, rst_eth2mac=%b, rst_fifoc=%b, rst_fifoc2cs=%b, rst_fifod=%b, rst_fifod2mac=%b, rst_mac=%b, rst_mac2fifoc=%b",
                         rst_adc, rst_adc2fifod, rst_eth2mac, rst_fifoc, rst_fifoc2cs, rst_fifod, rst_fifod2mac, rst_mac, rst_mac2fifoc);
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
