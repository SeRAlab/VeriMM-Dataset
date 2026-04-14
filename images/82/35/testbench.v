`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg fscts;
    reg read_clock_enable;
    reg [7:0] read_data;
    reg reset;
    wire fsdi;
    wire ready;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .fscts(fscts),
        .read_clock_enable(read_clock_enable),
        .read_data(read_data),
        .reset(reset),
        .fsdi(fsdi),
        .ready(ready),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            fscts = 1;
            read_clock_enable = 0;
            read_data = 8'h00;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset State");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b1, 2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Start Transition (fscts=0, enable=1)");
            test_num = 2;
            reset_dut();

            @(negedge clock);
            fscts = 0;
            read_clock_enable = 1;
            read_data = 8'hAA;

            @(posedge clock);
            #1;
            #1;

            check_outputs(fsdi, 1'b0, 2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Full State Cycle");
            test_num = 3;
            reset_dut();

            @(negedge clock);
            fscts = 0;
            read_clock_enable = 1;
            read_data = 8'hFF;

            repeat(2) @(posedge clock);
            #1;

            #1;


            check_outputs(fsdi, 1'b0, 2'b10);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Inhibit Transition (read_clock_enable=0)");
            test_num = 4;
            reset_dut();

            @(negedge clock);
            fscts = 0;
            read_clock_enable = 0;

            repeat(3) @(posedge clock);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 2'b00);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Flow Control (fscts=1)");
            test_num = 5;
            reset_dut();

            @(negedge clock);
            fscts = 1;
            read_clock_enable = 1;

            repeat(2) @(posedge clock);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 2'b00);
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
        input expected_fsdi;
        input expected_ready;
        input [1:0] expected_state;
        begin
            if (expected_fsdi === (expected_fsdi ^ fsdi ^ expected_fsdi) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: fsdi=%b, ready=%b, state=%h",
                         fsdi, ready, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fsdi=%b, ready=%b, state=%h",
                         expected_fsdi, expected_ready, expected_state);
                $display("  Got:      fsdi=%b, ready=%b, state=%h",
                         fsdi, ready, state);
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
        $dumpvars(0,clock, fscts, read_clock_enable, read_data, reset, fsdi, ready, state);
    end

endmodule
