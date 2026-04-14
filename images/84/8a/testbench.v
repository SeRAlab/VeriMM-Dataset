`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg debounce_clk;
    reg key;
    wire key_pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .debounce_clk(debounce_clk),
        .key(key),
        .key_pulse(key_pulse)
    );

    // Clock generation (10ns period)
    initial begin
        debounce_clk = 0;
        forever #5 debounce_clk = ~debounce_clk;
    end

        task reset_dut;

    begin
        key = 0;

        repeat(5) @(posedge debounce_clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive Edge Pulse Detection", test_num);
        reset_dut();

        @(posedge debounce_clk);
        key = 1;




        repeat(2) @(posedge debounce_clk);
        #1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Pulse Duration and Stability (Key held high)", test_num);
        reset_dut();

        @(posedge debounce_clk);
        key = 1;


        repeat(3) @(posedge debounce_clk);
        #1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Idle State (Key low)", test_num);
        reset_dut();

        key = 0;
        repeat(4) @(posedge debounce_clk);
        #1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Falling Edge Rejection", test_num);
        reset_dut();


        key = 1;
        repeat(4) @(posedge debounce_clk);


        @(posedge debounce_clk);
        key = 0;

        repeat(2) @(posedge debounce_clk);
        #1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Successive Press Detection", test_num);
        reset_dut();


        @(posedge debounce_clk);
        key = 1;
        repeat(3) @(posedge debounce_clk);
        key = 0;
        repeat(3) @(posedge debounce_clk);


        key = 1;
        @(posedge debounce_clk);
        @(posedge debounce_clk);
        #1;

        #1;


        check_outputs(1'b1);
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
        input expected_key_pulse;
        begin
            if (expected_key_pulse === (expected_key_pulse ^ key_pulse ^ expected_key_pulse)) begin
                $display("PASS");
                $display("  Outputs: key_pulse=%b",
                         key_pulse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: key_pulse=%b",
                         expected_key_pulse);
                $display("  Got:      key_pulse=%b",
                         key_pulse);
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
        $dumpvars(0,debounce_clk, key, key_pulse);
    end

endmodule
