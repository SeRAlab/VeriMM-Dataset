`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data;
    wire locked;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .locked(locked),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data = 0;
            test_num = test_num + 1;
            repeat(10) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase %03d: Static input behavior...", test_num + 1);
            reset_dut();
            data = 0;
            repeat(50) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase %03d: Toggling data (1:1 frequency) for locking...", test_num + 1);
            reset_dut();

            repeat(100) begin
                @(posedge clk);
                #2 data = 1;
                @(posedge clk);
                #2 data = 0;
            end

            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase %03d: Rapid transitions then hold high...", test_num + 1);
            reset_dut();
            repeat(150) begin
                @(posedge clk);
                data = ~data;
            end
            data = 1;
            repeat(20) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase %03d: Data with phase offset...", test_num + 1);
            reset_dut();

            repeat(100) begin
                @(negedge clk);
                data = 1;
                repeat(2) @(negedge clk);
                data = 0;
            end

            repeat(10) @(posedge clk);

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
        input expected_locked;
        input expected_out;
        begin
            if (expected_locked === (expected_locked ^ locked ^ expected_locked) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: locked=%b, out=%b",
                         locked, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: locked=%b, out=%b",
                         expected_locked, expected_out);
                $display("  Got:      locked=%b, out=%b",
                         locked, out);
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
        $dumpvars(0,clk, data, locked, out);
    end

endmodule
