`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg range;
    reg signal;
    wire new_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .range(range),
        .signal(signal),
        .new_signal(new_signal)
    );

    // Clock generation (10ns period)
    initial begin
        signal = 0;
        forever #5 signal = ~signal;
    end

        task reset_dut;

        begin
            range = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bypass Mode (range=0) - Expect new_signal to track signal High", test_num);
            reset_dut();
            range = 0;
            @(posedge signal);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bypass Mode (range=0) - Expect new_signal to track signal Low", test_num);
            reset_dut();
            range = 0;
            @(negedge signal);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Divided Mode (range=1) - Phase 1 (Initial 5 cycles)", test_num);
            reset_dut();
            range = 1;
            repeat(2) @(posedge signal);
            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Divided Mode (range=1) - Phase 2 (Cycles 6-10)", test_num);
            reset_dut();
            range = 1;
            repeat(7) @(posedge signal);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Divided Mode (range=1) - Phase 3 (Wrap-around after 10 cycles)", test_num);
            reset_dut();
            range = 1;
            repeat(12) @(posedge signal);
            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition from Divided to Bypass Mode", test_num);
            reset_dut();
            range = 1;
            repeat(7) @(posedge signal);
            #1;
            range = 0;
            @(negedge signal);
            #2;

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
        input expected_new_signal;
        begin
            if (expected_new_signal === (expected_new_signal ^ new_signal ^ expected_new_signal)) begin
                $display("PASS");
                $display("  Outputs: new_signal=%b",
                         new_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_signal=%b",
                         expected_new_signal);
                $display("  Got:      new_signal=%b",
                         new_signal);
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
        $dumpvars(0,range, signal, new_signal);
    end

endmodule
