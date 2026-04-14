`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock_2x;
    reg dequeue_in;
    reg reset;
    wire dequeue_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock_2x(clock_2x),
        .dequeue_in(dequeue_in),
        .reset(reset),
        .dequeue_out(dequeue_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock_2x = 0;
        forever #5 clock_2x = ~clock_2x;
    end

        task reset_dut;

        begin
            reset = 1;
            dequeue_in = 0;
            @(negedge clock_2x);
            reset = 0;


        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dequeue disabled during/immediately after reset", test_num);
            reset_dut();
            dequeue_in = 1;
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dequeue enabled on first clock edge", test_num);
            reset_dut();
            @(posedge clock_2x);
            #1;
            dequeue_in = 1;
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dequeue disabled on second clock edge", test_num);
            reset_dut();
            @(posedge clock_2x);
            @(posedge clock_2x);
            #1;
            dequeue_in = 1;
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dequeue enabled on third clock edge", test_num);
            reset_dut();
            @(posedge clock_2x);
            @(posedge clock_2x);
            @(posedge clock_2x);
            #1;
            dequeue_in = 1;
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Output 0 when cycle is enabled but input is 0", test_num);
            reset_dut();
            @(posedge clock_2x);
            #1;
            dequeue_in = 0;
            #1;
            #1;

            check_outputs(0);
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
        input expected_dequeue_out;
        begin
            if (expected_dequeue_out === (expected_dequeue_out ^ dequeue_out ^ expected_dequeue_out)) begin
                $display("PASS");
                $display("  Outputs: dequeue_out=%b",
                         dequeue_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dequeue_out=%b",
                         expected_dequeue_out);
                $display("  Got:      dequeue_out=%b",
                         dequeue_out);
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
        $dumpvars(0,clock_2x, dequeue_in, reset, dequeue_out);
    end

endmodule
