`timescale 1ns/1ps

module value_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg start;
    wire [3:0] value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    value_module dut (
        .clk(clk),
        .start(start),
        .value(value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin


            start = 1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Verifying initial value at T=0");
            reset_dut();
            #1;
            #1;

            check_outputs(4'd10);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Replicating waveform (Edges at 5, 15, 25, 35, 45, 55, 65, 75, 85)");

            #49;
            start = 0;
            #20;
            start = 1;
            #20;

            #1;


            check_outputs(4'd15);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Verifying counter rollover (15 -> 0)");

            #10;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Verifying value hold when start is 0");
            start = 0;
            #20;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Verifying increment recovery (0 -> 1)");
            start = 1;
            #10;
            #1;

            check_outputs(4'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("value_module Testbench");
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
        input [3:0] expected_value;
        begin
            if (expected_value === (expected_value ^ value ^ expected_value)) begin
                $display("PASS");
                $display("  Outputs: value=%h",
                         value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: value=%h",
                         expected_value);
                $display("  Got:      value=%h",
                         value);
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
        $dumpvars(0,clk, start, value);
    end

endmodule
