`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg enable;
    reg load;
    reg reset;
    wire [6:0] count;
    wire tc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .enable(enable),
        .load(load),
        .reset(reset),
        .count(count),
        .tc(tc)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(posedge clock);
            reset = 1;
            enable = 0;
            load = 0;
            @(posedge clock);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();
            @(posedge clock);
            #1;
            #1;

            check_outputs(7'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Increment", test_num);
            reset_dut();
            @(posedge clock);
            enable = 1;
            repeat(10) @(posedge clock);
            enable = 0;
            #1;
            #1;

            check_outputs(7'd10, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable/Hold Check", test_num);
            reset_dut();
            @(posedge clock);
            enable = 1;
            repeat(5) @(posedge clock);
            enable = 0;
            repeat(5) @(posedge clock);
            #1;
            #1;

            check_outputs(7'd5, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Terminal Count Check", test_num);
            reset_dut();
            @(posedge clock);
            enable = 1;
            repeat(127) @(posedge clock);
            #1;

            #1;


            check_outputs(7'd127, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rollover Check", test_num);
            reset_dut();
            @(posedge clock);
            enable = 1;
            repeat(128) @(posedge clock);
            #1;
            #1;

            check_outputs(7'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Signal Check", test_num);
            reset_dut();
            @(posedge clock);
            enable = 1;
            repeat(20) @(posedge clock);
            load = 1;
            @(posedge clock);
            load = 0;
            #1;
            #1;

            check_outputs(7'd0, 1'b0);
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
        input [6:0] expected_count;
        input expected_tc;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_tc === (expected_tc ^ tc ^ expected_tc)) begin
                $display("PASS");
                $display("  Outputs: count=%h, tc=%b",
                         count, tc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, tc=%b",
                         expected_count, expected_tc);
                $display("  Got:      count=%h, tc=%b",
                         count, tc);
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
        $dumpvars(0,clock, enable, load, reset, count, tc);
    end

endmodule
