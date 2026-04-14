`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] a_in;
    reg [1:0] b_in;
    reg clock;
    reg reset_n;
    wire [3:0] out0;
    wire out1;
    wire out5;
    wire [3:0] out6;
    wire out7;
    wire [3:0] out8;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_in(a_in),
        .b_in(b_in),
        .clock(clock),
        .reset_n(reset_n),
        .out0(out0),
        .out1(out1),
        .out5(out5),
        .out6(out6),
        .out7(out7),
        .out8(out8)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset_n = 1'b0;
            a_in = 3'b000;
            b_in = 2'b00;
            @(posedge clock);
            #1 reset_n = 1'b1;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase001: Testing b_in = 00, a_in = 000");
            reset_dut();
            a_in = 3'b000;
            b_in = 2'b00;
            @(posedge clock);
            #1;

            #1;


            check_outputs(4'b1111, 1'b1, 1'b1, 4'b1111, 1'b0, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase002: Testing b_in = 01, a_in = 010");
            reset_dut();
            a_in = 3'b010;
            b_in = 2'b01;
            @(posedge clock);
            #1;

            #1;


            check_outputs(4'b1101, 1'b0, 1'b0, 4'b0000, 1'b0, 4'b0010);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase003: Testing b_in = 10, a_in = 111");
            reset_dut();
            a_in = 3'b111;
            b_in = 2'b10;
            @(posedge clock);
            #1;

            #1;


            check_outputs(4'b1000, 1'b0, 1'b0, 4'b0000, 1'b1, 4'b1111);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase004: Testing b_in = 11, a_in = 101");
            reset_dut();
            a_in = 3'b101;
            b_in = 2'b11;
            @(posedge clock);
            #1;

            #1;


            check_outputs(4'b1010, 1'b0, 1'b0, 4'b0000, 1'b0, 4'b0101);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase005: Testing Reset Recovery with a_in = 100, b_in = 00");
            reset_dut();
            a_in = 3'b100;
            b_in = 2'b00;
            @(posedge clock);
            #1;

            #1;


            check_outputs(4'b1011, 1'b1, 1'b1, 4'b1111, 1'b0, 4'b0100);
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
        input [3:0] expected_out0;
        input expected_out1;
        input expected_out5;
        input [3:0] expected_out6;
        input expected_out7;
        input [3:0] expected_out8;
        begin
            if (expected_out0 === (expected_out0 ^ out0 ^ expected_out0) &&
                expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out5 === (expected_out5 ^ out5 ^ expected_out5) &&
                expected_out6 === (expected_out6 ^ out6 ^ expected_out6) &&
                expected_out7 === (expected_out7 ^ out7 ^ expected_out7) &&
                expected_out8 === (expected_out8 ^ out8 ^ expected_out8)) begin
                $display("PASS");
                $display("  Outputs: out0=%h, out1=%b, out5=%b, out6=%h, out7=%b, out8=%h",
                         out0, out1, out5, out6, out7, out8);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out0=%h, out1=%b, out5=%b, out6=%h, out7=%b, out8=%h",
                         expected_out0, expected_out1, expected_out5, expected_out6, expected_out7, expected_out8);
                $display("  Got:      out0=%h, out1=%b, out5=%b, out6=%h, out7=%b, out8=%h",
                         out0, out1, out5, out6, out7, out8);
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
        $dumpvars(0,a_in, b_in, clock, reset_n, out0, out1, out5, out6, out7, out8);
    end

endmodule
