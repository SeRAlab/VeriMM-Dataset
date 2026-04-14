`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Q;
    reg clk;
    reg reset;
    wire dff_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Q(Q),
        .clk(clk),
        .reset(reset),
        .dff_output(dff_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            Q = 0;
            #12;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset logic...");
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Capturing HIGH on negedge...");
            reset_dut();
            @(posedge clk);
            Q = 1;
            @(negedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Capturing LOW on negedge...");
            reset_dut();

            @(posedge clk); Q = 1;
            @(negedge clk);

            @(posedge clk); Q = 0;
            @(negedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Posedge immunity check...");
            reset_dut();
            @(negedge clk);
            Q = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Data stability...");
            reset_dut();
            @(posedge clk); Q = 1;
            @(negedge clk);
            #2;
            Q = 0;
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
        input expected_dff_output;
        begin
            if (expected_dff_output === (expected_dff_output ^ dff_output ^ expected_dff_output)) begin
                $display("PASS");
                $display("  Outputs: dff_output=%b",
                         dff_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dff_output=%b",
                         expected_dff_output);
                $display("  Got:      dff_output=%b",
                         dff_output);
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
        $dumpvars(0,Q, clk, reset, dff_output);
    end

endmodule
