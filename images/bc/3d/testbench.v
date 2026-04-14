`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg B;
    reg clk;
    reg reset;
    wire C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .reset(reset),
        .C(C)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        A = 0;
        B = 0;
        reset = 1;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Reset check...");
        reset_dut();

        #1;


        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Transition S0 -> S1...");
        reset_dut();
        A = 1; B = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Transition S1 -> S2...");
        reset_dut();
        A = 1; B = 0;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Transition S2 -> S3...");
        reset_dut();
        A = 1; B = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: A=1, B=1 Reset Override...");
        reset_dut();
        A = 1; B = 0;
        @(posedge clk);
        @(posedge clk);
        A = 1; B = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Reset signal priority...");
        reset_dut();
        A = 1; B = 0;
        @(posedge clk);
        reset = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0);
        reset = 0;
    end
        endtask

    task testcase007;

    begin
        $display("Running testcase007: Transition S3 -> S0...");
        reset_dut();
        A = 1; B = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
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
        testcase006();
        testcase007();
        
        
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
        input expected_C;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%b",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b",
                         expected_C);
                $display("  Got:      C=%b",
                         C);
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
        $dumpvars(0,A, B, clk, reset, C);
    end

endmodule
