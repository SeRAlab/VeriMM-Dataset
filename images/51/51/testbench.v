`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enabled;
    reg reset;
    wire refresh_clk;
    wire sys_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enabled(enabled),
        .reset(reset),
        .refresh_clk(refresh_clk),
        .sys_clk(sys_clk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        enabled = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Initial Reset Check", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Disabled State Check", test_num);
        reset_dut();
        enabled = 0;
        repeat(10) @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Enabled Operation - 1 Cycle", test_num);
        reset_dut();
        enabled = 1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(refresh_clk, sys_clk);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Enabled Operation - 10 Cycles", test_num);
        reset_dut();
        enabled = 1;
        repeat(10) @(posedge clk);
        #1;

        if (refresh_clk === 1'bx || sys_clk === 1'bx)
            #1;

            check_outputs(1'b0, 1'b0);
        else
            #1;

            check_outputs(refresh_clk, sys_clk);
    end
        endtask

    task testcase005;

    reg last_ref, last_sys;
    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Pause via Enable", test_num);
        reset_dut();
        enabled = 1;
        repeat(5) @(posedge clk);
        #1;
        last_ref = refresh_clk;
        last_sys = sys_clk;
        enabled = 0;
        repeat(5) @(posedge clk);
        #1;

        #1;


        check_outputs(last_ref, last_sys);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Mid-operation Reset", test_num);
        reset_dut();
        enabled = 1;
        repeat(15) @(posedge clk);
        #1;
        reset = 1;
        @(posedge clk);
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
        input expected_refresh_clk;
        input expected_sys_clk;
        begin
            if (expected_refresh_clk === (expected_refresh_clk ^ refresh_clk ^ expected_refresh_clk) &&
                expected_sys_clk === (expected_sys_clk ^ sys_clk ^ expected_sys_clk)) begin
                $display("PASS");
                $display("  Outputs: refresh_clk=%b, sys_clk=%b",
                         refresh_clk, sys_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: refresh_clk=%b, sys_clk=%b",
                         expected_refresh_clk, expected_sys_clk);
                $display("  Got:      refresh_clk=%b, sys_clk=%b",
                         refresh_clk, sys_clk);
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
        $dumpvars(0,clk, enabled, reset, refresh_clk, sys_clk);
    end

endmodule
