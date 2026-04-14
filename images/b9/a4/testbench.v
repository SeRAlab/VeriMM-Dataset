`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg reset;
    wire done;
    wire [1:0] state_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .reset(reset),
        .done(done),
        .state_out(state_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            #5;
            reset = 0;
            #10;
            reset = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            @(posedge clock);
            #1;
            $display("Testcase %0d: Check IDLE state after reset", test_num);
            #1;

            check_outputs(1'b0, IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            @(posedge clock);
            @(posedge clock);
            #1;
            $display("Testcase %0d: Check transition to COUNT state", test_num);
            #1;

            check_outputs(1'b0, COUNT);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            repeat (20) @(posedge clock);
            #1;
            $display("Testcase %0d: Check transition to DONE state and 'done' flag", test_num);
            #1;

            check_outputs(1'b1, DONE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge clock);
            @(posedge clock);
            #2;
            reset = 0;
            #10;
            reset = 1;
            @(posedge clock);
            #1;
            $display("Testcase %0d: Check reset during operation (Return to IDLE)", test_num);
            #1;

            check_outputs(1'b0, IDLE);
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
        input expected_done;
        input [1:0] expected_state_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_state_out === (expected_state_out ^ state_out ^ expected_state_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, state_out=%h",
                         done, state_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, state_out=%h",
                         expected_done, expected_state_out);
                $display("  Got:      done=%b, state_out=%h",
                         done, state_out);
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
        $dumpvars(0,clock, reset, done, state_out);
    end

endmodule
