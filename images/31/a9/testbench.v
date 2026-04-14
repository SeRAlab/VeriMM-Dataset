`timescale 1ns/1ps

module fft_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] imag_in1;
    reg [15:0] imag_in2;
    reg [15:0] real_in1;
    reg [15:0] real_in2;
    reg rst;
    wire [15:0] imag_out1;
    wire [15:0] imag_out2;
    wire [15:0] real_out1;
    wire [15:0] real_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft dut (
        .clk(clk),
        .imag_in1(imag_in1),
        .imag_in2(imag_in2),
        .real_in1(real_in1),
        .real_in2(real_in2),
        .rst(rst),
        .imag_out1(imag_out1),
        .imag_out2(imag_out2),
        .real_out1(real_out1),
        .real_out2(real_out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            real_in1 = 16'h0;
            imag_in1 = 16'h0;
            real_in2 = 16'h0;
            imag_in2 = 16'h0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Zero Inputs");
            reset_dut();
            real_in1 = 16'h0000;
            imag_in1 = 16'h0000;
            real_in2 = 16'h0000;
            imag_in2 = 16'h0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Simple Addition/Subtraction");
            reset_dut();
            real_in1 = 16'd10;
            imag_in1 = 16'd20;
            real_in2 = 16'd5;
            imag_in2 = 16'd5;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'd25, 16'd15, 16'd15, 16'd5);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Signed Arithmetic");
            reset_dut();
            real_in1 = 16'd100;
            imag_in1 = 16'd50;
            real_in2 = 16'd200;
            imag_in2 = 16'd150;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h00C8, 16'hFF9C, 16'h012C, 16'hFF9C);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Identity Property");
            reset_dut();
            real_in1 = 16'h1234;
            imag_in1 = 16'h5678;
            real_in2 = 16'h0000;
            imag_in2 = 16'h0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h5678, 16'h5678, 16'h1234, 16'h1234);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Large Value Signed Test");
            reset_dut();
            real_in1 = 16'h4000;
            imag_in1 = 16'h0000;
            real_in2 = 16'hC000;
            imag_in2 = 16'h0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h8000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fft Testbench");
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
        input [15:0] expected_imag_out1;
        input [15:0] expected_imag_out2;
        input [15:0] expected_real_out1;
        input [15:0] expected_real_out2;
        begin
            if (expected_imag_out1 === (expected_imag_out1 ^ imag_out1 ^ expected_imag_out1) &&
                expected_imag_out2 === (expected_imag_out2 ^ imag_out2 ^ expected_imag_out2) &&
                expected_real_out1 === (expected_real_out1 ^ real_out1 ^ expected_real_out1) &&
                expected_real_out2 === (expected_real_out2 ^ real_out2 ^ expected_real_out2)) begin
                $display("PASS");
                $display("  Outputs: imag_out1=%h, imag_out2=%h, real_out1=%h, real_out2=%h",
                         imag_out1, imag_out2, real_out1, real_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: imag_out1=%h, imag_out2=%h, real_out1=%h, real_out2=%h",
                         expected_imag_out1, expected_imag_out2, expected_real_out1, expected_real_out2);
                $display("  Got:      imag_out1=%h, imag_out2=%h, real_out1=%h, real_out2=%h",
                         imag_out1, imag_out2, real_out1, real_out2);
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
        $dumpvars(0,clk, imag_in1, imag_in2, real_in1, real_in2, rst, imag_out1, imag_out2, real_out1, real_out2);
    end

endmodule
