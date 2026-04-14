`timescale 1ns/1ps

module fft_4point_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a_imag;
    reg [3:0] a_real;
    reg [3:0] b_imag;
    reg [3:0] b_real;
    reg [3:0] c_imag;
    reg [3:0] c_real;
    reg [3:0] d_imag;
    reg [3:0] d_real;
    wire [3:0] out1_imag;
    wire [3:0] out1_real;
    wire [3:0] out2_imag;
    wire [3:0] out2_real;
    wire [3:0] out3_imag;
    wire [3:0] out3_real;
    wire [3:0] out4_imag;
    wire [3:0] out4_real;

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
        .d_imag(d_imag),
        .d_real(d_real),
        .out1_imag(out1_imag),
        .out1_real(out1_real),
        .out2_imag(out2_imag),
        .out2_real(out2_real),
        .out3_imag(out3_imag),
        .out3_real(out3_real),
        .out4_imag(out4_imag),
        .out4_real(out4_real)
    );
    task testcase001;

        begin
            $display("Test Case 001: All Zeros");
            test_num = 1;
            a_real = 4'h0; a_imag = 4'h0;
            b_real = 4'h0; b_imag = 4'h0;
            c_real = 4'h0; c_imag = 4'h0;
            d_real = 4'h0; d_imag = 4'h0;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Real Impulse at x[0]");
            test_num = 2;
            a_real = 4'h1; a_imag = 4'h0;
            b_real = 4'h0; b_imag = 4'h0;
            c_real = 4'h0; c_imag = 4'h0;
            d_real = 4'h0; d_imag = 4'h0;

            #1;


            check_outputs(4'h0, 4'h1, 4'h0, 4'h1, 4'h0, 4'h1, 4'h0, 4'h1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: DC Real Signal (all 1s)");
            test_num = 3;
            a_real = 4'h1; a_imag = 4'h0;
            b_real = 4'h1; b_imag = 4'h0;
            c_real = 4'h1; c_imag = 4'h0;
            d_real = 4'h1; d_imag = 4'h0;

            #1;


            check_outputs(4'h0, 4'h4, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: DC Imaginary Signal (all j)");
            test_num = 4;
            a_real = 4'h0; a_imag = 4'h1;
            b_real = 4'h0; b_imag = 4'h1;
            c_real = 4'h0; c_imag = 4'h1;
            d_real = 4'h0; d_imag = 4'h1;

            #1;


            check_outputs(4'h4, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Real Sine Wave (1, 0, -1, 0)");
            test_num = 5;
            a_real = 4'h1; a_imag = 4'h0;
            b_real = 4'h0; b_imag = 4'h0;
            c_real = 4'hF; c_imag = 4'h0;
            d_real = 4'h0; d_imag = 4'h0;

            #1;


            check_outputs(4'h0, 4'h0, 4'h0, 4'h2, 4'h0, 4'h0, 4'h0, 4'h2);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Shifted Real Impulse at x[1]");
            test_num = 6;
            a_real = 4'h0; a_imag = 4'h0;
            b_real = 4'h1; b_imag = 4'h0;
            c_real = 4'h0; c_imag = 4'h0;
            d_real = 4'h0; d_imag = 4'h0;

            #1;


            check_outputs(4'h0, 4'h1, 4'hF, 4'h0, 4'h0, 4'hF, 4'h1, 4'h0);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Saturation/Overflow Check (DC 7)");
            test_num = 7;
            a_real = 4'h7; a_imag = 4'h0;
            b_real = 4'h7; b_imag = 4'h0;
            c_real = 4'h7; c_imag = 4'h0;
            d_real = 4'h7; d_imag = 4'h0;

            #1;


            check_outputs(4'h0, 4'hC, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Complex Mixed Signal");
            test_num = 8;
            a_real = 4'h1; a_imag = 4'h1;
            b_real = 4'h1; b_imag = 4'hF;
            c_real = 4'hF; c_imag = 4'hF;
            d_real = 4'hF; d_imag = 4'h1;

            #1;


            check_outputs(4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h4, 4'h4);
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
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [3:0] expected_out1_imag;
        input [3:0] expected_out1_real;
        input [3:0] expected_out2_imag;
        input [3:0] expected_out2_real;
        input [3:0] expected_out3_imag;
        input [3:0] expected_out3_real;
        input [3:0] expected_out4_imag;
        input [3:0] expected_out4_real;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1_imag === (expected_out1_imag ^ out1_imag ^ expected_out1_imag) &&
                expected_out1_real === (expected_out1_real ^ out1_real ^ expected_out1_real) &&
                expected_out2_imag === (expected_out2_imag ^ out2_imag ^ expected_out2_imag) &&
                expected_out2_real === (expected_out2_real ^ out2_real ^ expected_out2_real) &&
                expected_out3_imag === (expected_out3_imag ^ out3_imag ^ expected_out3_imag) &&
                expected_out3_real === (expected_out3_real ^ out3_real ^ expected_out3_real) &&
                expected_out4_imag === (expected_out4_imag ^ out4_imag ^ expected_out4_imag) &&
                expected_out4_real === (expected_out4_real ^ out4_real ^ expected_out4_real)) begin
                $display("PASS");
                $display("  Outputs: out1_imag=%h, out1_real=%h, out2_imag=%h, out2_real=%h, out3_imag=%h, out3_real=%h, out4_imag=%h, out4_real=%h",
                         out1_imag, out1_real, out2_imag, out2_real, out3_imag, out3_real, out4_imag, out4_real);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1_imag=%h, out1_real=%h, out2_imag=%h, out2_real=%h, out3_imag=%h, out3_real=%h, out4_imag=%h, out4_real=%h",
                         expected_out1_imag, expected_out1_real, expected_out2_imag, expected_out2_real, expected_out3_imag, expected_out3_real, expected_out4_imag, expected_out4_real);
                $display("  Got:      out1_imag=%h, out1_real=%h, out2_imag=%h, out2_real=%h, out3_imag=%h, out3_real=%h, out4_imag=%h, out4_real=%h",
                         out1_imag, out1_real, out2_imag, out2_real, out3_imag, out3_real, out4_imag, out4_real);
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

endmodule
