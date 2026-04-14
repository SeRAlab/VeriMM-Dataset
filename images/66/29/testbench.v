`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg reset;
    wire negative;
    wire overflow;
    wire [7:0] sum;
    wire unsigned_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .reset(reset),
        .negative(negative),
        .overflow(overflow),
        .sum(sum),
        .unsigned_flag(unsigned_flag)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            A = 0;
            B = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            A = 8'd10;
            B = 8'd20;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0, 8'd30, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            A = 8'd200;
            B = 8'd100;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b1, 8'd44, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            A = 8'h80;
            B = 8'h05;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0, 8'h85, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            A = 8'h01;
            B = 8'hFF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b1, 8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            A = 8'h00;
            B = 8'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0, 8'h00, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            A = 8'd127;
            B = 8'd128;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b0, 8'hFF, 1'b1);
        end
        endtask

    task testcase007;

        begin

            A = 8'hAA;
            B = 8'h55;
            reset = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0, 8'h00, 1'b0);
            reset = 0;
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
        input expected_negative;
        input expected_overflow;
        input [7:0] expected_sum;
        input expected_unsigned_flag;
        begin
            if (expected_negative === (expected_negative ^ negative ^ expected_negative) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum) &&
                expected_unsigned_flag === (expected_unsigned_flag ^ unsigned_flag ^ expected_unsigned_flag)) begin
                $display("PASS");
                $display("  Outputs: negative=%b, overflow=%b, sum=%h, unsigned_flag=%b",
                         negative, overflow, sum, unsigned_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: negative=%b, overflow=%b, sum=%h, unsigned_flag=%b",
                         expected_negative, expected_overflow, expected_sum, expected_unsigned_flag);
                $display("  Got:      negative=%b, overflow=%b, sum=%h, unsigned_flag=%b",
                         negative, overflow, sum, unsigned_flag);
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
        $dumpvars(0,A, B, clk, reset, negative, overflow, sum, unsigned_flag);
    end

endmodule
