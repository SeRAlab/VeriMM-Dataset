`timescale 1ns/1ps

module fft_butterfly_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a_imag;
    reg [15:0] a_real;
    reg [15:0] b_imag;
    reg [15:0] b_real;
    reg clk;
    reg rst;
    reg valid_in;
    wire [15:0] out_a_imag;
    wire [15:0] out_a_real;
    wire [15:0] out_b_imag;
    wire [15:0] out_b_real;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_butterfly dut (
        .a_imag(a_imag),
        .a_real(a_real),
        .b_imag(b_imag),
        .b_real(b_real),
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .out_a_imag(out_a_imag),
        .out_a_real(out_a_real),
        .out_b_imag(out_b_imag),
        .out_b_real(out_b_real),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid_in = 0;
            a_real = 16'd0;
            a_imag = 16'd0;
            b_real = 16'd0;
            b_imag = 16'd0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Positive Integers", test_num);
            a_real = 16'h000A; a_imag = 16'h0005;
            b_real = 16'h0004; b_imag = 16'h0002;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            wait(valid_out);
            #1;
            #1;

            check_outputs(16'h0007, 16'h000E, 16'h0003, 16'h0006, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative Numbers", test_num);
            a_real = 16'hFFEC; a_imag = 16'hFFF6;
            b_real = 16'h0005; b_imag = 16'h0005;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            wait(valid_out);
            #1;
            #1;

            check_outputs(16'hFFFB, 16'hFFF1, 16'hFFF1, 16'hFFE7, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction to Zero", test_num);
            a_real = 16'h0064; a_imag = 16'h0064;
            b_real = 16'h0064; b_imag = 16'h0064;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            wait(valid_out);
            #1;
            #1;

            check_outputs(16'h00C8, 16'h00C8, 16'h0000, 16'h0000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros", test_num);
            a_real = 16'h0000; a_imag = 16'h0000;
            b_real = 16'h0000; b_imag = 16'h0000;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            wait(valid_out);
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mixed Real and Imaginary", test_num);
            a_real = 16'h03E8; a_imag = 16'h0000;
            b_real = 16'h0000; b_imag = 16'h03E8;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            wait(valid_out);
            #1;
            #1;

            check_outputs(16'h03E8, 16'h03E8, 16'hFC18, 16'h03E8, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fft_butterfly Testbench");
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
        input [15:0] expected_out_a_imag;
        input [15:0] expected_out_a_real;
        input [15:0] expected_out_b_imag;
        input [15:0] expected_out_b_real;
        input expected_valid_out;
        begin
            if (expected_out_a_imag === (expected_out_a_imag ^ out_a_imag ^ expected_out_a_imag) &&
                expected_out_a_real === (expected_out_a_real ^ out_a_real ^ expected_out_a_real) &&
                expected_out_b_imag === (expected_out_b_imag ^ out_b_imag ^ expected_out_b_imag) &&
                expected_out_b_real === (expected_out_b_real ^ out_b_real ^ expected_out_b_real) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: out_a_imag=%h, out_a_real=%h, out_b_imag=%h, out_b_real=%h, valid_out=%b",
                         out_a_imag, out_a_real, out_b_imag, out_b_real, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_a_imag=%h, out_a_real=%h, out_b_imag=%h, out_b_real=%h, valid_out=%b",
                         expected_out_a_imag, expected_out_a_real, expected_out_b_imag, expected_out_b_real, expected_valid_out);
                $display("  Got:      out_a_imag=%h, out_a_real=%h, out_b_imag=%h, out_b_real=%h, valid_out=%b",
                         out_a_imag, out_a_real, out_b_imag, out_b_real, valid_out);
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
        $dumpvars(0,a_imag, a_real, b_imag, b_real, clk, rst, valid_in, out_a_imag, out_a_real, out_b_imag, out_b_real, valid_out);
    end

endmodule
