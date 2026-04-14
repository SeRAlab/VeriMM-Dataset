`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg button;
    reg clock;
    wire button_s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .button(button),
        .clock(clock),
        .button_s(button_s)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        button = 0;

        repeat(50) @(posedge clock);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Steady Low Input", test_num);
        reset_dut();
        button = 0;
        repeat(100) @(posedge clock);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sustained High Input", test_num);
        reset_dut();
        button = 1;

        repeat(200) @(posedge clock);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Short Glitch High", test_num);
        reset_dut();
        button = 1;
        repeat(5) @(posedge clock);
        button = 0;
        repeat(100) @(posedge clock);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sustained High with Short Low Glitch", test_num);
        reset_dut();

        button = 1;
        repeat(200) @(posedge clock);

        button = 0;
        repeat(5) @(posedge clock);
        button = 1;
        repeat(100) @(posedge clock);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sustained Low after High", test_num);
        reset_dut();

        button = 1;
        repeat(200) @(posedge clock);

        button = 0;
        repeat(200) @(posedge clock);
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
        input expected_button_s;
        begin
            if (expected_button_s === (expected_button_s ^ button_s ^ expected_button_s)) begin
                $display("PASS");
                $display("  Outputs: button_s=%b",
                         button_s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: button_s=%b",
                         expected_button_s);
                $display("  Got:      button_s=%b",
                         button_s);
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
        $dumpvars(0,button, clock, button_s);
    end

endmodule
