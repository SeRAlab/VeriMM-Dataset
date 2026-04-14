`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg io_in;
    reg io_rst;
    reg reset;
    wire io_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_in(io_in),
        .io_rst(io_rst),
        .reset(reset),
        .io_out(io_out)
    );

        task reset_dut;

    begin
        reset = 1;
        io_rst = 1;
        io_in = 0;
        @(posedge clock);
        #1;
        reset = 0;
        io_rst = 0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Basic Rising Edge Detection", test_num);
        reset_dut();
        io_in = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Pulse Duration Check", test_num);
        reset_dut();
        io_in = 1;
        @(posedge clock);
        @(posedge clock);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: IO Reset Suppression", test_num);
        reset_dut();
        io_rst = 1;
        io_in = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: System Reset Dominance", test_num);
        reset_dut();
        io_in = 1;
        reset = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Multiple Rising Edges", test_num);
        reset_dut();

        io_in = 1;
        @(posedge clock);
        io_in = 0;
        @(posedge clock);

        io_in = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Falling Edge Check", test_num);
        reset_dut();
        io_in = 1;
        @(posedge clock);
        @(posedge clock);
        io_in = 0;
        @(posedge clock);
        #1;
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
        input expected_io_out;
        begin
            if (expected_io_out === (expected_io_out ^ io_out ^ expected_io_out)) begin
                $display("PASS");
                $display("  Outputs: io_out=%b",
                         io_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_out=%b",
                         expected_io_out);
                $display("  Got:      io_out=%b",
                         io_out);
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
        $dumpvars(0,clock, io_in, io_rst, reset, io_out);
    end

endmodule
