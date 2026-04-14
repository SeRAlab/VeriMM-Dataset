`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg In;
    reg Reset;
    wire [3:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clock(Clock),
        .In(In),
        .Reset(Reset),
        .Out(Out)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            Reset = 0;
            In = 0;
            repeat (2) @(negedge Clock);
            Reset = 1;
            repeat (1) @(negedge Clock);
        end
        endtask
    task pulse_in;

        begin
            @(negedge Clock);
            In = 1;
            @(negedge Clock);
            In = 0;
            @(negedge Clock);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Pulse", test_num);
            reset_dut();
            pulse_in();
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Pulses (5 pulses)", test_num);
            reset_dut();
            repeat (5) pulse_in();
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Level Sensitivity / Edge Detection", test_num);
            reset_dut();
            @(negedge Clock);
            In = 1;
            repeat (5) @(negedge Clock);
            In = 0;
            @(negedge Clock);
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Counter Wrap-around (16 pulses)", test_num);
            reset_dut();
            repeat (16) pulse_in();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Mid-operation", test_num);
            reset_dut();
            repeat (3) pulse_in();
            Reset = 0;
            repeat (2) @(negedge Clock);
            Reset = 1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pulse immediately after reset", test_num);
            Reset = 0;
            In = 0;
            @(negedge Clock);
            Reset = 1;
            In = 1;
            @(negedge Clock);
            In = 0;
            repeat (2) @(negedge Clock);
            #1;

            check_outputs(4'h1);
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
        input [3:0] expected_Out;
        begin
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%h",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%h",
                         expected_Out);
                $display("  Got:      Out=%h",
                         Out);
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
        $dumpvars(0,Clock, In, Reset, Out);
    end

endmodule
