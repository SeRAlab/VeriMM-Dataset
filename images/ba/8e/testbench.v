`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RESET;
    wire slowClk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RESET(RESET),
        .slowClk(slowClk)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RESET = 1;
        repeat(2) @(posedge CLK);
        #2;
        RESET = 0;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Initial state after reset", test_num);
        reset_dut();

        #1;


        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Verify slowClk does not toggle early", test_num);
        reset_dut();

        repeat(1000) @(posedge CLK);
        #1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Verify toggle at 50,000,000 cycles", test_num);
        reset_dut();


        repeat(50000000) @(posedge CLK);
        #1;


        #1;



        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Verify second toggle at 100,000,000 cycles", test_num);
        reset_dut();


        repeat(50000000) @(posedge CLK);


        repeat(50000000) @(posedge CLK);
        #1;


        #1;



        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset during operation", test_num);
        reset_dut();


        repeat(10000) @(posedge CLK);


        reset_dut();


        #1;



        check_outputs(0);
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
        input expected_slowClk;
        begin
            if (expected_slowClk === (expected_slowClk ^ slowClk ^ expected_slowClk)) begin
                $display("PASS");
                $display("  Outputs: slowClk=%b",
                         slowClk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: slowClk=%b",
                         expected_slowClk);
                $display("  Got:      slowClk=%b",
                         slowClk);
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
        $dumpvars(0,CLK, RESET, slowClk);
    end

endmodule
