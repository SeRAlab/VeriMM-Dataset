`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [35:0] cout_Allign;
    reg idle_Allign;
    reg [31:0] sout_Allign;
    reg [35:0] zout_Allign;
    wire idle_AddState;
    wire [31:0] sout_AddState;
    wire [27:0] sum_AddState;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .cout_Allign(cout_Allign),
        .idle_Allign(idle_Allign),
        .sout_Allign(sout_Allign),
        .zout_Allign(zout_Allign),
        .idle_AddState(idle_AddState),
        .sout_AddState(sout_AddState),
        .sum_AddState(sum_AddState)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            idle_Allign = 1;
            cout_Allign = 36'h0;
            zout_Allign = 36'h0;
            sout_Allign = 32'h0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            idle_Allign = 1;
            cout_Allign = 36'h03F84000000;
            zout_Allign = 36'h03F84000000;
            sout_Allign = 32'h3F800000;
            @(posedge clock);
            #2;
            $display("Test case 001: Idle State");
            #1;

            check_outputs(1'b1, 32'h3F800000, 28'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            idle_Allign = 0;

            cout_Allign = 36'h03F84000000;
            zout_Allign = 36'h03F84000000;
            sout_Allign = 32'h3F800000;
            @(posedge clock);
            #2;
            $display("Test case 002: Addition (Same Sign)");

            #1;


            check_outputs(1'b0, 32'h3F800000, 28'h8000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            idle_Allign = 0;
            cout_Allign = 36'h04004000000;
            zout_Allign = 36'h14002000000;
            sout_Allign = 32'h40000000;
            @(posedge clock);
            #2;
            $display("Test case 003: Subtraction (Different Sign)");

            #1;


            check_outputs(1'b0, 32'h40000000, 28'h2000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            idle_Allign = 0;
            cout_Allign = 36'h07F87FFFFFF;
            zout_Allign = 36'h07F87FFFFFF;
            sout_Allign = 32'h7F800000;
            @(posedge clock);
            #2;
            $display("Test case 004: Max Mantissa Addition");

            #1;


            check_outputs(1'b0, 32'h7F800000, 28'hFFFFFFE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            idle_Allign = 0;
            cout_Allign = 36'h03F84000000;
            zout_Allign = 36'h13F84000000;
            sout_Allign = 32'h3F800000;
            @(posedge clock);
            #2;
            $display("Test case 005: Zero Result Subtraction");
            #1;

            check_outputs(1'b0, 32'h3F800000, 28'h0);
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
        input expected_idle_AddState;
        input [31:0] expected_sout_AddState;
        input [27:0] expected_sum_AddState;
        begin
            if (expected_idle_AddState === (expected_idle_AddState ^ idle_AddState ^ expected_idle_AddState) &&
                expected_sout_AddState === (expected_sout_AddState ^ sout_AddState ^ expected_sout_AddState) &&
                expected_sum_AddState === (expected_sum_AddState ^ sum_AddState ^ expected_sum_AddState)) begin
                $display("PASS");
                $display("  Outputs: idle_AddState=%b, sout_AddState=%h, sum_AddState=%h",
                         idle_AddState, sout_AddState, sum_AddState);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: idle_AddState=%b, sout_AddState=%h, sum_AddState=%h",
                         expected_idle_AddState, expected_sout_AddState, expected_sum_AddState);
                $display("  Got:      idle_AddState=%b, sout_AddState=%h, sum_AddState=%h",
                         idle_AddState, sout_AddState, sum_AddState);
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
        $dumpvars(0,clock, cout_Allign, idle_Allign, sout_Allign, zout_Allign, idle_AddState, sout_AddState, sum_AddState);
    end

endmodule
