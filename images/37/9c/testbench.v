`timescale 1ns/1ps

module fft_2point_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a_imag;
    reg [3:0] a_real;
    reg [3:0] b_imag;
    reg [3:0] b_real;
    reg clk;
    reg rst;
    wire [3:0] y0_imag;
    wire [3:0] y0_real;
    wire [3:0] y1_imag;
    wire [3:0] y1_real;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_2point dut (
        .a_imag(a_imag),
        .a_real(a_real),
        .b_imag(b_imag),
        .b_real(b_real),
        .clk(clk),
        .rst(rst),
        .y0_imag(y0_imag),
        .y0_real(y0_real),
        .y1_imag(y1_imag),
        .y1_real(y1_real)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            a_real = 0;
            a_imag = 0;
            b_real = 0;
            b_imag = 0;
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
            $display("Testcase %03d: All Zeros", test_num);
            reset_dut();
            a_real = 4'h0; a_imag = 4'h0;
            b_real = 4'h0; b_imag = 4'h0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simple Positive Values", test_num);
            reset_dut();
            a_real = 4'h2; a_imag = 4'h1;
            b_real = 4'h3; b_imag = 4'h2;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h3, 4'h5, 4'hF, 4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Positive with Overflow", test_num);
            reset_dut();
            a_real = 4'h7; a_imag = 4'h0;
            b_real = 4'h1; b_imag = 4'h0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h0, 4'h8, 4'h0, 4'h6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Negative Values", test_num);
            reset_dut();
            a_real = 4'hF; a_imag = 4'hF;
            b_real = 4'hE; b_imag = 4'hE;
            @(posedge clk);
            #1 #1;
 check_outputs(4'hD, 4'hD, 4'h1, 4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Minimum Values", test_num);
            reset_dut();
            a_real = 4'h0; a_imag = 4'h0;
            b_real = 4'h8; b_imag = 4'h8;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h8, 4'h8, 4'h8, 4'h8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mixed Signs and Cancellation", test_num);
            reset_dut();
            a_real = 4'h3; a_imag = 4'h4;
            b_real = 4'h3; b_imag = 4'hC;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h0, 4'h6, 4'h8, 4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fft_2point Testbench");
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
        input [3:0] expected_y0_imag;
        input [3:0] expected_y0_real;
        input [3:0] expected_y1_imag;
        input [3:0] expected_y1_real;
        begin
            if (expected_y0_imag === (expected_y0_imag ^ y0_imag ^ expected_y0_imag) &&
                expected_y0_real === (expected_y0_real ^ y0_real ^ expected_y0_real) &&
                expected_y1_imag === (expected_y1_imag ^ y1_imag ^ expected_y1_imag) &&
                expected_y1_real === (expected_y1_real ^ y1_real ^ expected_y1_real)) begin
                $display("PASS");
                $display("  Outputs: y0_imag=%h, y0_real=%h, y1_imag=%h, y1_real=%h",
                         y0_imag, y0_real, y1_imag, y1_real);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y0_imag=%h, y0_real=%h, y1_imag=%h, y1_real=%h",
                         expected_y0_imag, expected_y0_real, expected_y1_imag, expected_y1_real);
                $display("  Got:      y0_imag=%h, y0_real=%h, y1_imag=%h, y1_real=%h",
                         y0_imag, y0_real, y1_imag, y1_real);
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
        $dumpvars(0,a_imag, a_real, b_imag, b_real, clk, rst, y0_imag, y0_real, y1_imag, y1_real);
    end

endmodule
