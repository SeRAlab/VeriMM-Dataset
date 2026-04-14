`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg [3:0] in;
    wire out_and;
    wire out_or;
    wire out_xor;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .in(in),
        .out_and(out_and),
        .out_or(out_or),
        .out_xor(out_xor),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            d = 0;
            in = 4'b0000;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: All Zeros");
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 8'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Combinational check with in=0101, Reg=0");
            reset_dut();
            in = 4'b0101;
            #1;


            #1;



            check_outputs(1'b0, 1'b1, 1'b1, 8'd2);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Shift 101 (Value 5), in=0000");
            reset_dut();
            d = 1; @(posedge clk);
            d = 0; @(posedge clk);
            d = 1; @(posedge clk);
            #1;
            in = 4'b0000;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 8'd5);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Shift 111 (Value 7), in=1111");
            reset_dut();
            d = 1; @(posedge clk);
            d = 1; @(posedge clk);
            d = 1; @(posedge clk);
            #1;
            in = 4'b1111;


            #1;



            check_outputs(1'b1, 1'b1, 1'b0, 8'd9);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Shift 010 (Value 2), in=1010");
            reset_dut();
            d = 0; @(posedge clk);
            d = 1; @(posedge clk);
            d = 0; @(posedge clk);
            #1;
            in = 4'b1010;


            #1;



            check_outputs(1'b0, 1'b1, 1'b1, 8'd4);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Shift 110 (Value 6), in=1100");
            reset_dut();
            d = 1; @(posedge clk);
            d = 1; @(posedge clk);
            d = 0; @(posedge clk);
            #1;
            in = 4'b1100;


            #1;



            check_outputs(1'b1, 1'b0, 1'b0, 8'd7);
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
        input expected_out_and;
        input expected_out_or;
        input expected_out_xor;
        input [7:0] expected_sum;
        begin
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: out_and=%b, out_or=%b, out_xor=%b, sum=%h",
                         out_and, out_or, out_xor, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%b, out_or=%b, out_xor=%b, sum=%h",
                         expected_out_and, expected_out_or, expected_out_xor, expected_sum);
                $display("  Got:      out_and=%b, out_or=%b, out_xor=%b, sum=%h",
                         out_and, out_or, out_xor, sum);
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
        $dumpvars(0,clk, d, in, out_and, out_or, out_xor, sum);
    end

endmodule
