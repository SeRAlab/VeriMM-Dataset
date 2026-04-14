`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clear = 0;
        forever #5 clear = ~clear;
    end

        task reset_dut;

        begin
            clear = 1;
            #15;
            clear = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Initial Reset");
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Counting to 5");
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Wrap around (16 cycles)");
            reset_dut();
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Wrap around plus 3 cycles");
            reset_dut();
            repeat(19) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Asynchronous clear mid-cycle");
            reset_dut();
            repeat(7) @(posedge clk);
            #3;
            clear = 1;
            #1;
            #1;

            check_outputs(4'h0);
            clear = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Maximum count (15)");
            reset_dut();
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF);
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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clear, clk, q);
    end

endmodule
