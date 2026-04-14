`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data;
    reg reset;
    wire start_shifting;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .reset(reset),
        .start_shifting(start_shifting)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Success Sequence...");
            reset_dut();
            data = 1; @(posedge clk);
            data = 1; @(posedge clk);
            data = 1; @(posedge clk);
            data = 1; @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Reset Mid-Sequence...");
            reset_dut();
            data = 1; @(posedge clk);
            data = 1; @(posedge clk);
            reset = 1; @(posedge clk);
            #1 reset = 0;
            data = 1; @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Incomplete Sequence...");
            reset_dut();
            data = 1; @(posedge clk);
            data = 1; @(posedge clk);
            data = 0; @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Recovery to State E...");
            reset_dut();

            data = 1; @(posedge clk);
            data = 0; @(posedge clk);

            data = 1; @(posedge clk);
            data = 1; @(posedge clk);
            data = 1; @(posedge clk);
            data = 1; @(posedge clk);
            #2;
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
        input expected_start_shifting;
        begin
            if (expected_start_shifting === (expected_start_shifting ^ start_shifting ^ expected_start_shifting)) begin
                $display("PASS");
                $display("  Outputs: start_shifting=%b",
                         start_shifting);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: start_shifting=%b",
                         expected_start_shifting);
                $display("  Got:      start_shifting=%b",
                         start_shifting);
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
        $dumpvars(0,clk, data, reset, start_shifting);
    end

endmodule
