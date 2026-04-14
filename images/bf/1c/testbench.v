`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iClk;
    reg iRst;
    reg in;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iClk(iClk),
        .iRst(iRst),
        .in(in),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        iClk = 0;
        forever #5 iClk = ~iClk;
    end

        task reset_dut;

        begin
            iRst = 1;
            in = 0;
            repeat(2) @(posedge iClk);
            #1;
            iRst = 0;
            @(posedge iClk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase 001: Reset logic check...");
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase 002: Propagation of logic high...");
            reset_dut();
            @(negedge iClk);
            in = 1;

            repeat(5) @(posedge iClk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase 003: Propagation of logic low...");
            reset_dut();
            @(negedge iClk);
            in = 1;
            repeat(5) @(posedge iClk);
            @(negedge iClk);
            in = 0;
            repeat(5) @(posedge iClk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase 004: Multiple transitions...");
            reset_dut();
            @(negedge iClk);
            in = 1;
            repeat(2) @(posedge iClk);
            in = 0;
            repeat(2) @(posedge iClk);
            in = 1;
            repeat(5) @(posedge iClk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase 005: Reset during active input...");
            reset_dut();
            @(negedge iClk);
            in = 1;
            repeat(2) @(posedge iClk);
            iRst = 1;
            repeat(2) @(posedge iClk);
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
        $dumpvars(0,iClk, iRst, in, out);
    end

endmodule
