`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg signal_in;
    wire falling_edge;
    wire rising_edge;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .signal_in(signal_in),
        .falling_edge(falling_edge),
        .rising_edge(rising_edge)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            signal_in = 0;

            @(posedge clock);
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            signal_in = 1;
            @(posedge clock);
            #1;
            $display("Test %0d: Rising Edge Detection", test_num);
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            signal_in = 1;
            @(posedge clock);
            @(posedge clock);

            signal_in = 0;
            @(posedge clock);
            #1;
            $display("Test %0d: Falling Edge Detection", test_num);
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            signal_in = 0;
            @(posedge clock);
            #1;
            $display("Test %0d: Steady Low (No Edge)", test_num);
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            signal_in = 1;
            @(posedge clock);
            @(posedge clock);
            signal_in = 1;
            @(posedge clock);
            #1;
            $display("Test %0d: Steady High (No Edge)", test_num);
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            signal_in = 1;
            @(posedge clock);

            signal_in = 0;
            @(posedge clock);
            #1;
            $display("Test %0d: Falling Edge immediately after Rising", test_num);

            #1;


            check_outputs(1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            signal_in = 1;
            @(posedge clock);
            @(posedge clock);
            #1;
            $display("Test %0d: Pulse Duration Check (Return to 0)", test_num);
            #1;

            check_outputs(0, 0);
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
        input expected_falling_edge;
        input expected_rising_edge;
        begin
            if (expected_falling_edge === (expected_falling_edge ^ falling_edge ^ expected_falling_edge) &&
                expected_rising_edge === (expected_rising_edge ^ rising_edge ^ expected_rising_edge)) begin
                $display("PASS");
                $display("  Outputs: falling_edge=%b, rising_edge=%b",
                         falling_edge, rising_edge);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: falling_edge=%b, rising_edge=%b",
                         expected_falling_edge, expected_rising_edge);
                $display("  Got:      falling_edge=%b, rising_edge=%b",
                         falling_edge, rising_edge);
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
        $dumpvars(0,clock, signal_in, falling_edge, rising_edge);
    end

endmodule
