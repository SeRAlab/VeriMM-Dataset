`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg io_interrupt;
    reg io_plic_complete;
    reg io_plic_ready;
    reg reset;
    wire io_plic_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_interrupt(io_interrupt),
        .io_plic_complete(io_plic_complete),
        .io_plic_ready(io_plic_ready),
        .reset(reset),
        .io_plic_valid(io_plic_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            io_interrupt = 0;
            io_plic_ready = 0;
            io_plic_complete = 0;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial state", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Interrupt assertion", test_num);
            reset_dut();
            io_interrupt = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Handshake/Busy logic", test_num);
            reset_dut();
            io_interrupt = 1;
            @(posedge clock);
            #1 io_plic_ready = 1;
            @(posedge clock);
            #1 io_plic_ready = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Block before completion", test_num);
            reset_dut();
            io_interrupt = 1;
            @(posedge clock);
            #1 io_plic_ready = 1;
            @(posedge clock);
            #1 io_plic_ready = 0;

            repeat(2) @(posedge clock);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Completion re-triggers", test_num);
            reset_dut();
            io_interrupt = 1;
            @(posedge clock);
            #1 io_plic_ready = 1;
            @(posedge clock);
            #1 io_plic_ready = 0;
            @(posedge clock);
            #1 io_plic_complete = 1;
            @(posedge clock);
            #1 io_plic_complete = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Completion with no pending interrupt", test_num);
            reset_dut();
            io_interrupt = 1;
            @(posedge clock);
            #1 io_plic_ready = 1;
            @(posedge clock);
            #1 io_plic_ready = 0;
            io_interrupt = 0;
            @(posedge clock);
            #1 io_plic_complete = 1;
            @(posedge clock);
            #1 io_plic_complete = 0;
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
        input expected_io_plic_valid;
        begin
            if (expected_io_plic_valid === (expected_io_plic_valid ^ io_plic_valid ^ expected_io_plic_valid)) begin
                $display("PASS");
                $display("  Outputs: io_plic_valid=%b",
                         io_plic_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_plic_valid=%b",
                         expected_io_plic_valid);
                $display("  Got:      io_plic_valid=%b",
                         io_plic_valid);
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
        $dumpvars(0,clock, io_interrupt, io_plic_complete, io_plic_ready, reset, io_plic_valid);
    end

endmodule
