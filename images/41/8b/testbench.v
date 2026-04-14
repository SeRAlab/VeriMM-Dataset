`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d0;
    reg d1;
    reg d2;
    reg d3;
    reg in0;
    reg in1;
    reg in2;
    reg in3;
    reg reset;
    wire out0;
    wire out1;
    wire out2;
    wire out3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .reset(reset),
        .out0(out0),
        .out1(out1),
        .out2(out2),
        .out3(out3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            d0 = 0; d1 = 0; d2 = 0; d3 = 0;
            in0 = 0; in1 = 0; in2 = 0; in3 = 0;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset");
            reset_dut();
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Select in0 = 1");
            reset_dut();
            in0 = 1'b1; d0 = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Select in1 = 1");
            reset_dut();
            in1 = 1'b1; d1 = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Select in2 = 1");
            reset_dut();
            in2 = 1'b1; d2 = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Select in3 = 1");
            reset_dut();
            in3 = 1'b1; d3 = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Select in0 = 0");
            reset_dut();
            in0 = 1'b0; d0 = 1'b1;

            in1 = 1'b1; d1 = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Latch Persistence (Input changes between clocks)");
            reset_dut();
            in2 = 1'b1; d2 = 1'b1;
            @(posedge clk);
            #2;
            in2 = 1'b0;
            d2 = 1'b0;
            #3;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Mid-cycle Asynchronous Reset");
            reset_dut();
            in3 = 1'b1; d3 = 1'b1;
            @(posedge clk);
            #2;

            reset = 1'b1;
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
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
        input expected_out0;
        input expected_out1;
        input expected_out2;
        input expected_out3;
        begin
            if (expected_out0 === (expected_out0 ^ out0 ^ expected_out0) &&
                expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3)) begin
                $display("PASS");
                $display("  Outputs: out0=%b, out1=%b, out2=%b, out3=%b",
                         out0, out1, out2, out3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out0=%b, out1=%b, out2=%b, out3=%b",
                         expected_out0, expected_out1, expected_out2, expected_out3);
                $display("  Got:      out0=%b, out1=%b, out2=%b, out3=%b",
                         out0, out1, out2, out3);
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
        $dumpvars(0,clk, d0, d1, d2, d3, in0, in1, in2, in3, reset, out0, out1, out2, out3);
    end

endmodule
