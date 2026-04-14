`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in;
    reg load;
    reg reset;
    wire [3:0] out;
    wire ser_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .load(load),
        .reset(reset),
        .out(out),
        .ser_out(ser_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        load = 0;
        in = 4'b0000;
        @(posedge clk);
        #1 reset = 0;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Load Positive Value (0101)");
        reset_dut();
        in = 4'b0101;
        load = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0101, 1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Load Negative Value (1010)");
        reset_dut();
        in = 4'b1010;
        load = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0010, 1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Shift Positive Value (0011 -> 0110)");
        reset_dut();
        in = 4'b0011;
        load = 1;
        @(posedge clk);
        load = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0110, 1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Edge Case (-8)");
        reset_dut();
        in = 4'b1000;
        load = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1000, 1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Multiple Shifts");
        reset_dut();
        in = 4'b1011;
        load = 1;
        @(posedge clk);
        load = 0;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0100, 1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Reset verification");
        reset_dut();
        in = 4'b1111;
        load = 1;
        @(posedge clk);
        reset = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0000, 1'b0);
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
        input [3:0] expected_out;
        input expected_ser_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_ser_out === (expected_ser_out ^ ser_out ^ expected_ser_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h, ser_out=%b",
                         out, ser_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, ser_out=%b",
                         expected_out, expected_ser_out);
                $display("  Got:      out=%h, ser_out=%b",
                         out, ser_out);
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
        $dumpvars(0,clk, in, load, reset, out, ser_out);
    end

endmodule
