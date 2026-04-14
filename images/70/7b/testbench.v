`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg io_input_enable;
    reg [31:0] io_input_gap;
    reg [31:0] io_input_max;
    reg io_input_reset;
    reg io_input_saturate;
    reg [31:0] io_input_start;
    reg [31:0] io_input_stride;
    reg reset;
    wire [31:0] io_output_countWithoutWrap_0;
    wire [31:0] io_output_count_0;
    wire io_output_done;
    wire io_output_extendedDone;
    wire io_output_saturated;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_input_enable(io_input_enable),
        .io_input_gap(io_input_gap),
        .io_input_max(io_input_max),
        .io_input_reset(io_input_reset),
        .io_input_saturate(io_input_saturate),
        .io_input_start(io_input_start),
        .io_input_stride(io_input_stride),
        .reset(reset),
        .io_output_countWithoutWrap_0(io_output_countWithoutWrap_0),
        .io_output_count_0(io_output_count_0),
        .io_output_done(io_output_done),
        .io_output_extendedDone(io_output_extendedDone),
        .io_output_saturated(io_output_saturated)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            io_input_enable = 0;
            io_input_gap = 0;
            io_input_max = 0;
            io_input_reset = 0;
            io_input_saturate = 0;
            io_input_start = 0;
            io_input_stride = 0;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic incrementing...");
            reset_dut();
            io_input_start = 32'd10;
            io_input_max = 32'd100;
            io_input_stride = 32'd5;
            io_input_gap = 32'd0;
            io_input_enable = 1;
            io_input_saturate = 0;


            repeat(4) @(posedge clock);
            #1;
            #1;

            check_outputs(32'd30, 32'd30, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Reaching Max and Wrapping...");
            reset_dut();
            io_input_start = 32'd0;
            io_input_max = 32'd10;
            io_input_stride = 32'd2;
            io_input_gap = 32'd3;
            io_input_enable = 1;
            io_input_saturate = 0;





            repeat(3) @(posedge clock);
            #1;

            #1;


            check_outputs(32'd15, 32'd0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Saturation at Max...");
            reset_dut();
            io_input_start = 32'd0;
            io_input_max = 32'd10;
            io_input_stride = 32'd5;
            io_input_gap = 32'd0;
            io_input_enable = 1;
            io_input_saturate = 1;





            repeat(3) @(posedge clock);
            #1;
            #1;

            check_outputs(32'd15, 32'd10, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Enable signal control...");
            reset_dut();
            io_input_start = 32'd0;
            io_input_max = 32'd100;
            io_input_stride = 32'd10;
            io_input_gap = 32'd0;
            io_input_enable = 1;

            @(posedge clock);
            #1;
            io_input_enable = 0;
            repeat(5) @(posedge clock);
            #1;
            #1;

            check_outputs(32'd10, 32'd10, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Software Reset...");
            reset_dut();
            io_input_start = 32'd20;
            io_input_max = 32'd100;
            io_input_stride = 32'd5;
            io_input_enable = 1;

            repeat(2) @(posedge clock);
            #1;
            io_input_reset = 1;
            @(posedge clock);
            #1;
            io_input_reset = 0;
            #1;

            check_outputs(32'd20, 32'd20, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Stride and Gap combination...");
            reset_dut();
            io_input_start = 32'd0;
            io_input_max = 32'd100;
            io_input_stride = 32'd1;
            io_input_gap = 32'd9;
            io_input_enable = 1;

            repeat(10) @(posedge clock);
            #1;
            #1;

            check_outputs(32'd100, 32'd100, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Overshooting Max with Saturation...");
            reset_dut();
            io_input_start = 32'd0;
            io_input_max = 32'd10;
            io_input_stride = 32'd100;
            io_input_saturate = 1;
            io_input_enable = 1;

            @(posedge clock);
            #1;

            #1;


            check_outputs(32'd100, 32'd10, 1'b1, 1'b1, 1'b1);
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
        input [31:0] expected_io_output_countWithoutWrap_0;
        input [31:0] expected_io_output_count_0;
        input expected_io_output_done;
        input expected_io_output_extendedDone;
        input expected_io_output_saturated;
        begin
            if (expected_io_output_countWithoutWrap_0 === (expected_io_output_countWithoutWrap_0 ^ io_output_countWithoutWrap_0 ^ expected_io_output_countWithoutWrap_0) &&
                expected_io_output_count_0 === (expected_io_output_count_0 ^ io_output_count_0 ^ expected_io_output_count_0) &&
                expected_io_output_done === (expected_io_output_done ^ io_output_done ^ expected_io_output_done) &&
                expected_io_output_extendedDone === (expected_io_output_extendedDone ^ io_output_extendedDone ^ expected_io_output_extendedDone) &&
                expected_io_output_saturated === (expected_io_output_saturated ^ io_output_saturated ^ expected_io_output_saturated)) begin
                $display("PASS");
                $display("  Outputs: io_output_countWithoutWrap_0=%h, io_output_count_0=%h, io_output_done=%b, io_output_extendedDone=%b, io_output_saturated=%b",
                         io_output_countWithoutWrap_0, io_output_count_0, io_output_done, io_output_extendedDone, io_output_saturated);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_output_countWithoutWrap_0=%h, io_output_count_0=%h, io_output_done=%b, io_output_extendedDone=%b, io_output_saturated=%b",
                         expected_io_output_countWithoutWrap_0, expected_io_output_count_0, expected_io_output_done, expected_io_output_extendedDone, expected_io_output_saturated);
                $display("  Got:      io_output_countWithoutWrap_0=%h, io_output_count_0=%h, io_output_done=%b, io_output_extendedDone=%b, io_output_saturated=%b",
                         io_output_countWithoutWrap_0, io_output_count_0, io_output_done, io_output_extendedDone, io_output_saturated);
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
        $dumpvars(0,clock, io_input_enable, io_input_gap, io_input_max, io_input_reset, io_input_saturate, io_input_start, io_input_stride, reset, io_output_countWithoutWrap_0, io_output_count_0, io_output_done, io_output_extendedDone, io_output_saturated);
    end

endmodule
