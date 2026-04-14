`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg rst;
    reg shift;
    reg start;
    wire [2:0] currentState;
    wire startTimer;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .rst(rst),
        .shift(shift),
        .start(start),
        .currentState(currentState),
        .startTimer(startTimer)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            load = 0;
            shift = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying Reset/Idle State", test_num);
            reset_dut();

            #1;


            check_outputs(3'b000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verifying Start Signal Transition", test_num);
            reset_dut();
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            #1;

            #1;


            check_outputs(3'b001, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verifying Loading Operation", test_num);
            reset_dut();
            @(posedge clk);
            start = 1;
            load = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b010, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verifying Shifting Operation", test_num);
            reset_dut();
            @(posedge clk);
            start = 1;
            shift = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b011, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verifying Async-like Reset during operation", test_num);
            reset_dut();
            @(posedge clk);
            start = 1;
            load = 1;
            @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b000, 1'b0);
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
        input [2:0] expected_currentState;
        input expected_startTimer;
        begin
            if (expected_currentState === (expected_currentState ^ currentState ^ expected_currentState) &&
                expected_startTimer === (expected_startTimer ^ startTimer ^ expected_startTimer)) begin
                $display("PASS");
                $display("  Outputs: currentState=%h, startTimer=%b",
                         currentState, startTimer);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: currentState=%h, startTimer=%b",
                         expected_currentState, expected_startTimer);
                $display("  Got:      currentState=%h, startTimer=%b",
                         currentState, startTimer);
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
        $dumpvars(0,clk, load, rst, shift, start, currentState, startTimer);
    end

endmodule
