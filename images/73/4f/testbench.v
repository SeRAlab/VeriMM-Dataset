`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock_src;
    wire clock_hf;
    wire clock_lf;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock_src(clock_src),
        .clock_hf(clock_hf),
        .clock_lf(clock_lf)
    );

    // Clock generation (10ns period)
    initial begin
        clock_src = 0;
        forever #5 clock_src = ~clock_src;
    end

        task reset_dut;

        begin
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Initial State (Cycle 0)", test_num);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Just before HF toggle (Cycle 16,383)", test_num);

            repeat(16383) @(posedge clock_src);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: HF toggles high (Cycle 16,384)", test_num);

            @(posedge clock_src);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Just before HF toggles low (Cycle 32,767)", test_num);

            repeat(16383) @(posedge clock_src);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: HF toggles low (Cycle 32,768)", test_num);

            @(posedge clock_src);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_clock_hf;
        input expected_clock_lf;
        begin
            if (expected_clock_hf === (expected_clock_hf ^ clock_hf ^ expected_clock_hf) &&
                expected_clock_lf === (expected_clock_lf ^ clock_lf ^ expected_clock_lf)) begin
                $display("PASS");
                $display("  Outputs: clock_hf=%b, clock_lf=%b",
                         clock_hf, clock_lf);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clock_hf=%b, clock_lf=%b",
                         expected_clock_hf, expected_clock_lf);
                $display("  Got:      clock_hf=%b, clock_lf=%b",
                         clock_hf, clock_lf);
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
        $dumpvars(0,clock_src, clock_hf, clock_lf);
    end

endmodule
