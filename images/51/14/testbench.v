`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg h;
    wire m;
    wire n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .h(h),
        .m(m),
        .n(n)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            h = 0;

            @(posedge clock);
            @(negedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Testing rising edge trigger for m");
            reset_dut();
            h = 1;
            @(posedge clock);
            #1;
            h = 0;
            @(negedge clock);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Testing falling edge trigger for n");
            reset_dut();
            h = 0;
            @(posedge clock);
            #1;
            h = 1;
            @(negedge clock);
            #1;
            h = 0;
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Testing both outputs high");
            reset_dut();
            h = 1;
            @(posedge clock);
            @(negedge clock);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Testing both outputs low");
            reset_dut();
            h = 0;
            @(posedge clock);
            @(negedge clock);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Testing data hold and independence");
            reset_dut();
            h = 1;
            @(posedge clock);
            #1;
            h = 0;
            #2;
            #1;

            check_outputs(1'b1, 1'b0);

            @(negedge clock);
            #1;
            h = 1;
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Rapid toggle check");
            reset_dut();
            h = 1;
            @(posedge clock);
            h = 0;
            @(negedge clock);
            h = 1;
            @(posedge clock);
            h = 0;
            @(negedge clock);
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
        input expected_m;
        input expected_n;
        begin
            if (expected_m === (expected_m ^ m ^ expected_m) &&
                expected_n === (expected_n ^ n ^ expected_n)) begin
                $display("PASS");
                $display("  Outputs: m=%b, n=%b",
                         m, n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m=%b, n=%b",
                         expected_m, expected_n);
                $display("  Got:      m=%b, n=%b",
                         m, n);
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
        $dumpvars(0,clock, h, m, n);
    end

endmodule
