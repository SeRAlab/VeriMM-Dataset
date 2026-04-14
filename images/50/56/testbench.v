`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg button;
    reg clk;
    reg timer_done;
    wire walk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .button(button),
        .clk(clk),
        .timer_done(timer_done),
        .walk(walk)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

    begin
        areset = 1;
        button = 0;
        timer_done = 0;
        #12;
        areset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        button = 0;
        wait_cycles(2);

        #1;


        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        button = 1;
        wait_cycles(1);

        #1;


        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        button = 1;
        wait_cycles(1);
        button = 0;
        timer_done = 0;
        wait_cycles(2);

        #1;


        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        button = 1;
        wait_cycles(1);
        timer_done = 1;
        wait_cycles(1);

        #1;


        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        button = 1;
        wait_cycles(1);
        #2;
        areset = 1;
        #1;

        #1;


        check_outputs(0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();

        button = 1; wait_cycles(1);

        button = 0; timer_done = 1; wait_cycles(1);

        timer_done = 0; button = 1; wait_cycles(1);

        #1;


        check_outputs(1);
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
        testcase007();
        
        
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
        input expected_walk;
        begin
            if (expected_walk === (expected_walk ^ walk ^ expected_walk)) begin
                $display("PASS");
                $display("  Outputs: walk=%b",
                         walk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: walk=%b",
                         expected_walk);
                $display("  Got:      walk=%b",
                         walk);
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
        $dumpvars(0,areset, button, clk, timer_done, walk);
    end

endmodule
