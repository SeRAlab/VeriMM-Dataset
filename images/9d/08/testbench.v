`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg switch_input;
    wire debounced_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .switch_input(switch_input),
        .debounced_output(debounced_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        switch_input = 0;

        repeat(100) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Stable LOW Input", test_num);
        reset_dut();

        switch_input = 0;
        repeat(50) @(posedge clk);

        #1;


        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: High-going Glitch (Filtering)", test_num);
        reset_dut();


        @(posedge clk) switch_input = 1;
        repeat(2) @(posedge clk);
        switch_input = 0;


        repeat(50) @(posedge clk);

        #1;


        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Sustained HIGH Input", test_num);
        reset_dut();

        switch_input = 1;

        repeat(100) @(posedge clk);

        #1;


        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Bouncing Press Transition", test_num);
        reset_dut();


        switch_input = 1; repeat(2) @(posedge clk);
        switch_input = 0; repeat(2) @(posedge clk);
        switch_input = 1; repeat(3) @(posedge clk);
        switch_input = 0; repeat(1) @(posedge clk);


        switch_input = 1;
        repeat(100) @(posedge clk);

        #1;


        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Bouncing Release Transition", test_num);
        reset_dut();


        switch_input = 1;
        repeat(100) @(posedge clk);


        switch_input = 0; repeat(2) @(posedge clk);
        switch_input = 1; repeat(2) @(posedge clk);
        switch_input = 0; repeat(3) @(posedge clk);
        switch_input = 1; repeat(1) @(posedge clk);


        switch_input = 0;
        repeat(100) @(posedge clk);

        #1;


        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Low-going Glitch while High", test_num);
        reset_dut();


        switch_input = 1;
        repeat(100) @(posedge clk);


        switch_input = 0;
        repeat(2) @(posedge clk);
        switch_input = 1;

        repeat(50) @(posedge clk);

        #1;


        check_outputs(1);
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
        input expected_debounced_output;
        begin
            if (expected_debounced_output === (expected_debounced_output ^ debounced_output ^ expected_debounced_output)) begin
                $display("PASS");
                $display("  Outputs: debounced_output=%b",
                         debounced_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: debounced_output=%b",
                         expected_debounced_output);
                $display("  Got:      debounced_output=%b",
                         debounced_output);
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
        $dumpvars(0,clk, switch_input, debounced_output);
    end

endmodule
