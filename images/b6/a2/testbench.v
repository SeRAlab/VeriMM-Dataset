`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg [6:0] b;
    reg clk;
    reg done;
    reg start;
    wire [13:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .done(done),
        .start(start),
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
            start = 0;
            done = 0;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
        end
        endtask
    task perform_mult;

        input [6:0] factor_a;
        input [6:0] factor_b;
        integer i;
        begin
            reset_dut();
            for (i = 0; i < 7; i = i + 1) begin
                a = factor_a[i];
                b = factor_b;
                @(posedge clk);
            end
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: 127 * 127");
            test_num = 1;
            perform_mult(7'd127, 7'd127);
            #1;

            check_outputs(14'd16129);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: 1 * 127");
            test_num = 2;
            perform_mult(7'd1, 7'd127);
            #1;

            check_outputs(14'd127);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: 127 * 1");
            test_num = 3;
            perform_mult(7'd127, 7'd1);
            #1;

            check_outputs(14'd127);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: 127 * 0");
            test_num = 4;
            perform_mult(7'd127, 7'd0);
            #1;

            check_outputs(14'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: 10 * 10");
            test_num = 5;
            perform_mult(7'd10, 7'd10);
            #1;

            check_outputs(14'd100);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: 64 * 2");
            test_num = 6;
            perform_mult(7'd64, 7'd2);
            #1;

            check_outputs(14'd128);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: 41 * 13");
            test_num = 7;
            perform_mult(7'd41, 7'd13);
            #1;

            check_outputs(14'd533);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Verify 'done' signal resets output to zero");
            test_num = 8;
            perform_mult(7'd10, 7'd10);
            done = 1;
            @(posedge clk);
            #1;

            check_outputs(14'd0);
            done = 0;
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
        testcase007();
        testcase008();
        
        
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
        input [13:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
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
        $dumpvars(0,a, b, clk, done, start, out);
    end

endmodule
