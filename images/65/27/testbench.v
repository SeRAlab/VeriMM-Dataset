`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    wire [3:0] clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin



            @(negedge clk_in);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Check if all outputs are HIGH after clk_in rising edge");
            reset_dut();
            @(posedge clk_in);
            #2;
            #1;

            check_outputs(4'hf);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Check if all outputs are LOW after clk_in falling edge");
            reset_dut();
            @(posedge clk_in);
            @(negedge clk_in);
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Check synchronization after multiple clock cycles (HIGH phase)");
            reset_dut();
            repeat(5) @(posedge clk_in);
            #2;
            #1;

            check_outputs(4'hf);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Check synchronization after multiple clock cycles (LOW phase)");
            reset_dut();
            repeat(5) @(negedge clk_in);
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Verify outputs respond to immediate clock transitions");
            reset_dut();

            repeat(10) @(posedge clk_in);
            #1;
            #1;

            check_outputs(4'hf);
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
        input [3:0] expected_clk_out;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%h",
                         clk_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%h",
                         expected_clk_out);
                $display("  Got:      clk_out=%h",
                         clk_out);
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
        $dumpvars(0,clk_in, clk_out);
    end

endmodule
