`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in_reset;
    reg in_trigger;
    reg [7:0] pulse_duration;
    wire out_pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_reset(in_reset),
        .in_trigger(in_trigger),
        .pulse_duration(pulse_duration),
        .out_pulse(out_pulse)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        in_reset = 1;
        in_trigger = 0;
        pulse_duration = 0;
        @(posedge clk);
        #1;
        in_reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verify output is low after reset", test_num);
        reset_dut();
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Verify pulse goes high after trigger", test_num);
        reset_dut();
        pulse_duration = 8'd10;
        in_trigger = 1;
        @(posedge clk);
        #1;
        in_trigger = 0;

        repeat (5) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Verify pulse goes low after countdown finishes", test_num);
        reset_dut();
        pulse_duration = 8'd5;
        in_trigger = 1;
        @(posedge clk);
        #1;
        in_trigger = 0;

        repeat (7) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Verify reset forces pulse low immediately", test_num);
        reset_dut();
        pulse_duration = 8'd20;
        in_trigger = 1;
        @(posedge clk);
        #1;
        in_trigger = 0;
        repeat (5) @(posedge clk);
        in_reset = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Verify short pulse (duration 1) completion", test_num);
        reset_dut();
        pulse_duration = 8'd1;
        in_trigger = 1;
        @(posedge clk);
        #1;
        in_trigger = 0;
        repeat (2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Verify max duration (255) remains high halfway through", test_num);
        reset_dut();
        pulse_duration = 8'hFF;
        in_trigger = 1;
        @(posedge clk);
        #1;
        in_trigger = 0;
        repeat (128) @(posedge clk);
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
        input expected_out_pulse;
        begin
            if (expected_out_pulse === (expected_out_pulse ^ out_pulse ^ expected_out_pulse)) begin
                $display("PASS");
                $display("  Outputs: out_pulse=%b",
                         out_pulse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_pulse=%b",
                         expected_out_pulse);
                $display("  Got:      out_pulse=%b",
                         out_pulse);
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
        $dumpvars(0,clk, in_reset, in_trigger, pulse_duration, out_pulse);
    end

endmodule
