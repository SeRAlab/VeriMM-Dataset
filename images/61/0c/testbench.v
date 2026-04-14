`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg sys_clk;
    reg sys_reset;
    wire clk_out;
    wire reset_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sys_clk(sys_clk),
        .sys_reset(sys_reset),
        .clk_out(clk_out),
        .reset_out(reset_out)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

        task reset_dut;

        begin
            sys_reset = 1;
            @(posedge sys_clk);
            #1;
            sys_reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial state after reset (Counter=0)", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: State after 1 cycle (Counter=1)", test_num);
            reset_dut();
            @(posedge sys_clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: State after 8 cycles (Counter=8)", test_num);
            reset_dut();
            repeat(8) @(posedge sys_clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Terminal state (Counter=9)", test_num);
            reset_dut();
            repeat(9) @(posedge sys_clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Wrap-around state (Counter=0 again)", test_num);
            reset_dut();
            repeat(10) @(posedge sys_clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Reset mid-count (At counter=5)", test_num);
            reset_dut();
            repeat(5) @(posedge sys_clk);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b1);
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
        input expected_clk_out;
        input expected_reset_out;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out) &&
                expected_reset_out === (expected_reset_out ^ reset_out ^ expected_reset_out)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b, reset_out=%b",
                         clk_out, reset_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b, reset_out=%b",
                         expected_clk_out, expected_reset_out);
                $display("  Got:      clk_out=%b, reset_out=%b",
                         clk_out, reset_out);
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
        $dumpvars(0,sys_clk, sys_reset, clk_out, reset_out);
    end

endmodule
