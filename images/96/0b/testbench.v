`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in;
    reg reset;
    wire green;
    wire [9:0] out;
    wire red;
    wire yellow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .green(green),
        .out(out),
        .red(red),
        .yellow(yellow)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task calculate_expected;

        input [7:0] data_in;
        output exp_red;
        output exp_yellow;
        output exp_green;
        output [9:0] exp_out;
        reg [3:0] priority_idx;
        reg parity;
        integer i;
        begin
            parity = ^data_in;
            exp_red = ~parity;
            exp_green = parity;
            exp_yellow = |data_in;

            priority_idx = 0;
            for (i = 0; i < 8; i = i + 1) begin
                if (data_in[i]) priority_idx = i;
            end



            exp_out = {parity, 6'b0, priority_idx[2:0]};
        end
        endtask

    task testcase001;

        reg e_red, e_yellow, e_green;
        reg [9:0] e_out;
        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros", test_num);
            reset_dut();
            in = 8'b00000000;
            @(posedge clk);
            #2;
            calculate_expected(in, e_red, e_yellow, e_green, e_out);
            #1;

            check_outputs(e_green, e_out, e_red, e_yellow);
        end
        endtask

    task testcase002;

        reg e_red, e_yellow, e_green;
        reg [9:0] e_out;
        begin
            test_num = test_num + 1;
            $display("Test %0d: LSB Set", test_num);
            reset_dut();
            in = 8'b00000001;
            @(posedge clk);
            #2;
            calculate_expected(in, e_red, e_yellow, e_green, e_out);
            #1;

            check_outputs(e_green, e_out, e_red, e_yellow);
        end
        endtask

    task testcase003;

        reg e_red, e_yellow, e_green;
        reg [9:0] e_out;
        begin
            test_num = test_num + 1;
            $display("Test %0d: MSB Set", test_num);
            reset_dut();
            in = 8'b10000000;
            @(posedge clk);
            #2;
            calculate_expected(in, e_red, e_yellow, e_green, e_out);
            #1;

            check_outputs(e_green, e_out, e_red, e_yellow);
        end
        endtask

    task testcase004;

        reg e_red, e_yellow, e_green;
        reg [9:0] e_out;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Two Bits (Even)", test_num);
            reset_dut();
            in = 8'b10000001;
            @(posedge clk);
            #2;
            calculate_expected(in, e_red, e_yellow, e_green, e_out);
            #1;

            check_outputs(e_green, e_out, e_red, e_yellow);
        end
        endtask

    task testcase005;

        reg e_red, e_yellow, e_green;
        reg [9:0] e_out;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Three Bits (Odd)", test_num);
            reset_dut();
            in = 8'b00101100;
            @(posedge clk);
            #2;
            calculate_expected(in, e_red, e_yellow, e_green, e_out);
            #1;

            check_outputs(e_green, e_out, e_red, e_yellow);
        end
        endtask

    task testcase006;

        reg e_red, e_yellow, e_green;
        reg [9:0] e_out;
        begin
            test_num = test_num + 1;
            $display("Test %0d: All Bits Set", test_num);
            reset_dut();
            in = 8'b11111111;
            @(posedge clk);
            #2;
            calculate_expected(in, e_red, e_yellow, e_green, e_out);
            #1;

            check_outputs(e_green, e_out, e_red, e_yellow);
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
        input expected_green;
        input [9:0] expected_out;
        input expected_red;
        input expected_yellow;
        begin
            if (expected_green === (expected_green ^ green ^ expected_green) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_red === (expected_red ^ red ^ expected_red) &&
                expected_yellow === (expected_yellow ^ yellow ^ expected_yellow)) begin
                $display("PASS");
                $display("  Outputs: green=%b, out=%h, red=%b, yellow=%b",
                         green, out, red, yellow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: green=%b, out=%h, red=%b, yellow=%b",
                         expected_green, expected_out, expected_red, expected_yellow);
                $display("  Got:      green=%b, out=%h, red=%b, yellow=%b",
                         green, out, red, yellow);
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
        $dumpvars(0,clk, in, reset, green, out, red, yellow);
    end

endmodule
