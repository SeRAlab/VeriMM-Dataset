`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg globalreset;
    reg trigger;
    wire output_xhdl0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .globalreset(globalreset),
        .trigger(trigger),
        .output_xhdl0(output_xhdl0)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            globalreset = 1;
            trigger = 0;
            enable = 0;
            repeat(2) @(posedge clk);
            globalreset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Normal Triggered Pulse", test_num);
            reset_dut();
            enable = 1;
            trigger = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Pulse Gating (Enable=0)", test_num);
            reset_dut();
            enable = 0;
            trigger = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Pulse Duration Check (One-Shot)", test_num);
            reset_dut();
            enable = 1;
            trigger = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Global Reset Check", test_num);
            reset_dut();
            enable = 1;
            trigger = 1;
            @(posedge clk);
            globalreset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Multi-Trigger Cycle", test_num);
            reset_dut();
            enable = 1;

            trigger = 1;
            repeat(3) @(posedge clk);
            trigger = 0;
            @(posedge clk);

            trigger = 1;
            @(posedge clk);
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
        input expected_output_xhdl0;
        begin
            if (expected_output_xhdl0 === (expected_output_xhdl0 ^ output_xhdl0 ^ expected_output_xhdl0)) begin
                $display("PASS");
                $display("  Outputs: output_xhdl0=%b",
                         output_xhdl0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_xhdl0=%b",
                         expected_output_xhdl0);
                $display("  Got:      output_xhdl0=%b",
                         output_xhdl0);
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
        $dumpvars(0,clk, enable, globalreset, trigger, output_xhdl0);
    end

endmodule
