`timescale 1ns/1ps

module fft4_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] x0_imag;
    reg [15:0] x0_real;
    reg [15:0] x1_imag;
    reg [15:0] x1_real;
    reg [15:0] x2_imag;
    reg [15:0] x2_real;
    reg [15:0] x3_imag;
    reg [15:0] x3_real;
    wire [15:0] y0_imag;
    wire [15:0] y0_real;
    wire [15:0] y1_imag;
    wire [15:0] y1_real;
    wire [15:0] y2_imag;
    wire [15:0] y2_real;
    wire [15:0] y3_imag;
    wire [15:0] y3_real;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft4 dut (
        .clk(clk),
        .rst(rst),
        .x0_imag(x0_imag),
        .x0_real(x0_real),
        .x1_imag(x1_imag),
        .x1_real(x1_real),
        .x2_imag(x2_imag),
        .x2_real(x2_real),
        .x3_imag(x3_imag),
        .x3_real(x3_real),
        .y0_imag(y0_imag),
        .y0_real(y0_real),
        .y1_imag(y1_imag),
        .y1_real(y1_real),
        .y2_imag(y2_imag),
        .y2_real(y2_real),
        .y3_imag(y3_imag),
        .y3_real(y3_real)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x0_real = 16'h0; x0_imag = 16'h0;
            x1_real = 16'h0; x1_imag = 16'h0;
            x2_real = 16'h0; x2_imag = 16'h0;
            x3_real = 16'h0; x3_imag = 16'h0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 001: Impulse at x0");
            x0_real = 16'h0001; x0_imag = 16'h0000;
            x1_real = 16'h0000; x1_imag = 16'h0000;
            x2_real = 16'h0000; x2_imag = 16'h0000;
            x3_real = 16'h0000; x3_imag = 16'h0000;

            repeat(5) @(posedge clk);
            #1;

            check_outputs(
                16'h0000, 16'h0001,
                16'h0000, 16'h0001,
                16'h0000, 16'h0001,
                16'h0000, 16'h0001
            );
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 002: DC Signal (All ones)");
            x0_real = 16'h0001; x0_imag = 16'h0000;
            x1_real = 16'h0001; x1_imag = 16'h0000;
            x2_real = 16'h0001; x2_imag = 16'h0000;
            x3_real = 16'h0001; x3_imag = 16'h0000;

            repeat(5) @(posedge clk);
            #1;

            check_outputs(
                16'h0000, 16'h0004,
                16'h0000, 16'h0000,
                16'h0000, 16'h0000,
                16'h0000, 16'h0000
            );
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 003: Alternating Signal (Freq 2)");
            x0_real = 16'h0001; x0_imag = 16'h0000;
            x1_real = 16'hFFFF; x1_imag = 16'h0000;
            x2_real = 16'h0001; x2_imag = 16'h0000;
            x3_real = 16'hFFFF; x3_imag = 16'h0000;

            repeat(5) @(posedge clk);
            #1;

            check_outputs(
                16'h0000, 16'h0000,
                16'h0000, 16'h0000,
                16'h0000, 16'h0004,
                16'h0000, 16'h0000
            );
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 004: Complex Linear Ramp");
            x0_real = 16'h0001; x0_imag = 16'h0001;
            x1_real = 16'h0002; x1_imag = 16'h0002;
            x2_real = 16'h0003; x2_imag = 16'h0003;
            x3_real = 16'h0004; x3_imag = 16'h0004;

            repeat(5) @(posedge clk);
            #1;

            check_outputs(
                16'h000A, 16'h000A,
                16'h0000, 16'hFFFC,
                16'hFFFE, 16'hFFFE,
                16'hFFFC, 16'h0000
            );
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 005: Imaginary Impulse at x1");
            x0_real = 16'h0000; x0_imag = 16'h0000;
            x1_real = 16'h0000; x1_imag = 16'h0001;
            x2_real = 16'h0000; x2_imag = 16'h0000;
            x3_real = 16'h0000; x3_imag = 16'h0000;

            repeat(5) @(posedge clk);
            #1;

            check_outputs(
                16'h0001, 16'h0000,
                16'h0000, 16'h0001,
                16'hFFFF, 16'h0000,
                16'h0000, 16'hFFFF
            );
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fft4 Testbench");
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
        input [15:0] expected_y0_imag;
        input [15:0] expected_y0_real;
        input [15:0] expected_y1_imag;
        input [15:0] expected_y1_real;
        input [15:0] expected_y2_imag;
        input [15:0] expected_y2_real;
        input [15:0] expected_y3_imag;
        input [15:0] expected_y3_real;
        begin
            if (expected_y0_imag === (expected_y0_imag ^ y0_imag ^ expected_y0_imag) &&
                expected_y0_real === (expected_y0_real ^ y0_real ^ expected_y0_real) &&
                expected_y1_imag === (expected_y1_imag ^ y1_imag ^ expected_y1_imag) &&
                expected_y1_real === (expected_y1_real ^ y1_real ^ expected_y1_real) &&
                expected_y2_imag === (expected_y2_imag ^ y2_imag ^ expected_y2_imag) &&
                expected_y2_real === (expected_y2_real ^ y2_real ^ expected_y2_real) &&
                expected_y3_imag === (expected_y3_imag ^ y3_imag ^ expected_y3_imag) &&
                expected_y3_real === (expected_y3_real ^ y3_real ^ expected_y3_real)) begin
                $display("PASS");
                $display("  Outputs: y0_imag=%h, y0_real=%h, y1_imag=%h, y1_real=%h, y2_imag=%h, y2_real=%h, y3_imag=%h, y3_real=%h",
                         y0_imag, y0_real, y1_imag, y1_real, y2_imag, y2_real, y3_imag, y3_real);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y0_imag=%h, y0_real=%h, y1_imag=%h, y1_real=%h, y2_imag=%h, y2_real=%h, y3_imag=%h, y3_real=%h",
                         expected_y0_imag, expected_y0_real, expected_y1_imag, expected_y1_real, expected_y2_imag, expected_y2_real, expected_y3_imag, expected_y3_real);
                $display("  Got:      y0_imag=%h, y0_real=%h, y1_imag=%h, y1_real=%h, y2_imag=%h, y2_real=%h, y3_imag=%h, y3_real=%h",
                         y0_imag, y0_real, y1_imag, y1_real, y2_imag, y2_real, y3_imag, y3_real);
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
        $dumpvars(0,clk, rst, x0_imag, x0_real, x1_imag, x1_real, x2_imag, x2_real, x3_imag, x3_real, y0_imag, y0_real, y1_imag, y1_real, y2_imag, y2_real, y3_imag, y3_real);
    end

endmodule
