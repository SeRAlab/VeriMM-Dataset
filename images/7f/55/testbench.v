`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg b;
    reg c;
    reg en;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .en(en),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        en = 0;
        forever #5 en = ~en;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            c = 0;
            @(posedge en);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            a = 1; b = 1; c = 1;
            @(posedge en);
            #1;
            $display("Testcase 001: All inputs HIGH (1 & 1 & 1)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            a = 1; b = 0; c = 1;
            @(posedge en);
            #1;
            $display("Testcase 002: One input LOW (1 & 0 & 1)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            a = 0; b = 0; c = 0;
            @(posedge en);
            #1;
            $display("Testcase 003: All inputs LOW (0 & 0 & 0)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            a = 1; b = 1; c = 1;
            @(posedge en);
            #1;

            a = 0; b = 0;
            #1;
            $display("Testcase 004: Inputs change after rising edge (Latch check)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            a = 1; b = 1; c = 1;
            @(posedge en);
            @(negedge en);
            #1;
            $display("Testcase 005: Output reset when en is LOW");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            a = 0; b = 1; c = 1;
            @(posedge en);
            #1;
            $display("Testcase 006: Combination (0 & 1 & 1)");
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
        $dumpvars(0,a, b, c, en, out);
    end

endmodule
