`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg D;
    reg Enable;
    reg Reset;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clock(Clock),
        .D(D),
        .Enable(Enable),
        .Reset(Reset),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

    begin
        Reset = 1;
        Enable = 0;
        D = 0;
        @(posedge Clock);
        #1;
        Reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Verify counter is 0 after Reset", test_num);
        reset_dut();
        @(posedge Clock);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Enable high, increment 3 times", test_num);
        reset_dut();
        D = 4'd15;
        Enable = 1;
        repeat(3) @(posedge Clock);
        #1;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Verify wrap around when reaching CountTo (D=3)", test_num);
        reset_dut();
        D = 4'd3;
        Enable = 1;
        repeat(4) @(posedge Clock);
        #1;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Verify counter stays constant when Enable is low", test_num);
        reset_dut();
        D = 4'd10;
        Enable = 1;
        repeat(2) @(posedge Clock);
        Enable = 0;
        repeat(3) @(posedge Clock);
        #1;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Verify multiple wraps (D=2, 5 clock cycles)", test_num);
        reset_dut();
        D = 4'd2;
        Enable = 1;

        repeat(5) @(posedge Clock);
        #1;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Verify asynchronous or synchronous reset during operation", test_num);
        reset_dut();
        D = 4'd15;
        Enable = 1;
        repeat(5) @(posedge Clock);
        Reset = 1;
        @(posedge Clock);
        #1;
        #1;

        check_outputs(4'd0);
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
        $dumpvars(0,Clock, D, Enable, Reset, Q);
    end

endmodule
