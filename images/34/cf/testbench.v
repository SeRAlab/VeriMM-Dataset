`timescale 1ns/1ps

module IFFT_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] imag_in_0;
    reg [3:0] imag_in_1;
    reg [3:0] imag_in_2;
    reg [3:0] imag_in_3;
    reg [3:0] real_in_0;
    reg [3:0] real_in_1;
    reg [3:0] real_in_2;
    reg [3:0] real_in_3;
    reg rst;
    wire [3:0] imag_out_0;
    wire [3:0] imag_out_1;
    wire [3:0] imag_out_2;
    wire [3:0] imag_out_3;
    wire [3:0] real_out_0;
    wire [3:0] real_out_1;
    wire [3:0] real_out_2;
    wire [3:0] real_out_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    IFFT dut (
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
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            real_in_0 = 4'h0; real_in_1 = 4'h0; real_in_2 = 4'h0; real_in_3 = 4'h0;
            imag_in_0 = 4'h0; imag_in_1 = 4'h0; imag_in_2 = 4'h0; imag_in_3 = 4'h0;
            repeat(2) @(posedge clk);
            #1;
            $display("Test Case %0d: All Zeros", test_num);
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            real_in_0 = 4'h4; real_in_1 = 4'h0; real_in_2 = 4'h0; real_in_3 = 4'h0;
            imag_in_0 = 4'h0; imag_in_1 = 4'h0; imag_in_2 = 4'h0; imag_in_3 = 4'h0;
            repeat(2) @(posedge clk);
            #1;
            $display("Test Case %0d: DC Component (Real)", test_num);
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'h0, 4'h1, 4'h1, 4'h1, 4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            real_in_0 = 4'h4; real_in_1 = 4'h4; real_in_2 = 4'h4; real_in_3 = 4'h4;
            imag_in_0 = 4'h0; imag_in_1 = 4'h0; imag_in_2 = 4'h0; imag_in_3 = 4'h0;
            repeat(2) @(posedge clk);
            #1;
            $display("Test Case %0d: Time Domain Impulse at n=0", test_num);
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'h0, 4'h4, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            real_in_0 = 4'h0; real_in_1 = 4'h4; real_in_2 = 4'h0; real_in_3 = 4'h0;
            imag_in_0 = 4'h0; imag_in_1 = 4'h0; imag_in_2 = 4'h0; imag_in_3 = 4'h0;
            repeat(2) @(posedge clk);
            #1;
            $display("Test Case %0d: Frequency Phase Shift", test_num);
            #1;

            check_outputs(4'h0, 4'h1, 4'h0, 4'hF, 4'h1, 4'h0, 4'hF, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            real_in_0 = 4'hC; real_in_1 = 4'h0; real_in_2 = 4'h0; real_in_3 = 4'h0;
            imag_in_0 = 4'h0; imag_in_1 = 4'h0; imag_in_2 = 4'h0; imag_in_3 = 4'h0;
            repeat(2) @(posedge clk);
            #1;
            $display("Test Case %0d: Negative DC Component", test_num);
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'h0, 4'hF, 4'hF, 4'hF, 4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            real_in_0 = 4'h0; real_in_1 = 4'h0; real_in_2 = 4'h4; real_in_3 = 4'h0;
            imag_in_0 = 4'h0; imag_in_1 = 4'h0; imag_in_2 = 4'h0; imag_in_3 = 4'h0;
            repeat(2) @(posedge clk);
            #1;
            $display("Test Case %0d: High Frequency Component", test_num);
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'h0, 4'h1, 4'hF, 4'h1, 4'hF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("IFFT Testbench");
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
        input [3:0] expected_imag_out_0;
        input [3:0] expected_imag_out_1;
        input [3:0] expected_imag_out_2;
        input [3:0] expected_imag_out_3;
        input [3:0] expected_real_out_0;
        input [3:0] expected_real_out_1;
        input [3:0] expected_real_out_2;
        input [3:0] expected_real_out_3;
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
