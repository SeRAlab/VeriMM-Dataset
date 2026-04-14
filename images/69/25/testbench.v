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
            @(posedge clk);
            reset = 1;
            in0 = 0; in1 = 0; in2 = 0; in3 = 0;
            d0 = 0; d1 = 0; d2 = 0; d3 = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: All inputs low");
            reset_dut();
            in0 = 0; in1 = 0; in2 = 0; in3 = 0;
            d0 = 0; d1 = 0; d2 = 0; d3 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: in signals high");
            reset_dut();
            in0 = 1; in1 = 1; in2 = 1; in3 = 1;
            d0 = 0; d1 = 0; d2 = 0; d3 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: d signals high");
            reset_dut();
            in0 = 0; in1 = 0; in2 = 0; in3 = 0;
            d0 = 1; d1 = 1; d2 = 1; d3 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Mixed pattern checkerboard");
            reset_dut();





            in0 = 1; in1 = 0; in2 = 1; in3 = 0;
            d0 = 0; d1 = 0; d2 = 0; d3 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Select signals overriding low inputs");
            reset_dut();




            in0 = 0; in1 = 0; in2 = 0; in3 = 0;
            d0 = 1; d1 = 0; d2 = 1; d3 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0, 1);
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
