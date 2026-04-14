`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] data_in;
    reg reset;
    reg shift_clk;
    wire [3:0] q0;
    wire [3:0] q1;
    wire [3:0] q2;
    wire [3:0] q3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .reset(reset),
        .shift_clk(shift_clk),
        .q0(q0),
        .q1(q1),
        .q2(q2),
        .q3(q3)
    );

    // Clock generation (10ns period)
    initial begin
        shift_clk = 0;
        forever #5 shift_clk = ~shift_clk;
    end

        task reset_dut;

        begin
            @(negedge shift_clk);
            reset = 1;
            data_in = 4'b0;
            @(negedge shift_clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Synchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Full 4-stage Shift Check", test_num);
            reset_dut();

            @(negedge shift_clk);
            data_in = 4'hA;
            @(negedge shift_clk);
            data_in = 4'hB;
            @(negedge shift_clk);
            data_in = 4'hC;
            @(negedge shift_clk);
            data_in = 4'hD;

            @(posedge shift_clk);
            #1;
            #1;

            check_outputs(4'hD, 4'hC, 4'hB, 4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Partial Shift Check", test_num);
            reset_dut();

            @(negedge shift_clk);
            data_in = 4'h1;
            @(negedge shift_clk);
            data_in = 4'h2;

            @(posedge shift_clk);
            #1;
            #1;

            check_outputs(4'h2, 4'h1, 4'h0, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Overflow Shift Check (5 cycles)", test_num);
            reset_dut();

            @(negedge shift_clk);
            data_in = 4'hF;
            @(negedge shift_clk);
            data_in = 4'hE;
            @(negedge shift_clk);
            data_in = 4'hD;
            @(negedge shift_clk);
            data_in = 4'hC;
            @(negedge shift_clk);
            data_in = 4'hB;

            @(posedge shift_clk);
            #1;
            #1;

            check_outputs(4'hB, 4'hC, 4'hD, 4'hE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Mid-operation Reset Check", test_num);
            reset_dut();

            @(negedge shift_clk);
            data_in = 4'h5;
            @(negedge shift_clk);
            data_in = 4'h6;


            @(negedge shift_clk);
            reset = 1;

            @(posedge shift_clk);
            #1;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'h0);

            @(negedge shift_clk);
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
        input [3:0] expected_q0;
        input [3:0] expected_q1;
        input [3:0] expected_q2;
        input [3:0] expected_q3;
        begin
            if (expected_q0 === (expected_q0 ^ q0 ^ expected_q0) &&
                expected_q1 === (expected_q1 ^ q1 ^ expected_q1) &&
                expected_q2 === (expected_q2 ^ q2 ^ expected_q2) &&
                expected_q3 === (expected_q3 ^ q3 ^ expected_q3)) begin
                $display("PASS");
                $display("  Outputs: q0=%h, q1=%h, q2=%h, q3=%h",
                         q0, q1, q2, q3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q0=%h, q1=%h, q2=%h, q3=%h",
                         expected_q0, expected_q1, expected_q2, expected_q3);
                $display("  Got:      q0=%h, q1=%h, q2=%h, q3=%h",
                         q0, q1, q2, q3);
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
        $dumpvars(0,data_in, reset, shift_clk, q0, q1, q2, q3);
    end

endmodule
