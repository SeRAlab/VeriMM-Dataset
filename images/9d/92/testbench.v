`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg tempReady;
    wire compareData;
    wire load;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .tempReady(tempReady),
        .compareData(compareData),
        .load(load)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            tempReady = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Checking Idle State (tempReady=0)", test_num);
            reset_dut();
            tempReady = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Transition to loadValues", test_num);
            reset_dut();
            @(posedge clk) tempReady = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Transition to compare state", test_num);
            reset_dut();
            @(posedge clk) tempReady = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Full cycle back to waitSensor", test_num);
            reset_dut();
            @(posedge clk) tempReady = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Persistent tempReady (Back-to-back)", test_num);
            reset_dut();
            @(posedge clk) tempReady = 1;
            repeat(3) @(posedge clk);

            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1);
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
        input expected_compareData;
        input expected_load;
        begin
            if (expected_compareData === (expected_compareData ^ compareData ^ expected_compareData) &&
                expected_load === (expected_load ^ load ^ expected_load)) begin
                $display("PASS");
                $display("  Outputs: compareData=%b, load=%b",
                         compareData, load);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compareData=%b, load=%b",
                         expected_compareData, expected_load);
                $display("  Got:      compareData=%b, load=%b",
                         compareData, load);
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
        $dumpvars(0,clk, tempReady, compareData, load);
    end

endmodule
