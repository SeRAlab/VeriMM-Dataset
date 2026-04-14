`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg b;
    reg clk;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            a = 1;
            b = 0;
            @(posedge clk);
            #2;
            $display("Test Case 001: Initial input 1,0");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            a = 1;
            b = 1;
            @(posedge clk);

            #1;
            a = 0;
            b = 1;
            @(posedge clk);
            #2;
            $display("Test Case 002: Sequence (1,1) -> (0,1)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            a = 1;
            b = 1;
            @(posedge clk);

            #1;
            a = 0;
            b = 0;
            @(posedge clk);
            #2;
            $display("Test Case 003: Sequence (1,1) -> (0,0)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            a = 1;
            b = 0;
            @(posedge clk);

            #1;
            a = 0;
            b = 1;
            @(posedge clk);
            #2;
            $display("Test Case 004: Sequence (1,0) -> (0,1)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            a = 0;
            b = 1;
            @(posedge clk);

            #1;
            a = 0;
            b = 1;
            @(posedge clk);
            #2;
            $display("Test Case 005: Sequence (0,1) -> (0,1)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            a = 1;
            b = 1;
            @(posedge clk);
            #1;
            a = 1;
            b = 0;
            @(posedge clk);
            #2;
            $display("Test Case 006: Sequence (1,1) -> (1,0)");
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
        input expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
        $dumpvars(0,a, b, clk, out);
    end

endmodule
