`timescale 1ns/1ps

module new_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg d;
    wire e;
    wire f;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    new_module dut (
        .clock(clock),
        .d(d),
        .e(e),
        .f(f)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            d = 0;

            @(posedge clock);
            @(negedge clock);
            test_num = test_num + 1;
            $display("Test Case %0d:", test_num);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            d = 1;
            @(posedge clock);
            @(negedge clock);
            #2;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            d = 1;
            @(posedge clock);
            @(negedge clock);

            d = 0;
            @(posedge clock);
            @(negedge clock);
            #2;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            d = 1;
            @(posedge clock);
            d = 0;
            @(negedge clock);
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            d = 0;
            @(posedge clock);
            d = 1;
            @(negedge clock);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            d = 1;
            @(posedge clock);
            @(negedge clock);
            d = 0;
            #2;
            #1;

            check_outputs(1, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("new_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_e;
        input expected_f;
        begin
            if (expected_e === (expected_e ^ e ^ expected_e) &&
                expected_f === (expected_f ^ f ^ expected_f)) begin
                $display("PASS");
                $display("  Outputs: e=%b, f=%b",
                         e, f);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: e=%b, f=%b",
                         expected_e, expected_f);
                $display("  Got:      e=%b, f=%b",
                         e, f);
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
        $dumpvars(0,clock, d, e, f);
    end

endmodule
