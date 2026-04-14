`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ar_control_done;
    reg clock;
    reg r_control_done;
    wire ar_control_enable;
    wire r_control_enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ar_control_done(ar_control_done),
        .clock(clock),
        .r_control_done(r_control_done),
        .ar_control_enable(ar_control_enable),
        .r_control_enable(r_control_enable)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            ar_control_done = 0;
            r_control_done = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial State (DO_ADDR)", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Transition DO_ADDR -> DO_DATA", test_num);
            reset_dut();


            ar_control_done = 1;
            @(posedge clock);
            #1;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Full Cycle (DO_ADDR -> DO_DATA -> DO_ADDR)", test_num);
            reset_dut();


            ar_control_done = 1;
            @(posedge clock);
            #1;


            ar_control_done = 0;
            r_control_done = 1;
            @(posedge clock);
            #1;


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Hold DO_ADDR", test_num);
            reset_dut();


            ar_control_done = 0;
            @(posedge clock);
            @(posedge clock);
            #1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Hold DO_DATA", test_num);
            reset_dut();


            ar_control_done = 1;
            @(posedge clock);
            #1;


            ar_control_done = 0;
            r_control_done = 0;
            @(posedge clock);
            @(posedge clock);
            #1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Sequential Completion", test_num);
            reset_dut();


            ar_control_done = 1;
            @(posedge clock);
            #1;


            ar_control_done = 0;
            r_control_done = 1;
            @(posedge clock);
            #1;


            #1;



            check_outputs(1'b1, 1'b0);
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
        input expected_ar_control_enable;
        input expected_r_control_enable;
        begin
            if (expected_ar_control_enable === (expected_ar_control_enable ^ ar_control_enable ^ expected_ar_control_enable) &&
                expected_r_control_enable === (expected_r_control_enable ^ r_control_enable ^ expected_r_control_enable)) begin
                $display("PASS");
                $display("  Outputs: ar_control_enable=%b, r_control_enable=%b",
                         ar_control_enable, r_control_enable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ar_control_enable=%b, r_control_enable=%b",
                         expected_ar_control_enable, expected_r_control_enable);
                $display("  Got:      ar_control_enable=%b, r_control_enable=%b",
                         ar_control_enable, r_control_enable);
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
        $dumpvars(0,ar_control_done, clock, r_control_done, ar_control_enable, r_control_enable);
    end

endmodule
