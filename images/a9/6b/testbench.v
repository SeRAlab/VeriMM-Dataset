`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg io_enable;
    reg [10:0] io_max;
    reg io_reset;
    reg io_saturate;
    reg [10:0] io_stride;
    reg reset;
    wire io_done;
    wire [10:0] io_next;
    wire [10:0] io_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_enable(io_enable),
        .io_max(io_max),
        .io_reset(io_reset),
        .io_saturate(io_saturate),
        .io_stride(io_stride),
        .reset(reset),
        .io_done(io_done),
        .io_next(io_next),
        .io_out(io_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            io_reset = 0;
            io_enable = 0;
            io_max = 0;
            io_stride = 0;
            io_saturate = 0;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            io_max = 11'd10;
            io_stride = 11'd1;
            io_enable = 1'b1;
            io_saturate = 1'b0;


            repeat(10) @(posedge clock);
            #1;



            test_num = test_num + 1;
            $display("Testcase %0d: Basic counting to Max", test_num);
            #1;

            check_outputs(1'b1, 11'd11, 11'd10);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            io_max = 11'd10;
            io_stride = 11'd3;
            io_enable = 1'b1;
            io_saturate = 1'b1;






            repeat(5) @(posedge clock);
            #1;

            test_num = test_num + 1;
            $display("Testcase %0d: Stride with Saturation", test_num);
            #1;

            check_outputs(1'b1, 11'd10, 11'd10);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            io_max = 11'd10;
            io_stride = 11'd1;
            io_enable = 1'b0;

            repeat(5) @(posedge clock);
            #1;

            test_num = test_num + 1;
            $display("Testcase %0d: Enable signal low", test_num);

            #1;


            check_outputs(1'b0, 11'd0, 11'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            io_max = 11'd10;
            io_stride = 11'd1;
            io_enable = 1'b1;

            repeat(5) @(posedge clock);
            @(negedge clock);
            io_reset = 1'b1;
            @(posedge clock);
            #1;

            test_num = test_num + 1;
            $display("Testcase %0d: io_reset signal", test_num);
            #1;

            check_outputs(1'b0, 11'd0, 11'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            io_max = 11'd5;
            io_stride = 11'd2;
            io_enable = 1'b1;
            io_saturate = 1'b0;




            repeat(3) @(posedge clock);
            #1;

            test_num = test_num + 1;
            $display("Testcase %0d: Overflow without saturation", test_num);

            #1;


            check_outputs(1'b0, 11'd6, 11'd4);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            io_max = 11'd6;
            io_stride = 11'd2;
            io_enable = 1'b1;
            io_saturate = 1'b0;


            repeat(3) @(posedge clock);
            #1;

            test_num = test_num + 1;
            $display("Testcase %0d: Reaching Max exactly with stride 2", test_num);
            #1;

            check_outputs(1'b1, 11'd8, 11'd6);
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
        input expected_io_done;
        input [10:0] expected_io_next;
        input [10:0] expected_io_out;
        begin
            if (expected_io_done === (expected_io_done ^ io_done ^ expected_io_done) &&
                expected_io_next === (expected_io_next ^ io_next ^ expected_io_next) &&
                expected_io_out === (expected_io_out ^ io_out ^ expected_io_out)) begin
                $display("PASS");
                $display("  Outputs: io_done=%b, io_next=%h, io_out=%h",
                         io_done, io_next, io_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_done=%b, io_next=%h, io_out=%h",
                         expected_io_done, expected_io_next, expected_io_out);
                $display("  Got:      io_done=%b, io_next=%h, io_out=%h",
                         io_done, io_next, io_out);
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
        $dumpvars(0,clock, io_enable, io_max, io_reset, io_saturate, io_stride, reset, io_done, io_next, io_out);
    end

endmodule
