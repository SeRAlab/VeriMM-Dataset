`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [15:0] data;
    reg in_ready;
    reg reset;
    wire [15:0] avg;
    wire avg_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data(data),
        .in_ready(in_ready),
        .reset(reset),
        .avg(avg),
        .avg_ready(avg_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            in_ready = 0;
            data = 0;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic Positive Average");
            reset_dut();
            in_ready = 1;
            data = 16'sd10; @(posedge clock); #1;
            data = 16'sd20; @(posedge clock); #1;
            data = 16'sd30; @(posedge clock); #1;
            data = 16'sd40; @(posedge clock); #1;
            in_ready = 0;
            #1;

            check_outputs(16'sd25, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Circular Wrap-around");
            reset_dut();
            in_ready = 1;
            data = 16'sd10; @(posedge clock); #1;
            data = 16'sd20; @(posedge clock); #1;
            data = 16'sd30; @(posedge clock); #1;
            data = 16'sd40; @(posedge clock); #1;
            data = 16'sd60; @(posedge clock); #1;
            in_ready = 0;
            #1;

            check_outputs(16'sd37, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Signed Negative Numbers");
            reset_dut();
            in_ready = 1;
            data = -16'sd100; @(posedge clock); #1;
            data = -16'sd200; @(posedge clock); #1;
            data = -16'sd300; @(posedge clock); #1;
            data = -16'sd400; @(posedge clock); #1;
            in_ready = 0;
            #1;

            check_outputs(-16'sd250, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: in_ready Gating");
            reset_dut();
            in_ready = 1;
            data = 16'sd100; @(posedge clock); #1;
            in_ready = 0;
            data = 16'sd500; @(posedge clock); #1;
            data = 16'sd999; @(posedge clock); #1;
            in_ready = 1;
            data = 16'sd100; @(posedge clock); #1;
            data = 16'sd100; @(posedge clock); #1;
            data = 16'sd100; @(posedge clock); #1;
            in_ready = 0;

            #1;


            check_outputs(16'sd100, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Reset Mid-operation");
            reset_dut();
            in_ready = 1;
            data = 16'sd100; @(posedge clock); #1;
            data = 16'sd100; @(posedge clock); #1;
            reset = 1; @(posedge clock); #1;
            reset = 0;
            in_ready = 0;
            #1;

            check_outputs(16'sd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Zero Input");
            reset_dut();
            in_ready = 1;
            data = 0; @(posedge clock); #1;
            data = 0; @(posedge clock); #1;
            data = 0; @(posedge clock); #1;
            data = 0; @(posedge clock); #1;
            in_ready = 0;
            #1;

            check_outputs(16'sd0, 1'b1);
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
        input [15:0] expected_avg;
        input expected_avg_ready;
        begin
            if (expected_avg === (expected_avg ^ avg ^ expected_avg) &&
                expected_avg_ready === (expected_avg_ready ^ avg_ready ^ expected_avg_ready)) begin
                $display("PASS");
                $display("  Outputs: avg=%h, avg_ready=%b",
                         avg, avg_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: avg=%h, avg_ready=%b",
                         expected_avg, expected_avg_ready);
                $display("  Got:      avg=%h, avg_ready=%b",
                         avg, avg_ready);
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
        $dumpvars(0,clock, data, in_ready, reset, avg, avg_ready);
    end

endmodule
