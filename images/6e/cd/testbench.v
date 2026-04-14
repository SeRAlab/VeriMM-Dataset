`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg reset;
    wire [3:0] counter_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .reset(reset),
        .counter_output(counter_output)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            #15;
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Verification", test_num);
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Count to 5", test_num);
            reset_dut();
            repeat(5) @(posedge clock);
            #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Count to Max (15)", test_num);
            reset_dut();
            repeat(15) @(posedge clock);
            #1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Wrap Around (16 cycles)", test_num);
            reset_dut();
            repeat(16) @(posedge clock);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Wrap Arounds (35 cycles)", test_num);
            reset_dut();
            repeat(35) @(posedge clock);
            #1;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-operation Asynchronous Reset", test_num);
            reset_dut();
            repeat(10) @(posedge clock);
            #3;
            reset = 1;
            #2;
            #1;

            check_outputs(4'h0);
            reset = 0;
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
        input [3:0] expected_counter_output;
        begin
            if (expected_counter_output === (expected_counter_output ^ counter_output ^ expected_counter_output)) begin
                $display("PASS");
                $display("  Outputs: counter_output=%h",
                         counter_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_output=%h",
                         expected_counter_output);
                $display("  Got:      counter_output=%h",
                         counter_output);
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
        $dumpvars(0,clock, reset, counter_output);
    end

endmodule
