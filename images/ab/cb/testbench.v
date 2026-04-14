`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg hi_value;
    reg lo_value;
    wire hi_val;
    wire lo_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .hi_value(hi_value),
        .lo_value(lo_value),
        .hi_val(hi_val),
        .lo_val(lo_val)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        hi_value = 0;
        lo_value = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Reset and Zero Check", test_num);
        reset_dut();
        hi_value = 0;
        lo_value = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Set hi_value=1, lo_value=0", test_num);
        reset_dut();
        hi_value = 1;
        lo_value = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Set hi_value=0, lo_value=1", test_num);
        reset_dut();
        hi_value = 0;
        lo_value = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Set hi_value=1, lo_value=1", test_num);
        reset_dut();
        hi_value = 1;
        lo_value = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Toggle values across multiple cycles", test_num);
        reset_dut();


        hi_value = 1; lo_value = 1;
        @(posedge clk);
        #1;


        hi_value = 0; lo_value = 1;
        @(posedge clk);
        #1;


        hi_value = 1; lo_value = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Edge Sensitivity Check", test_num);
        reset_dut();


        hi_value = 1; lo_value = 1;
        @(posedge clk);
        #1;


        hi_value = 0; lo_value = 0;
        #2;


        #1;



        check_outputs(1, 1);
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
        input expected_hi_val;
        input expected_lo_val;
        begin
            if (expected_hi_val === (expected_hi_val ^ hi_val ^ expected_hi_val) &&
                expected_lo_val === (expected_lo_val ^ lo_val ^ expected_lo_val)) begin
                $display("PASS");
                $display("  Outputs: hi_val=%b, lo_val=%b",
                         hi_val, lo_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hi_val=%b, lo_val=%b",
                         expected_hi_val, expected_lo_val);
                $display("  Got:      hi_val=%b, lo_val=%b",
                         hi_val, lo_val);
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
        $dumpvars(0,clk, hi_value, lo_value, hi_val, lo_val);
    end

endmodule
