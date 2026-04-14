`timescale 1ns/1ps

module yet_another_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg p;
    wire r;
    wire s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    yet_another_module dut (
        .clock(clock),
        .p(p),
        .r(r),
        .s(s)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            p = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial p=1 transition...");
            @(posedge clock);
            #1 p = 1;
            @(negedge clock);
            #1;

            check_outputs(1'b1, 1'bx);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Second p=1 transition...");
            @(posedge clock);
            #1 p = 1;
            @(negedge clock);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Transition to s=1, r=0 (p=0)...");
            @(posedge clock);
            #1 p = 0;
            @(negedge clock);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Toggle to r=1, s=0...");
            @(posedge clock);
            #1 p = 1;
            @(negedge clock);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Toggle back to r=0, s=1...");
            @(posedge clock);
            #1 p = 1;
            @(negedge clock);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Final toggle to r=1, s=0...");
            @(posedge clock);
            #1 p = 1;
            @(negedge clock);
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
        $display("yet_another_module Testbench");
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
        input expected_r;
        input expected_s;
        begin
            if (expected_r === (expected_r ^ r ^ expected_r) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: r=%b, s=%b",
                         r, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r=%b, s=%b",
                         expected_r, expected_s);
                $display("  Got:      r=%b, s=%b",
                         r, s);
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
        $dumpvars(0,clock, p, r, s);
    end

endmodule
