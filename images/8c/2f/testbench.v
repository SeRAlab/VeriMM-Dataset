`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data;
    reg reset;
    wire sequence_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .reset(reset),
        .sequence_detected(sequence_detected)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data = 0;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic 1111 detection", test_num);
            reset_dut();
            data = 1; @(negedge clk);
            data = 1; @(negedge clk);
            data = 1; @(negedge clk);
            data = 1; @(negedge clk);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Interrupted sequence 110 followed by 1111", test_num);
            reset_dut();
            data = 1; @(negedge clk);
            data = 1; @(negedge clk);
            data = 0; @(negedge clk);
            data = 1; @(negedge clk);
            data = 1; @(negedge clk);
            data = 1; @(negedge clk);
            data = 1; @(negedge clk);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Incomplete sequence (111)", test_num);
            reset_dut();
            data = 1; @(negedge clk);
            data = 1; @(negedge clk);
            data = 1; @(negedge clk);
            data = 0; @(negedge clk);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Five consecutive 1s", test_num);
            reset_dut();
            data = 1; @(negedge clk);
            data = 1; @(negedge clk);
            data = 1; @(negedge clk);
            data = 1; @(negedge clk);
            data = 1; @(negedge clk);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Async reset mid-sequence", test_num);
            reset_dut();
            data = 1; @(negedge clk);
            data = 1; @(negedge clk);
            reset = 1; #2; reset = 0;
            data = 1; @(negedge clk);
            data = 1; @(negedge clk);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros", test_num);
            reset_dut();
            data = 0; @(negedge clk);
            data = 0; @(negedge clk);
            data = 0; @(negedge clk);
            data = 0; @(negedge clk);
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
        input expected_sequence_detected;
        begin
            if (expected_sequence_detected === (expected_sequence_detected ^ sequence_detected ^ expected_sequence_detected)) begin
                $display("PASS");
                $display("  Outputs: sequence_detected=%b",
                         sequence_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sequence_detected=%b",
                         expected_sequence_detected);
                $display("  Got:      sequence_detected=%b",
                         sequence_detected);
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
        $dumpvars(0,clk, data, reset, sequence_detected);
    end

endmodule
