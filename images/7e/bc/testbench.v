`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iclk;
    wire oclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iclk(iclk),
        .oclk(oclk)
    );

    // Clock generation (10ns period)
    initial begin
        iclk = 0;
        forever #5 iclk = ~iclk;
    end

        task reset_dut;

        begin

            @(negedge iclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running testcase%03d: Check after 2 falling edges...", test_num);
            reset_dut();

            repeat(2) @(negedge iclk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running testcase%03d: Check after 3 falling edges...", test_num);
            reset_dut();

            repeat(3) @(negedge iclk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running testcase%03d: Check after 10 falling edges (Even)...", test_num);
            reset_dut();
            repeat(10) @(negedge iclk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running testcase%03d: Check after 15 falling edges (Odd)...", test_num);
            reset_dut();
            repeat(15) @(negedge iclk);
            #2;
            #1;

            check_outputs(1'b1);
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
        input expected_oclk;
        begin
            if (expected_oclk === (expected_oclk ^ oclk ^ expected_oclk)) begin
                $display("PASS");
                $display("  Outputs: oclk=%b",
                         oclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oclk=%b",
                         expected_oclk);
                $display("  Got:      oclk=%b",
                         oclk);
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
        $dumpvars(0,iclk, oclk);
    end

endmodule
