`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg timer;
    wire [1:0] signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk(clk),
        .timer(timer),
        .signal(signal)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

    begin
        areset = 1;
        timer = 0;
        #12;
        areset = 0;
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Initial Reset State", test_num);
        reset_dut();
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Stay in Walk (timer=0)", test_num);
        reset_dut();
        timer = 0;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Walk to Don't Walk (timer=1)", test_num);
        reset_dut();
        @(posedge clk);
        timer = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Stay in Don't Walk (timer=0)", test_num);
        reset_dut();
        timer = 1;
        @(posedge clk);
        timer = 0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Cycle Walk -> DW -> Walk", test_num);
        reset_dut();
        timer = 1;
        @(posedge clk);
        timer = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Asynchronous Reset Mid-State", test_num);
        reset_dut();
        timer = 1;
        @(posedge clk);
        #2;
        areset = 1;
        #2;
        #1;

        check_outputs(2'b01);
        areset = 0;
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
        input [1:0] expected_signal;
        begin
            if (expected_signal === (expected_signal ^ signal ^ expected_signal)) begin
                $display("PASS");
                $display("  Outputs: signal=%h",
                         signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: signal=%h",
                         expected_signal);
                $display("  Got:      signal=%h",
                         signal);
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
        $dumpvars(0,areset, clk, timer, signal);
    end

endmodule
