`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg botonLimpio;
    reg clock;
    wire impulso;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .botonLimpio(botonLimpio),
        .clock(clock),
        .impulso(impulso)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            botonLimpio = 0;

            repeat (2) @(negedge clock);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            @(negedge clock);
            botonLimpio = 1;
            @(negedge clock);
            #1;
            test_num = test_num + 1;
            $display("Test %0d: Detect 0->1 transition", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(negedge clock);
            botonLimpio = 1;
            @(negedge clock);
            @(negedge clock);
            #1;
            test_num = test_num + 1;
            $display("Test %0d: Ensure pulse is single cycle when button held", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            @(negedge clock);
            botonLimpio = 1;
            @(negedge clock);
            @(negedge clock);
            botonLimpio = 0;
            @(negedge clock);
            #1;
            test_num = test_num + 1;
            $display("Test %0d: No pulse on 1->0 transition", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            botonLimpio = 1;
            repeat (2) @(negedge clock);

            botonLimpio = 0;
            @(negedge clock);

            botonLimpio = 1;
            @(negedge clock);
            #1;
            test_num = test_num + 1;
            $display("Test %0d: Detect second press after release", test_num);
            #1;

            check_outputs(1'b1);
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
        input expected_impulso;
        begin
            if (expected_impulso === (expected_impulso ^ impulso ^ expected_impulso)) begin
                $display("PASS");
                $display("  Outputs: impulso=%b",
                         impulso);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: impulso=%b",
                         expected_impulso);
                $display("  Got:      impulso=%b",
                         impulso);
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
        $dumpvars(0,botonLimpio, clock, impulso);
    end

endmodule
