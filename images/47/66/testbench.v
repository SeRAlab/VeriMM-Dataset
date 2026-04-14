`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aw_control_done;
    reg b_control_done;
    reg clock;
    reg w_control_done;
    wire aw_control_enable;
    wire b_control_enable;
    wire w_control_enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aw_control_done(aw_control_done),
        .b_control_done(b_control_done),
        .clock(clock),
        .w_control_done(w_control_done),
        .aw_control_enable(aw_control_enable),
        .b_control_enable(b_control_enable),
        .w_control_enable(w_control_enable)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            aw_control_done = 0;
            w_control_done = 0;
            b_control_done = 0;

            repeat (2) @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Checking Initial State (DO_ADDR)", test_num);
            reset_dut();

            #1;


            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Transition DO_ADDR -> DO_DATA", test_num);
            reset_dut();


            aw_control_done = 1;
            @(posedge clock);
            #1;
            aw_control_done = 0;


            #1;



            check_outputs(0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Transition DO_DATA -> DO_RESP", test_num);
            reset_dut();


            aw_control_done = 1;
            @(posedge clock);
            #1;
            aw_control_done = 0;


            w_control_done = 1;
            @(posedge clock);
            #1;
            w_control_done = 0;


            #1;



            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Full Cycle (RESP -> ADDR)", test_num);
            reset_dut();


            aw_control_done = 1;
            @(posedge clock);
            #1;
            aw_control_done = 0;


            w_control_done = 1;
            @(posedge clock);
            #1;
            w_control_done = 0;


            b_control_done = 1;
            @(posedge clock);
            #1;
            b_control_done = 0;


            #1;



            check_outputs(1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Holding state (Stall Logic)", test_num);
            reset_dut();


            aw_control_done = 1;
            @(posedge clock);
            #1;
            aw_control_done = 0;


            repeat (3) @(posedge clock);
            #1;


            #1;



            check_outputs(0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Back-to-back pulses", test_num);
            reset_dut();

            aw_control_done = 1;
            @(posedge clock);
            #1;
            aw_control_done = 0;
            w_control_done = 1;
            @(posedge clock);
            #1;
            w_control_done = 0;
            b_control_done = 1;
            @(posedge clock);
            #1;
            b_control_done = 0;


            #1;



            check_outputs(1, 0, 0);
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
        input expected_aw_control_enable;
        input expected_b_control_enable;
        input expected_w_control_enable;
        begin
            if (expected_aw_control_enable === (expected_aw_control_enable ^ aw_control_enable ^ expected_aw_control_enable) &&
                expected_b_control_enable === (expected_b_control_enable ^ b_control_enable ^ expected_b_control_enable) &&
                expected_w_control_enable === (expected_w_control_enable ^ w_control_enable ^ expected_w_control_enable)) begin
                $display("PASS");
                $display("  Outputs: aw_control_enable=%b, b_control_enable=%b, w_control_enable=%b",
                         aw_control_enable, b_control_enable, w_control_enable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aw_control_enable=%b, b_control_enable=%b, w_control_enable=%b",
                         expected_aw_control_enable, expected_b_control_enable, expected_w_control_enable);
                $display("  Got:      aw_control_enable=%b, b_control_enable=%b, w_control_enable=%b",
                         aw_control_enable, b_control_enable, w_control_enable);
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
        $dumpvars(0,aw_control_done, b_control_done, clock, w_control_done, aw_control_enable, b_control_enable, w_control_enable);
    end

endmodule
