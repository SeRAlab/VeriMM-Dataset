`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg reset;
    wire downClock;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .reset(reset),
        .downClock(downClock)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 0;
            #20;
            @(posedge clock);
            #1;
            reset = 1;
            $display("  Reset released at time %0t", $time);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial state after reset", test_num);
            reset_dut();

            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Stability check (mid-count)", test_num);
            reset_dut();

            for (i = 0; i < 1000000; i = i + 1) begin
                @(posedge clock);
            end
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Toggle check after 25M cycles", test_num);
            reset_dut();


            for (i = 0; i < 25000000; i = i + 1) begin
                @(posedge clock);
            end
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Toggle back check after 50M cycles", test_num);
            reset_dut();

            for (i = 0; i < 50000000; i = i + 1) begin
                @(posedge clock);
            end
            #1;

            #1;


            check_outputs(1'b0);
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
        input expected_downClock;
        begin
            if (expected_downClock === (expected_downClock ^ downClock ^ expected_downClock)) begin
                $display("PASS");
                $display("  Outputs: downClock=%b",
                         downClock);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: downClock=%b",
                         expected_downClock);
                $display("  Got:      downClock=%b",
                         downClock);
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
        $dumpvars(0,clock, reset, downClock);
    end

endmodule
