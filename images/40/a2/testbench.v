`timescale 1ns/1ps

module IFFT_4point_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg valid_in;
    reg [15:0] x0_imag;
    reg [15:0] x0_real;
    reg [15:0] x1_imag;
    reg [15:0] x1_real;
    reg [15:0] x2_imag;
    reg [15:0] x2_real;
    reg [15:0] x3_imag;
    reg [15:0] x3_real;
    wire valid_out;
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
    IFFT_4point dut (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_in),
        .x0_imag(x0_imag),
        .x0_real(x0_real),
        .x1_imag(x1_imag),
        .x1_real(x1_real),
        .x2_imag(x2_imag),
        .x2_real(x2_real),
        .x3_imag(x3_imag),
        .x3_real(x3_real),
        .valid_out(valid_out),
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
            rst_n = 0;
            valid_in = 0;
            x0_real = 0; x0_imag = 0;
            x1_real = 0; x1_imag = 0;
            x2_real = 0; x2_imag = 0;
            x3_real = 0; x3_imag = 0;
            repeat(5) @(posedge clk);
            rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Impulse Input at Bin 0", test_num);
            reset_dut();

            @(negedge clk);
            valid_in = 1;
            x0_real = 16'h0010; x0_imag = 16'h0000;
            x1_real = 16'h0000; x1_imag = 16'h0000;
            x2_real = 16'h0000; x2_imag = 16'h0000;
            x3_real = 16'h0000; x3_imag = 16'h0000;

            @(negedge clk);
            valid_in = 0;

            wait(valid_out);
            @(posedge clk);
            #1;

            check_outputs(1'b1,
                16'h0000, 16'h0010,
                16'h0000, 16'h0010,
                16'h0000, 16'h0010,
                16'h0000, 16'h0010
            );
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: DC Input (All Bins same)", test_num);
            reset_dut();

            @(negedge clk);
            valid_in = 1;
            x0_real = 16'h000A; x0_imag = 16'h0000;
            x1_real = 16'h000A; x1_imag = 16'h0000;
            x2_real = 16'h000A; x2_imag = 16'h0000;
            x3_real = 16'h000A; x3_imag = 16'h0000;

            @(negedge clk);
            valid_in = 0;

            wait(valid_out);
            @(posedge clk);
            #1;

            check_outputs(1'b1,
                16'h0000, 16'h0028,
                16'h0000, 16'h0000,
                16'h0000, 16'h0000,
                16'h0000, 16'h0000
            );
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pure Imaginary Input at Bin 1", test_num);
            reset_dut();

            @(negedge clk);
            valid_in = 1;
            x0_real = 16'h0000; x0_imag = 16'h0000;
            x1_real = 16'h0000; x1_imag = 16'h000A;
            x2_real = 16'h0000; x2_imag = 16'h0000;
            x3_real = 16'h0000; x3_imag = 16'h0000;

            @(negedge clk);
            valid_in = 0;

            wait(valid_out);
            @(posedge clk);
            #1;

            check_outputs(1'b1,
                16'h000A, 16'h0000,
                16'h0000, 16'hFFF6,
                16'hFFF6, 16'h0000,
                16'h0000, 16'h000A
            );
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Linear Ramp Input", test_num);
            reset_dut();

            @(negedge clk);
            valid_in = 1;
            x0_real = 16'h0008; x0_imag = 16'h0000;
            x1_real = 16'h0004; x1_imag = 16'h0000;
            x2_real = 16'h0002; x2_imag = 16'h0000;
            x3_real = 16'h0001; x3_imag = 16'h0000;

            @(negedge clk);
            valid_in = 0;

            wait(valid_out);
            @(posedge clk);
            #1;

            check_outputs(1'b1,
                16'h0000, 16'h000F,
                16'h0003, 16'h0006,
                16'h0000, 16'h0005,
                16'hFFFD, 16'h0006
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
        $display("IFFT_4point Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_valid_out;
        input [15:0] expected_y0_imag;
        input [15:0] expected_y0_real;
        input [15:0] expected_y1_imag;
        input [15:0] expected_y1_real;
        input [15:0] expected_y2_imag;
        input [15:0] expected_y2_real;
        input [15:0] expected_y3_imag;
        input [15:0] expected_y3_real;
        begin
            if (expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out) &&
                expected_y0_imag === (expected_y0_imag ^ y0_imag ^ expected_y0_imag) &&
                expected_y0_real === (expected_y0_real ^ y0_real ^ expected_y0_real) &&
                expected_y1_imag === (expected_y1_imag ^ y1_imag ^ expected_y1_imag) &&
                expected_y1_real === (expected_y1_real ^ y1_real ^ expected_y1_real) &&
                expected_y2_imag === (expected_y2_imag ^ y2_imag ^ expected_y2_imag) &&
                expected_y2_real === (expected_y2_real ^ y2_real ^ expected_y2_real) &&
                expected_y3_imag === (expected_y3_imag ^ y3_imag ^ expected_y3_imag) &&
                expected_y3_real === (expected_y3_real ^ y3_real ^ expected_y3_real)) begin
                $display("PASS");
                $display("  Outputs: valid_out=%b, y0_imag=%h, y0_real=%h, y1_imag=%h, y1_real=%h, y2_imag=%h, y2_real=%h, y3_imag=%h, y3_real=%h",
                         valid_out, y0_imag, y0_real, y1_imag, y1_real, y2_imag, y2_real, y3_imag, y3_real);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid_out=%b, y0_imag=%h, y0_real=%h, y1_imag=%h, y1_real=%h, y2_imag=%h, y2_real=%h, y3_imag=%h, y3_real=%h",
                         expected_valid_out, expected_y0_imag, expected_y0_real, expected_y1_imag, expected_y1_real, expected_y2_imag, expected_y2_real, expected_y3_imag, expected_y3_real);
                $display("  Got:      valid_out=%b, y0_imag=%h, y0_real=%h, y1_imag=%h, y1_real=%h, y2_imag=%h, y2_real=%h, y3_imag=%h, y3_real=%h",
                         valid_out, y0_imag, y0_real, y1_imag, y1_real, y2_imag, y2_real, y3_imag, y3_real);
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
        $dumpvars(0,clk, rst_n, valid_in, x0_imag, x0_real, x1_imag, x1_real, x2_imag, x2_real, x3_imag, x3_real, valid_out, y0_imag, y0_real, y1_imag, y1_real, y2_imag, y2_real, y3_imag, y3_real);
    end

endmodule
