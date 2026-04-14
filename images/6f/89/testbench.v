`timescale 1ns/1ps

module new_different_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg r;
    wire c;
    wire d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    new_different_module dut (
        .clock(clock),
        .r(r),
        .c(c),
        .d(d)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            r = 0;

            @(negedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Initial pulse (T=5 to T=10)");
            reset_dut();
            r = 1; @(posedge clock);
            @(negedge clock); r = 0;
            #1;
            #1;

            check_outputs(1'b1, 1'bx);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Second pulse (T=15 to T=20)");
            reset_dut();

            r = 1; @(posedge clock);
            @(negedge clock); r = 0;

            @(negedge clock); r = 1; @(posedge clock);
            @(negedge clock); r = 0;
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Third pulse with high r at negedge (T=25 to T=30)");
            reset_dut();

            r = 1; @(posedge clock); @(negedge clock); r = 0;
            @(negedge clock); r = 1; @(posedge clock); @(negedge clock); r = 0;

            @(negedge clock); r = 1; @(posedge clock);
            @(negedge clock);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Fourth pulse (T=35 to T=40)");
            reset_dut();

            r = 1; @(posedge clock); @(negedge clock); r = 0;
            @(negedge clock); r = 1; @(posedge clock); @(negedge clock); r = 0;
            @(negedge clock); r = 1; @(posedge clock); @(negedge clock);

            @(posedge clock);
            @(negedge clock); r = 0;
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Fifth pulse (T=45 to T=50)");
            reset_dut();

            r = 1; @(posedge clock); @(negedge clock); r = 0;
            @(negedge clock); r = 1; @(posedge clock); @(negedge clock); r = 0;
            @(negedge clock); r = 1; @(posedge clock); @(negedge clock);
            @(posedge clock); @(negedge clock); r = 0;

            @(negedge clock); r = 1; @(posedge clock);
            @(negedge clock); r = 0;
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Extended sequence (T=55 to T=60)");
            reset_dut();

            r = 1; @(posedge clock); @(negedge clock); r = 0;
            @(negedge clock); r = 1; @(posedge clock); @(negedge clock); r = 0;
            @(negedge clock); r = 1; @(posedge clock); @(negedge clock);
            @(posedge clock); @(negedge clock); r = 0;
            @(negedge clock); r = 1; @(posedge clock); @(negedge clock); r = 0;
            @(negedge clock); r = 1; @(posedge clock);
            @(negedge clock); r = 0;
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
        $display("new_different_module Testbench");
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
        input expected_c;
        input expected_d;
        begin
            if (expected_c === (expected_c ^ c ^ expected_c) &&
                expected_d === (expected_d ^ d ^ expected_d)) begin
                $display("PASS");
                $display("  Outputs: c=%b, d=%b",
                         c, d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%b, d=%b",
                         expected_c, expected_d);
                $display("  Got:      c=%b, d=%b",
                         c, d);
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
        $dumpvars(0,clock, r, c, d);
    end

endmodule
