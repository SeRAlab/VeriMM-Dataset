`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in;
    wire match;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .match(match),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin


            in = 4'b1111;
            repeat(3) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Correct Sequence 0-1-0");
            reset_dut();
            in = 4'd0; @(posedge clk); #1;
            in = 4'd1; @(posedge clk); #1;
            in = 4'd0; @(posedge clk); #1;
            #1;

            check_outputs(1'b1, MATCH);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Incorrect First Bit (1)");
            reset_dut();
            in = 4'd1; @(posedge clk); #1;
            #1;

            check_outputs(1'b0, IDLE);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Incorrect Second Bit (0-0)");
            reset_dut();
            in = 4'd0; @(posedge clk); #1;
            in = 4'd0; @(posedge clk); #1;
            #1;

            check_outputs(1'b0, IDLE);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Incorrect Third Bit (0-1-1)");
            reset_dut();
            in = 4'd0; @(posedge clk); #1;
            in = 4'd1; @(posedge clk); #1;
            in = 4'd1; @(posedge clk); #1;
            #1;

            check_outputs(1'b0, IDLE);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Sequence with leading noise (1-1-0-1-0)");
            reset_dut();
            in = 4'd1; @(posedge clk); #1;
            in = 4'd1; @(posedge clk); #1;
            in = 4'd0; @(posedge clk); #1;
            in = 4'd1; @(posedge clk); #1;
            in = 4'd0; @(posedge clk); #1;
            #1;

            check_outputs(1'b1, MATCH);
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
        input expected_match;
        input [1:0] expected_state;
        begin
            if (expected_match === (expected_match ^ match ^ expected_match) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: match=%b, state=%h",
                         match, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: match=%b, state=%h",
                         expected_match, expected_state);
                $display("  Got:      match=%b, state=%h",
                         match, state);
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
        $dumpvars(0,clk, in, match, state);
    end

endmodule
