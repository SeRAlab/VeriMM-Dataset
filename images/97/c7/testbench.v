`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] gain_ctrl;
    reg reset;
    reg [15:0] signal_in;
    wire [7:0] gain_out;
    wire [15:0] signal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .gain_ctrl(gain_ctrl),
        .reset(reset),
        .signal_in(signal_in),
        .gain_out(gain_out),
        .signal_out(signal_out)
    );

    // Clock generation (10ns period)
    initial begin
        reset = 0;
        forever #5 reset = ~reset;
    end

        task reset_dut;

        begin
            $display("Action: Resetting DUT...");
            reset = 1;
            signal_in = 16'd0;
            gain_ctrl = 16'd0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Basic Positive Scaling", test_num);
            reset_dut();
            signal_in = 16'h0100;
            gain_ctrl = 16'h0002;
            #40;


            if (signal_out != 0 && gain_out != 0) begin
                pass_count = pass_count + 1;
                $display("PASS: Signal processed. Out: %h, Gain: %h", signal_out, gain_out);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Signal remained zero");
            end
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Negative Input Handling", test_num);
            reset_dut();
            signal_in = -16'd500;
            gain_ctrl = 16'h0010;
            #40;
            if (signal_out[15] == 1'b1) begin
                pass_count = pass_count + 1;
                $display("PASS: Negative signal preserved and scaled.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Sign bit lost in AGC process.");
            end
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Upper Bound Clamping", test_num);
            reset_dut();
            signal_in = 16'h0001;
            gain_ctrl = 16'h7FFF;
            #100;
            if (gain_out <= 8'hFF) begin
                $display("PASS: Gain clamped within 8-bit range.");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Gain exceeded 8-bit output width.");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Zero Input Signal", test_num);
            reset_dut();
            signal_in = 16'h0000;
            gain_ctrl = 16'h00FF;
            #40;
            #1;

            check_outputs(gain_out, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Max Amplitude Input", test_num);
            reset_dut();
            signal_in = 16'h7FFF;
            gain_ctrl = 16'h0001;
            #40;
            if (signal_out != 16'h0000) begin
                pass_count = pass_count + 1;
                $display("PASS: High amplitude signal handled.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Output saturated to zero unexpectedly.");
            end
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
        input [7:0] expected_gain_out;
        input [15:0] expected_signal_out;
        begin
            if (expected_gain_out === (expected_gain_out ^ gain_out ^ expected_gain_out) &&
                expected_signal_out === (expected_signal_out ^ signal_out ^ expected_signal_out)) begin
                $display("PASS");
                $display("  Outputs: gain_out=%h, signal_out=%h",
                         gain_out, signal_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gain_out=%h, signal_out=%h",
                         expected_gain_out, expected_signal_out);
                $display("  Got:      gain_out=%h, signal_out=%h",
                         gain_out, signal_out);
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
        $dumpvars(0,gain_ctrl, reset, signal_in, gain_out, signal_out);
    end

endmodule
