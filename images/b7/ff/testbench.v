`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg in;
    reg ref_clk;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .ref_clk(ref_clk),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        ref_clk = 0;
        forever #5 ref_clk = ~ref_clk;
    end

        task reset_dut;

        begin
            in = 0;
            repeat(5) @(posedge ref_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            in = 1;
            @(posedge ref_clk);
            #2;
            $display("Testcase 001: 0 to 1 transition");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            in = 1;
            @(posedge ref_clk);
            #1;
            in = 0;
            @(posedge ref_clk);
            #2;
            $display("Testcase 002: 1 to 0 transition");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            in = 1;
            repeat(4) @(posedge ref_clk);
            #2;
            $display("Testcase 003: Sustained high signal");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            in = 1;
            @(posedge ref_clk);
            #1;
            in = 0;
            repeat(4) @(posedge ref_clk);
            #2;
            $display("Testcase 004: Sustained low signal");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            in = 1;
            @(posedge ref_clk);
            #1;
            in = 0;
            @(posedge ref_clk);
            #1;
            in = 1;
            @(posedge ref_clk);
            #2;
            $display("Testcase 005: Sequence 1-0-1");
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
        $dumpvars(0,in, ref_clk, out);
    end

endmodule
