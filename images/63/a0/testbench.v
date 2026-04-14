`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg temp_above_threshold;
    reg temp_below_threshold;
    wire heating;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk(clk),
        .temp_above_threshold(temp_above_threshold),
        .temp_below_threshold(temp_below_threshold),
        .heating(heating)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

    begin
        areset = 1;
        temp_above_threshold = 0;
        temp_below_threshold = 0;
        #15;
        areset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Reset Check");
        reset_dut();
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Remain in Off");
        reset_dut();
        @(posedge clk);
        temp_below_threshold = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Transition Off to On");
        reset_dut();
        @(posedge clk);
        temp_below_threshold = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Remain in On");
        reset_dut();
        @(posedge clk);
        temp_below_threshold = 1;
        @(posedge clk);
        temp_below_threshold = 0;
        temp_above_threshold = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Transition On to Off");
        reset_dut();
        @(posedge clk);
        temp_below_threshold = 1;
        @(posedge clk);
        temp_below_threshold = 0;
        temp_above_threshold = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Async Reset from On State");
        reset_dut();
        @(posedge clk);
        temp_below_threshold = 1;
        @(posedge clk);
        #2;
        areset = 1;
        #1;
        #1;

        check_outputs(1'b0);
        areset = 0;
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
        input expected_heating;
        begin
            if (expected_heating === (expected_heating ^ heating ^ expected_heating)) begin
                $display("PASS");
                $display("  Outputs: heating=%b",
                         heating);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: heating=%b",
                         expected_heating);
                $display("  Got:      heating=%b",
                         heating);
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
        $dumpvars(0,areset, clk, temp_above_threshold, temp_below_threshold, heating);
    end

endmodule
