`timescale 1ns/1ps

module yet_another_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg t;
    wire g;
    wire h;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    yet_another_module dut (
        .clock(clock),
        .t(t),
        .g(g),
        .h(h)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            t = 0;
            force dut.g = 0;
            force dut.h = 0;
            #10;
            release dut.g;
            release dut.h;
            $display("\n--- Resetting DUT ---");
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            @(negedge clock) t = 1;
            @(negedge clock);
            $display("Testcase 001: 1 edge with t=1");
            #1;

            check_outputs(1'b1, 1'bx);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(negedge clock) t = 1;
            repeat(2) @(negedge clock);
            $display("Testcase 002: 2 edges with t=1");
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(negedge clock) t = 1;
            repeat(3) @(negedge clock);
            $display("Testcase 003: 3 edges with t=1");
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(negedge clock) t = 1;
            repeat(4) @(negedge clock);
            $display("Testcase 004: 4 edges with t=1");
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(negedge clock) t = 1;
            repeat(5) @(negedge clock);
            $display("Testcase 005: 5 edges with t=1");
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            @(negedge clock) t = 1;
            repeat(4) @(negedge clock);
            t = 0;
            @(negedge clock);
            $display("Testcase 006: Hold state with t=0");
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            @(negedge clock) t = 1;
            repeat(4) @(negedge clock);
            t = 0;
            @(negedge clock);
            t = 1;
            @(negedge clock);
            $display("Testcase 007: Resume after t=0");
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("yet_another_module Testbench");
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
        input expected_g;
        input expected_h;
        begin
            if (expected_g === (expected_g ^ g ^ expected_g) &&
                expected_h === (expected_h ^ h ^ expected_h)) begin
                $display("PASS");
                $display("  Outputs: g=%b, h=%b",
                         g, h);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: g=%b, h=%b",
                         expected_g, expected_h);
                $display("  Got:      g=%b, h=%b",
                         g, h);
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
        $dumpvars(0,clock, t, g, h);
    end

endmodule
