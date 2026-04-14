`timescale 1ns/1ps

module fft_4point_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] x0;
    reg [15:0] x1;
    reg [15:0] x2;
    reg [15:0] x3;
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
    fft_4point dut (
        .clk(clk),
        .reset(reset),
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
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
        reset = 1;
        x0 = 0; x1 = 0; x2 = 0; x3 = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        x0 = 16'h0001; x1 = 16'h0000; x2 = 16'h0000; x3 = 16'h0000;
        repeat(2) @(posedge clk);
        #1;
        $display("Test Case 001: Unit Impulse");
        #1;

        check_outputs(16'h0000, 16'h0001, 16'h0000, 16'h0001, 16'h0000, 16'h0001, 16'h0000, 16'h0001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        x0 = 16'h0004; x1 = 16'h0004; x2 = 16'h0004; x3 = 16'h0004;
        repeat(2) @(posedge clk);
        #1;
        $display("Test Case 002: DC Signal");
        #1;

        check_outputs(16'h0000, 16'h0010, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        x0 = 16'h0002; x1 = 16'hFFFE; x2 = 16'h0002; x3 = 16'hFFFE;
        repeat(2) @(posedge clk);
        #1;
        $display("Test Case 003: Nyquist Frequency");
        #1;

        check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0008, 16'h0000, 16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        x0 = 16'h0000; x1 = 16'h0001; x2 = 16'h0000; x3 = 16'hFFFF;
        repeat(2) @(posedge clk);
        #1;
        $display("Test Case 004: Sine Pattern");
        #1;

        check_outputs(16'h0000, 16'h0000, 16'hFFFE, 16'h0000, 16'h0000, 16'h0000, 16'h0002, 16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        x0 = 16'h0001; x1 = 16'h0002; x2 = 16'h0003; x3 = 16'h0004;
        repeat(2) @(posedge clk);
        #1;
        $display("Test Case 005: Linear Ramp");
        #1;

        check_outputs(16'h0000, 16'h000A, 16'h0002, 16'hFFFE, 16'h0000, 16'hFFFE, 16'hFFFE, 16'hFFFE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fft_4point Testbench");
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
        $dumpvars(0,clk, reset, x0, x1, x2, x3, y0_imag, y0_real, y1_imag, y1_real, y2_imag, y2_real, y3_imag, y3_real);
    end

endmodule
