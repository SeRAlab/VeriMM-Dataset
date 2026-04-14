`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg DN;
    reg LD;
    reg RST_N;
    reg UP;
    wire MAX;
    wire MIN;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DN(DN),
        .LD(LD),
        .RST_N(RST_N),
        .UP(UP),
        .MAX(MAX),
        .MIN(MIN),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RST_N = 0;
        LD = 0;
        UP = 0;
        DN = 0;
        #12;
        RST_N = 1;
        @(negedge CLK);
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Initial Reset State");
        reset_dut();

        #1;


        check_outputs(1'b0, 1'b1, 4'h0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Increment once");
        reset_dut();
        UP = 1;
        @(negedge CLK);
        UP = 0;
        #1;

        check_outputs(1'b0, 1'b0, 4'h1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Increment to MAX (15)");
        reset_dut();
        UP = 1;
        repeat(15) @(negedge CLK);
        UP = 0;
        #1;

        check_outputs(1'b1, 1'b0, 4'hF);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Wrap around (15 -> 0)");
        reset_dut();
        UP = 1;
        repeat(16) @(negedge CLK);
        UP = 0;
        #1;

        check_outputs(1'b0, 1'b1, 4'h0);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Wrap around (0 -> 15)");
        reset_dut();
        DN = 1;
        @(negedge CLK);
        DN = 0;
        #1;

        check_outputs(1'b1, 1'b0, 4'hF);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Increment 5 times, then Decrement 2 times");
        reset_dut();
        UP = 1;
        repeat(5) @(negedge CLK);
        UP = 0;
        DN = 1;
        repeat(2) @(negedge CLK);
        DN = 0;
        #1;

        check_outputs(1'b0, 1'b0, 4'h3);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Hold value when control is idle");
        reset_dut();
        UP = 1;
        repeat(3) @(negedge CLK);
        UP = 0;
        DN = 0;
        repeat(3) @(negedge CLK);
        #1;

        check_outputs(1'b0, 1'b0, 4'h3);
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
        input expected_MAX;
        input expected_MIN;
        input [3:0] expected_Q;
        begin
            if (expected_MAX === (expected_MAX ^ MAX ^ expected_MAX) &&
                expected_MIN === (expected_MIN ^ MIN ^ expected_MIN) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: MAX=%b, MIN=%b, Q=%h",
                         MAX, MIN, Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MAX=%b, MIN=%b, Q=%h",
                         expected_MAX, expected_MIN, expected_Q);
                $display("  Got:      MAX=%b, MIN=%b, Q=%h",
                         MAX, MIN, Q);
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
        $dumpvars(0,CLK, DN, LD, RST_N, UP, MAX, MIN, Q);
    end

endmodule
