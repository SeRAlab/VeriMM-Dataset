`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg rst;
    reg semnal;
    wire neg_detected;
    wire pos_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .rst(rst),
        .semnal(semnal),
        .neg_detected(neg_detected),
        .pos_detected(pos_detected)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            rst = 1;
            semnal = 0;
            @(posedge clock);
            #2 rst = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            semnal <= 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            semnal <= 1;
            @(posedge clock);
            semnal <= 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            semnal <= 1;
            @(posedge clock);
            @(posedge clock);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            semnal <= 0;
            repeat(3) @(posedge clock);
            #1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            semnal <= 1;
            @(posedge clock);
            semnal <= 1;
            @(posedge clock);
            semnal <= 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1, 0);
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
        input expected_neg_detected;
        input expected_pos_detected;
        begin
            if (expected_neg_detected === (expected_neg_detected ^ neg_detected ^ expected_neg_detected) &&
                expected_pos_detected === (expected_pos_detected ^ pos_detected ^ expected_pos_detected)) begin
                $display("PASS");
                $display("  Outputs: neg_detected=%b, pos_detected=%b",
                         neg_detected, pos_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: neg_detected=%b, pos_detected=%b",
                         expected_neg_detected, expected_pos_detected);
                $display("  Got:      neg_detected=%b, pos_detected=%b",
                         neg_detected, pos_detected);
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
        $dumpvars(0,clock, rst, semnal, neg_detected, pos_detected);
    end

endmodule
