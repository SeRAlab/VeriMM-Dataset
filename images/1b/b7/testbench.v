`timescale 1ns/1ps

module IFFT_4point_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] imag_in_0;
    reg [7:0] imag_in_1;
    reg [7:0] imag_in_2;
    reg [7:0] imag_in_3;
    reg [7:0] real_in_0;
    reg [7:0] real_in_1;
    reg [7:0] real_in_2;
    reg [7:0] real_in_3;
    reg rst;
    wire [7:0] imag_out_0;
    wire [7:0] imag_out_1;
    wire [7:0] imag_out_2;
    wire [7:0] imag_out_3;
    wire [7:0] real_out_0;
    wire [7:0] real_out_1;
    wire [7:0] real_out_2;
    wire [7:0] real_out_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    IFFT_4point dut (
        .clk(clk),
        .imag_in_0(imag_in_0),
        .imag_in_1(imag_in_1),
        .imag_in_2(imag_in_2),
        .imag_in_3(imag_in_3),
        .real_in_0(real_in_0),
        .real_in_1(real_in_1),
        .real_in_2(real_in_2),
        .real_in_3(real_in_3),
        .rst(rst),
        .imag_out_0(imag_out_0),
        .imag_out_1(imag_out_1),
        .imag_out_2(imag_out_2),
        .imag_out_3(imag_out_3),
        .real_out_0(real_out_0),
        .real_out_1(real_out_1),
        .real_out_2(real_out_2),
        .real_out_3(real_out_3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            real_in_0 = 0; real_in_1 = 0; real_in_2 = 0; real_in_3 = 0;
            imag_in_0 = 0; imag_in_1 = 0; imag_in_2 = 0; imag_in_3 = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: All Zeros");
            reset_dut();
            real_in_0 = 8'h00; real_in_1 = 8'h00; real_in_2 = 8'h00; real_in_3 = 8'h00;
            imag_in_0 = 8'h00; imag_in_1 = 8'h00; imag_in_2 = 8'h00; imag_in_3 = 8'h00;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: DC Component");
            reset_dut();
            real_in_0 = 8'd32; real_in_1 = 8'd0; real_in_2 = 8'd0; real_in_3 = 8'd0;
            imag_in_0 = 8'd0;  imag_in_1 = 8'd0; imag_in_2 = 8'd0; imag_in_3 = 8'd0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h08, 8'h08, 8'h08, 8'h08);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Nyquist Frequency");
            reset_dut();
            real_in_0 = 8'd0; real_in_1 = 8'd0; real_in_2 = 8'd32; real_in_3 = 8'd0;
            imag_in_0 = 8'd0; imag_in_1 = 8'd0; imag_in_2 = 8'd0;  imag_in_3 = 8'd0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h08, 8'hF8, 8'h08, 8'hF8);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Pure Imaginary Rotation");
            reset_dut();
            real_in_0 = 8'h00; real_in_1 = 8'h00; real_in_2 = 8'h00; real_in_3 = 8'h00;
            imag_in_0 = 8'd0;  imag_in_1 = 8'd32; imag_in_2 = 8'd0;  imag_in_3 = 8'shE0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hF0, 8'h00, 8'h10);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Full Constant Bin Vector");
            reset_dut();
            real_in_0 = 8'd16; real_in_1 = 8'd16; real_in_2 = 8'd16; real_in_3 = 8'd16;
            imag_in_0 = 8'd0;  imag_in_1 = 8'd0;  imag_in_2 = 8'd0;  imag_in_3 = 8'd0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h10, 8'h00, 8'h00, 8'h00);
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
        input [7:0] expected_imag_out_0;
        input [7:0] expected_imag_out_1;
        input [7:0] expected_imag_out_2;
        input [7:0] expected_imag_out_3;
        input [7:0] expected_real_out_0;
        input [7:0] expected_real_out_1;
        input [7:0] expected_real_out_2;
        input [7:0] expected_real_out_3;
        begin
            if (expected_imag_out_0 === (expected_imag_out_0 ^ imag_out_0 ^ expected_imag_out_0) &&
                expected_imag_out_1 === (expected_imag_out_1 ^ imag_out_1 ^ expected_imag_out_1) &&
                expected_imag_out_2 === (expected_imag_out_2 ^ imag_out_2 ^ expected_imag_out_2) &&
                expected_imag_out_3 === (expected_imag_out_3 ^ imag_out_3 ^ expected_imag_out_3) &&
                expected_real_out_0 === (expected_real_out_0 ^ real_out_0 ^ expected_real_out_0) &&
                expected_real_out_1 === (expected_real_out_1 ^ real_out_1 ^ expected_real_out_1) &&
                expected_real_out_2 === (expected_real_out_2 ^ real_out_2 ^ expected_real_out_2) &&
                expected_real_out_3 === (expected_real_out_3 ^ real_out_3 ^ expected_real_out_3)) begin
                $display("PASS");
                $display("  Outputs: imag_out_0=%h, imag_out_1=%h, imag_out_2=%h, imag_out_3=%h, real_out_0=%h, real_out_1=%h, real_out_2=%h, real_out_3=%h",
                         imag_out_0, imag_out_1, imag_out_2, imag_out_3, real_out_0, real_out_1, real_out_2, real_out_3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: imag_out_0=%h, imag_out_1=%h, imag_out_2=%h, imag_out_3=%h, real_out_0=%h, real_out_1=%h, real_out_2=%h, real_out_3=%h",
                         expected_imag_out_0, expected_imag_out_1, expected_imag_out_2, expected_imag_out_3, expected_real_out_0, expected_real_out_1, expected_real_out_2, expected_real_out_3);
                $display("  Got:      imag_out_0=%h, imag_out_1=%h, imag_out_2=%h, imag_out_3=%h, real_out_0=%h, real_out_1=%h, real_out_2=%h, real_out_3=%h",
                         imag_out_0, imag_out_1, imag_out_2, imag_out_3, real_out_0, real_out_1, real_out_2, real_out_3);
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
        $dumpvars(0,clk, imag_in_0, imag_in_1, imag_in_2, imag_in_3, real_in_0, real_in_1, real_in_2, real_in_3, rst, imag_out_0, imag_out_1, imag_out_2, imag_out_3, real_out_0, real_out_1, real_out_2, real_out_3);
    end

endmodule
