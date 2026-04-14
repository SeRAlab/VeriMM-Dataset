`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in;
    reg reset;
    reg slowena;
    wire [7:0] out_hi;
    wire [7:0] out_lo;
    wire [3:0] q;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .slowena(slowena),
        .out_hi(out_hi),
        .out_lo(out_lo),
        .q(q),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            slowena = 0;
            in = 16'h0000;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00, 4'h0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Byte Splitter and Summation Logic", test_num);
            reset_dut();
            in = 16'h1234;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h12, 8'h34, 4'h0, 8'h46);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Decade Counter Incrementing", test_num);
            reset_dut();
            slowena = 1;
            in = 16'h0000;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'h00, 4'h5, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Decade Counter Wrap-around (9 -> 0)", test_num);
            reset_dut();
            slowena = 1;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'h00, 4'h0, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Counter Enable Signal Check", test_num);
            reset_dut();
            slowena = 1;
            repeat(3) @(posedge clk);
            slowena = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'h00, 4'h3, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Summation with Overflow", test_num);
            reset_dut();
            in = 16'hFF02;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF, 8'h02, 4'h0, 8'h01);
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
        input [7:0] expected_out_hi;
        input [7:0] expected_out_lo;
        input [3:0] expected_q;
        input [7:0] expected_sum;
        begin
            if (expected_out_hi === (expected_out_hi ^ out_hi ^ expected_out_hi) &&
                expected_out_lo === (expected_out_lo ^ out_lo ^ expected_out_lo) &&
                expected_q === (expected_q ^ q ^ expected_q) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: out_hi=%h, out_lo=%h, q=%h, sum=%h",
                         out_hi, out_lo, q, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_hi=%h, out_lo=%h, q=%h, sum=%h",
                         expected_out_hi, expected_out_lo, expected_q, expected_sum);
                $display("  Got:      out_hi=%h, out_lo=%h, q=%h, sum=%h",
                         out_hi, out_lo, q, sum);
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
        $dumpvars(0,clk, in, reset, slowena, out_hi, out_lo, q, sum);
    end

endmodule
