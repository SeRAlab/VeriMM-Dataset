`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg reset;
    wire [15:0] array_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .reset(reset),
        .array_out(array_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(negedge clock);
            reset = 0;
            @(negedge clock);
            reset = 1;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment to second entry", test_num);
            reset_dut();
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'h0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Accessing index 5", test_num);
            reset_dut();
            repeat(5) @(posedge clock);
            #1;
            #1;

            check_outputs(16'h0005);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Wrap-around after 16 cycles", test_num);
            reset_dut();
            repeat(16) @(posedge clock);
            #1;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Index 2 after wrap-around", test_num);
            reset_dut();
            repeat(18) @(posedge clock);
            #1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset persistence", test_num);
            reset_dut();
            reset = 0;
            repeat(5) @(posedge clock);
            #1;
            #1;

            check_outputs(16'h0000);
            reset = 1;
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
        input [15:0] expected_array_out;
        begin
            if (expected_array_out === (expected_array_out ^ array_out ^ expected_array_out)) begin
                $display("PASS");
                $display("  Outputs: array_out=%h",
                         array_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: array_out=%h",
                         expected_array_out);
                $display("  Got:      array_out=%h",
                         array_out);
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
        $dumpvars(0,clock, reset, array_out);
    end

endmodule
