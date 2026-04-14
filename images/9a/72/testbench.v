`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CHANNEL_UP;
    reg USER_CLK;
    wire rst_r;
    wire run_r;
    wire start_r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CHANNEL_UP(CHANNEL_UP),
        .USER_CLK(USER_CLK),
        .rst_r(rst_r),
        .run_r(run_r),
        .start_r(start_r)
    );

    // Clock generation (10ns period)
    initial begin
        USER_CLK = 0;
        forever #5 USER_CLK = ~USER_CLK;
    end

        task reset_dut;

    begin
        CHANNEL_UP = 0;
        @(posedge USER_CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running testcase%03d: Initial Reset State Check", test_num);
        reset_dut();

        #1;


        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running testcase%03d: Transition to Operational (Steady State)", test_num);
        reset_dut();
        CHANNEL_UP = 1;

        repeat(10) @(posedge USER_CLK);
        #1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running testcase%03d: Channel Loss Recovery", test_num);
        reset_dut();
        CHANNEL_UP = 1;
        repeat(5) @(posedge USER_CLK);

        CHANNEL_UP = 0;
        @(posedge USER_CLK);
        #1;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running testcase%03d: Re-initialization Toggle", test_num);
        reset_dut();
        CHANNEL_UP = 1;
        repeat(2) @(posedge USER_CLK);
        CHANNEL_UP = 0;
        repeat(2) @(posedge USER_CLK);
        CHANNEL_UP = 1;
        repeat(10) @(posedge USER_CLK);
        #1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0);
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
        input expected_rst_r;
        input expected_run_r;
        input expected_start_r;
        begin
            if (expected_rst_r === (expected_rst_r ^ rst_r ^ expected_rst_r) &&
                expected_run_r === (expected_run_r ^ run_r ^ expected_run_r) &&
                expected_start_r === (expected_start_r ^ start_r ^ expected_start_r)) begin
                $display("PASS");
                $display("  Outputs: rst_r=%b, run_r=%b, start_r=%b",
                         rst_r, run_r, start_r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rst_r=%b, run_r=%b, start_r=%b",
                         expected_rst_r, expected_run_r, expected_start_r);
                $display("  Got:      rst_r=%b, run_r=%b, start_r=%b",
                         rst_r, run_r, start_r);
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
        $dumpvars(0,CHANNEL_UP, USER_CLK, rst_r, run_r, start_r);
    end

endmodule
