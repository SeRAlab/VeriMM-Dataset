`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] D;
    reg SI;
    reg clk;
    wire SO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .SI(SI),
        .clk(clk),
        .SO(SO)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            SI = 0;
            D = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            SI = 0;
            D = 4'b1010;
            @(posedge clk);
            #1;
            $display("Test Case 001: Parallel Load 1010");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            SI = 0;
            D = 4'b0111;
            @(posedge clk);
            #1;
            $display("Test Case 002: Parallel Load 0111");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            SI = 1;
            @(posedge clk);
            #1;
            $display("Test Case 003: Shift in 1 (0000 -> 0001)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            SI = 1;
            @(posedge clk);
            #1;
            SI = 1;
            @(posedge clk);
            #1;
            SI = 1;
            @(posedge clk);
            #1;
            $display("Test Case 004: Three consecutive shifts (SI=1)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            SI = 1;
            @(posedge clk);
            #1;
            SI = 0;
            D = 4'b1100;
            @(posedge clk);
            #1;
            $display("Test Case 005: Shift then Parallel Load 1100");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            SI = 0;
            D = 4'b1000;
            @(posedge clk);
            #1;

            SI = 1;
            @(posedge clk);
            #1;



            SI = 0;
            D = 4'b0110;
            @(posedge clk);
            #1;
            $display("Test Case 006: Verify sequence Load->Shift->Load");
            #1;

            check_outputs(1'b0);
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
        input expected_SO;
        begin
            if (expected_SO === (expected_SO ^ SO ^ expected_SO)) begin
                $display("PASS");
                $display("  Outputs: SO=%b",
                         SO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SO=%b",
                         expected_SO);
                $display("  Got:      SO=%b",
                         SO);
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
        $dumpvars(0,D, SI, clk, SO);
    end

endmodule
