`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg IncrementData;
    reg LoadData;
    reg Reset;
    wire AddOne;
    wire WriteOrRead;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clock(Clock),
        .IncrementData(IncrementData),
        .LoadData(LoadData),
        .Reset(Reset),
        .AddOne(AddOne),
        .WriteOrRead(WriteOrRead)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            Reset = 1;
            IncrementData = 0;
            LoadData = 0;
            @(posedge Clock);
            #1;
            Reset = 0;

            @(posedge Clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Initial State check...");
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Transition to Load state...");
            reset_dut();
            LoadData = 1;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Transition to Increment state...");
            reset_dut();
            IncrementData = 1;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Transition to Read state...");
            reset_dut();


            LoadData = 1;
            @(posedge Clock);
            #1;
            LoadData = 0;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset override from Increment...");
            reset_dut();
            IncrementData = 1;
            @(posedge Clock);
            #1;
            Reset = 1;
            @(posedge Clock);
            #1;
            Reset = 0;
            @(posedge Clock);
            #1;
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
        input expected_AddOne;
        input expected_WriteOrRead;
        begin
            if (expected_AddOne === (expected_AddOne ^ AddOne ^ expected_AddOne) &&
                expected_WriteOrRead === (expected_WriteOrRead ^ WriteOrRead ^ expected_WriteOrRead)) begin
                $display("PASS");
                $display("  Outputs: AddOne=%b, WriteOrRead=%b",
                         AddOne, WriteOrRead);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AddOne=%b, WriteOrRead=%b",
                         expected_AddOne, expected_WriteOrRead);
                $display("  Got:      AddOne=%b, WriteOrRead=%b",
                         AddOne, WriteOrRead);
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
        $dumpvars(0,Clock, IncrementData, LoadData, Reset, AddOne, WriteOrRead);
    end

endmodule
