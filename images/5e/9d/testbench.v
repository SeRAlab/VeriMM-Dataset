`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg x;
    wire [2:0] state_out;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .x(x),
        .state_out(state_out),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            x = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking reset state...");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(3'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Transition to State 1...");
            test_num = 2;
            reset_dut();
            x = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Testcase 003: Transition to State 5 (y=1)...");
            test_num = 3;
            reset_dut();
            x = 1;
            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(3'd5, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Transition to State 6 (y=1)...");
            test_num = 4;
            reset_dut();
            x = 1;
            for (i = 0; i < 6; i = i + 1) begin
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(3'd6, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Testcase 005: Resetting from State 6...");
            test_num = 5;
            reset_dut();
            x = 1;
            for (i = 0; i < 6; i = i + 1) begin
                @(posedge clk);
                #1;
            end

            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;

            #1;


            check_outputs(3'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Checking behavior with x=0...");
            test_num = 6;
            reset_dut();
            x = 0;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd0, 1'b0);
        end
        endtask

    task testcase007;

        integer i;
        begin
            $display("Testcase 007: Moving past State 6...");
            test_num = 7;
            reset_dut();
            x = 1;
            for (i = 0; i < 7; i = i + 1) begin
                @(posedge clk);
                #1;
            end

            if (state_out == 3'd5 || state_out == 3'd6)
                #1;

                check_outputs(state_out, 1'b1);
            else
                #1;

                check_outputs(state_out, 1'b0);
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
        input [2:0] expected_state_out;
        input expected_y;
        begin
            if (expected_state_out === (expected_state_out ^ state_out ^ expected_state_out) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: state_out=%h, y=%b",
                         state_out, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state_out=%h, y=%b",
                         expected_state_out, expected_y);
                $display("  Got:      state_out=%h, y=%b",
                         state_out, y);
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
        $dumpvars(0,clk, reset, x, state_out, y);
    end

endmodule
