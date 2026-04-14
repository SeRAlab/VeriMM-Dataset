`timescale 1ns/1ps

module fft_butterfly_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a_imag;
    reg [7:0] a_real;
    reg [7:0] b_imag;
    reg [7:0] b_real;
    reg clk;
    wire [7:0] out1_imag;
    wire [7:0] out1_real;
    wire [7:0] out2_imag;
    wire [7:0] out2_real;

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
        .out1_imag(out1_imag),
        .out1_real(out1_real),
        .out2_imag(out2_imag),
        .out2_real(out2_real)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a_imag = 0;
            a_real = 0;
            b_imag = 0;
            b_real = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Positive Values", test_num);
            reset_dut();
            a_real = 8'sd10; a_imag = 8'sd5;
            b_real = 8'sd4;  b_imag = 8'sd2;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'sd7, 8'sd14, 8'sd3, 8'sd6);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed Signs", test_num);
            reset_dut();
            a_real = -8'sd20; a_imag = -8'sd10;
            b_real = 8'sd15;  b_imag = -8'sd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(-8'sd15, -8'sd5, -8'sd5, -8'sd35);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Inputs", test_num);
            reset_dut();
            a_real = 8'sd0; a_imag = 8'sd0;
            b_real = 8'sd0; b_imag = 8'sd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identity (B=0)", test_num);
            reset_dut();
            a_real = 8'sd50; a_imag = 8'sd50;
            b_real = 8'sd0;  b_imag = 8'sd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'sd50, 8'sd50, 8'sd50, 8'sd50);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Values", test_num);
            reset_dut();
            a_real = 8'sd60;  a_imag = 8'sd60;
            b_real = -8'sd60; b_imag = -8'sd60;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'sd0, 8'sd0, 8'sd120, 8'sd120);
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
        input [7:0] expected_out1_imag;
        input [7:0] expected_out1_real;
        input [7:0] expected_out2_imag;
        input [7:0] expected_out2_real;
        begin
            if (expected_out1_imag === (expected_out1_imag ^ out1_imag ^ expected_out1_imag) &&
                expected_out1_real === (expected_out1_real ^ out1_real ^ expected_out1_real) &&
                expected_out2_imag === (expected_out2_imag ^ out2_imag ^ expected_out2_imag) &&
                expected_out2_real === (expected_out2_real ^ out2_real ^ expected_out2_real)) begin
                $display("PASS");
                $display("  Outputs: out1_imag=%h, out1_real=%h, out2_imag=%h, out2_real=%h",
                         out1_imag, out1_real, out2_imag, out2_real);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1_imag=%h, out1_real=%h, out2_imag=%h, out2_real=%h",
                         expected_out1_imag, expected_out1_real, expected_out2_imag, expected_out2_real);
                $display("  Got:      out1_imag=%h, out1_real=%h, out2_imag=%h, out2_real=%h",
                         out1_imag, out1_real, out2_imag, out2_real);
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
        $dumpvars(0,a_imag, a_real, b_imag, b_real, clk, out1_imag, out1_real, out2_imag, out2_real);
    end

endmodule
