`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ID_477;
    reg ID_d9f;
    reg IDa_657;
    reg clk;
    wire ID_45;
    wire IDa_f4c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ID_477(ID_477),
        .ID_d9f(ID_d9f),
        .IDa_657(IDa_657),
        .clk(clk),
        .ID_45(ID_45),
        .IDa_f4c(IDa_f4c)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ID_477 = 0;
            ID_d9f = 0;
            IDa_657 = 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Reset and Initial State Check");
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: ID_d9f Influence");
            reset_dut();
            ID_d9f = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Input Signal Interactions");
            reset_dut();
            ID_477 = 1;
            IDa_657 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Feedback Mechanism Transition");
            reset_dut();
            ID_d9f = 1;
            @(posedge clk);
            #1;
            ID_d9f = 0;
            ID_477 = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Signal Toggling Sequence");
            reset_dut();
            ID_477 = 1; @(posedge clk); #1;
            ID_477 = 0; IDa_657 = 1; @(posedge clk); #1;
            ID_d9f = 1; @(posedge clk); #1;
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
        input expected_ID_45;
        input expected_IDa_f4c;
        begin
            if (expected_ID_45 === (expected_ID_45 ^ ID_45 ^ expected_ID_45) &&
                expected_IDa_f4c === (expected_IDa_f4c ^ IDa_f4c ^ expected_IDa_f4c)) begin
                $display("PASS");
                $display("  Outputs: ID_45=%b, IDa_f4c=%b",
                         ID_45, IDa_f4c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ID_45=%b, IDa_f4c=%b",
                         expected_ID_45, expected_IDa_f4c);
                $display("  Got:      ID_45=%b, IDa_f4c=%b",
                         ID_45, IDa_f4c);
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
        $dumpvars(0,ID_477, ID_d9f, IDa_657, clk, ID_45, IDa_f4c);
    end

endmodule
