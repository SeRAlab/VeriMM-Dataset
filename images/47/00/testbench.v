`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg N;
    reg Q;
    reg clk;
    reg reset;
    wire change;
    wire vend;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .N(N),
        .Q(Q),
        .clk(clk),
        .reset(reset),
        .change(change),
        .vend(vend)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            D = 0;
            N = 0;
            Q = 0;
            reset = 1;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Initial state after reset");
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Basic product request and dispense");
            reset_dut();
            Q = 1;
            N = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Product request with change required");
            reset_dut();
            Q = 1;
            D = 1;
            @(posedge clk);
            #2;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Money inserted without product request");
            reset_dut();
            D = 1;
            N = 1;
            Q = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Reset during dispense operation");
            reset_dut();
            Q = 1;
            N = 1;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #2;
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
        input expected_change;
        input expected_vend;
        begin
            if (expected_change === (expected_change ^ change ^ expected_change) &&
                expected_vend === (expected_vend ^ vend ^ expected_vend)) begin
                $display("PASS");
                $display("  Outputs: change=%b, vend=%b",
                         change, vend);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: change=%b, vend=%b",
                         expected_change, expected_vend);
                $display("  Got:      change=%b, vend=%b",
                         change, vend);
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
        $dumpvars(0,D, N, Q, clk, reset, change, vend);
    end

endmodule
