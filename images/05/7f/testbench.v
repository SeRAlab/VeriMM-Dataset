`timescale 1ns/1ps

module fft_4point_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a_imag;
    reg [15:0] a_real;
    reg [15:0] b_imag;
    reg [15:0] b_real;
    reg [15:0] c_imag;
    reg [15:0] c_real;
    reg clk;
    reg [15:0] d_imag;
    reg [15:0] d_real;
    reg rst;
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
        .a_imag(a_imag),
        .a_real(a_real),
        .b_imag(b_imag),
        .b_real(b_real),
        .c_imag(c_imag),
        .c_real(c_real),
        .clk(clk),
        .d_imag(d_imag),
        .d_real(d_real),
        .rst(rst),
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
            a_imag = 0; a_real = 0;
            b_imag = 0; b_real = 0;
            c_imag = 0; c_real = 0;
            d_imag = 0; d_real = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase %0d: Impulse x[0]=1", test_num);
            @(negedge clk);
            a_real = 16'sd1; a_imag = 16'sd0;
            b_real = 16'sd0; b_imag = 16'sd0;
            c_real = 16'sd0; c_imag = 16'sd0;
            d_real = 16'sd0; d_imag = 16'sd0;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(16'sd0, 16'sd1, 16'sd0, 16'sd1, 16'sd0, 16'sd1, 16'sd0, 16'sd1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase %0d: DC Signal all 1s", test_num);
            @(negedge clk);
            a_real = 16'sd1; a_imag = 16'sd0;
            b_real = 16'sd1; b_imag = 16'sd0;
            c_real = 16'sd1; c_imag = 16'sd0;
            d_real = 16'sd1; d_imag = 16'sd0;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(16'sd0, 16'sd4, 16'sd0, 16'sd0, 16'sd0, 16'sd0, 16'sd0, 16'sd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase %0d: High Frequency [1, -1, 1, -1]", test_num);
            @(negedge clk);
            a_real = 16'sd1;  a_imag = 16'sd0;
            b_real = -16'sd1; b_imag = 16'sd0;
            c_real = 16'sd1;  c_imag = 16'sd0;
            d_real = -16'sd1; d_imag = 16'sd0;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(16'sd0, 16'sd0, 16'sd0, 16'sd0, 16'sd0, 16'sd4, 16'sd0, 16'sd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase %0d: Complex Exp Bin 3 [1, -j, -1, j]", test_num);
            @(negedge clk);
            a_real = 16'sd1;  a_imag = 16'sd0;
            b_real = 16'sd0;  b_imag = -16'sd1;
            c_real = -16'sd1; c_imag = 16'sd0;
            d_real = 16'sd0;  d_imag = 16'sd1;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(16'sd0, 16'sd0, 16'sd0, 16'sd0, 16'sd0, 16'sd0, 16'sd0, 16'sd4);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase %0d: Real Ramp [1, 2, 3, 4]", test_num);
            @(negedge clk);
            a_real = 16'sd1; a_imag = 16'sd0;
            b_real = 16'sd2; b_imag = 16'sd0;
            c_real = 16'sd3; c_imag = 16'sd0;
            d_real = 16'sd4; d_imag = 16'sd0;
            repeat (5) @(posedge clk);

            #1;


            check_outputs(16'sd0, 16'sd10, 16'sd2, -16'sd2, 16'sd0, -16'sd2, -16'sd2, -16'sd2);
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
        $dumpvars(0,a_imag, a_real, b_imag, b_real, c_imag, c_real, clk, d_imag, d_real, rst, y0_imag, y0_real, y1_imag, y1_real, y2_imag, y2_real, y3_imag, y3_real);
    end

endmodule
