`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg io_enable;
    reg [39:0] load_val;
    reg reset;
    wire [39:0] count_out;
    wire io_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_enable(io_enable),
        .load_val(load_val),
        .reset(reset),
        .count_out(count_out),
        .io_done(io_done)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 1;
        @(posedge clock);
        #1 reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Basic counting from 0", test_num);
        load_val = 40'd0;
        io_enable = 1;
        reset_dut();
        repeat(10) @(posedge clock);
        #1 #1;
 check_outputs(40'd10, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Enable/Disable control", test_num);
        load_val = 40'd100;
        io_enable = 1;
        reset_dut();
        repeat(5) @(posedge clock);
        io_enable = 0;
        repeat(5) @(posedge clock);
        io_enable = 1;
        repeat(5) @(posedge clock);
        #1 #1;
 check_outputs(40'd110, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Reaching threshold and io_done", test_num);
        load_val = THRESHOLD - 40'd5;
        io_enable = 1;
        reset_dut();
        repeat(5) @(posedge clock);
        #1 #1;
 check_outputs(THRESHOLD, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Loading value exceeding threshold", test_num);

        load_val = THRESHOLD + 40'd1;
        io_enable = 1;
        reset_dut();
        repeat(5) @(posedge clock);
        #1 #1;
 check_outputs(40'd5, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Checking if counter exceeds threshold", test_num);
        load_val = THRESHOLD - 40'd1;
        io_enable = 1;
        reset_dut();
        repeat(10) @(posedge clock);
        #1 #1;
 check_outputs(THRESHOLD, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Reset mid-operation", test_num);
        load_val = 40'd500;
        io_enable = 1;
        reset_dut();
        repeat(10) @(posedge clock);
        load_val = 40'd0;
        reset_dut();
        #1 #1;
 check_outputs(40'd0, 1'b0);
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
        input [39:0] expected_count_out;
        input expected_io_done;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_io_done === (expected_io_done ^ io_done ^ expected_io_done)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h, io_done=%b",
                         count_out, io_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h, io_done=%b",
                         expected_count_out, expected_io_done);
                $display("  Got:      count_out=%h, io_done=%b",
                         count_out, io_done);
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
        $dumpvars(0,clock, io_enable, load_val, reset, count_out, io_done);
    end

endmodule
