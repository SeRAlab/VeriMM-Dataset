`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock_in;
    reg halt;
    reg reset;
    wire clock_out;
    wire [5:0] counter;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock_in(clock_in),
        .halt(halt),
        .reset(reset),
        .clock_out(clock_out),
        .counter(counter)
    );

    // Clock generation (10ns period)
    initial begin
        clock_in = 0;
        forever #5 clock_in = ~clock_in;
    end

        task reset_dut;

        begin
            reset = 1;
            halt = 0;
            @(posedge clock_in);
            #2 reset = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1 #1;
 check_outputs(1'b1, 6'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clock_in);
            #2;

            #1;


            check_outputs(1'b0, 6'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge clock_in);
            @(posedge clock_in);
            #2;

            #1;


            check_outputs(1'b1, 6'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge clock_in);
            @(posedge clock_in);
            @(posedge clock_in);
            @(posedge clock_in);
            #2;
            #1;

            check_outputs(1'b1, 6'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge clock_in);
            @(posedge clock_in);
            halt = 1;
            @(posedge clock_in);
            @(posedge clock_in);
            #2;
            #1;

            check_outputs(1'b1, 6'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(posedge clock_in);
            @(posedge clock_in);
            @(posedge clock_in);
            reset = 1;
            @(posedge clock_in);
            #2;
            #1;

            check_outputs(1'b1, 6'd0);
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
        input expected_clock_out;
        input [5:0] expected_counter;
        begin
            if (expected_clock_out === (expected_clock_out ^ clock_out ^ expected_clock_out) &&
                expected_counter === (expected_counter ^ counter ^ expected_counter)) begin
                $display("PASS");
                $display("  Outputs: clock_out=%b, counter=%h",
                         clock_out, counter);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clock_out=%b, counter=%h",
                         expected_clock_out, expected_counter);
                $display("  Got:      clock_out=%b, counter=%h",
                         clock_out, counter);
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
        $dumpvars(0,clock_in, halt, reset, clock_out, counter);
    end

endmodule
