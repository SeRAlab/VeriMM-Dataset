`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg reset;
    reg threshold;
    reg voltage;
    wire bor_reset;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .reset(reset),
        .threshold(threshold),
        .voltage(voltage),
        .bor_reset(bor_reset)
    );

    // Clock generation (10ns period)
    initial begin
        reset = 0;
        forever #5 reset = ~reset;
    end

        task reset_dut;

    begin

        voltage = 1'b1;
        threshold = 1'b0;

        wait(reset == 0);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Manual Reset High", test_num);


        wait(reset == 1);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Brown-out (Voltage < Threshold)", test_num);

        voltage = 1'b0;
        threshold = 1'b1;

        wait(reset == 0);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Normal Operation (Voltage > Threshold)", test_num);

        voltage = 1'b1;
        threshold = 1'b0;
        wait(reset == 0);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Edge Case (Voltage == Threshold)", test_num);

        voltage = 1'b1;
        threshold = 1'b1;
        wait(reset == 0);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Manual Reset Dominance", test_num);

        voltage = 1'b1;
        threshold = 1'b0;
        wait(reset == 1);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Recovery from Brown-out", test_num);


        voltage = 1'b0;
        threshold = 1'b1;
        wait(reset == 0);
        #2;


        voltage = 1'b1;
        #2;
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
        input expected_bor_reset;
        begin
            if (expected_bor_reset === (expected_bor_reset ^ bor_reset ^ expected_bor_reset)) begin
                $display("PASS");
                $display("  Outputs: bor_reset=%b",
                         bor_reset);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bor_reset=%b",
                         expected_bor_reset);
                $display("  Got:      bor_reset=%b",
                         bor_reset);
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
        $dumpvars(0,reset, threshold, voltage, bor_reset);
    end

endmodule
