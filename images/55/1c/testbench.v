`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] counter_out;
    reg [1:0] mux_out;
    reg reset;
    wire [7:0] led_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .counter_out(counter_out),
        .mux_out(mux_out),
        .reset(reset),
        .led_out(led_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            counter_out = 4'b0000;
            mux_out = 2'b00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Initial State");
            reset_dut();

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Rotate to Position 1");
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Rotate to Position 4");
            reset_dut();
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Rotate to Last Position (7)");
            reset_dut();
            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Verify Wrap-around behavior");
            reset_dut();
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Test with different counter/mux inputs");
            reset_dut();
            counter_out = 4'b1111;
            mux_out = 2'b11;
            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(8'h04);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Multiple full rotations");
            reset_dut();
            repeat(17) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h02);
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
        testcase007();
        
        
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
        input [7:0] expected_led_out;
        begin
            if (expected_led_out === (expected_led_out ^ led_out ^ expected_led_out)) begin
                $display("PASS");
                $display("  Outputs: led_out=%h",
                         led_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led_out=%h",
                         expected_led_out);
                $display("  Got:      led_out=%h",
                         led_out);
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
        $dumpvars(0,clk, counter_out, mux_out, reset, led_out);
    end

endmodule
