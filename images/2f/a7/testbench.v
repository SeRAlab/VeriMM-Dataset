`timescale 1ns/1ps

module fft_4_point_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a_imag;
    reg [15:0] a_real;
    reg [15:0] b_imag;
    reg [15:0] b_real;
    reg [15:0] c_imag;
    reg [15:0] c_real;
    reg [15:0] d_imag;
    reg [15:0] d_real;
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
    fft_4_point dut (
        .a_imag(a_imag),
        .a_real(a_real),
        .b_imag(b_imag),
        .b_real(b_real),
        .c_imag(c_imag),
        .c_real(c_real),
        .d_imag(d_imag),
        .d_real(d_real),
        .y0_imag(y0_imag),
        .y0_real(y0_real),
        .y1_imag(y1_imag),
        .y1_real(y1_real),
        .y2_imag(y2_imag),
        .y2_real(y2_real),
        .y3_imag(y3_imag),
        .y3_real(y3_real)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: DC Signal (All Real 1s)", test_num);
            a_real = 16'h0001; a_imag = 16'h0000;
            b_real = 16'h0001; b_imag = 16'h0000;
            c_real = 16'h0001; c_imag = 16'h0000;
            d_real = 16'h0001; d_imag = 16'h0000;
            #1;

            check_outputs(16'h0000, 16'h0004, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Impulse at x[0]", test_num);
            a_real = 16'h0004; a_imag = 16'h0000;
            b_real = 16'h0000; b_imag = 16'h0000;
            c_real = 16'h0000; c_imag = 16'h0000;
            d_real = 16'h0000; d_imag = 16'h0000;
            #1;

            check_outputs(16'h0000, 16'h0004, 16'h0000, 16'h0004, 16'h0000, 16'h0004, 16'h0000, 16'h0004);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complex Ramp [1+1j, 2+2j, 3+3j, 4+4j]", test_num);
            a_real = 16'h0001; a_imag = 16'h0001;
            b_real = 16'h0002; b_imag = 16'h0002;
            c_real = 16'h0003; c_imag = 16'h0003;
            d_real = 16'h0004; d_imag = 16'h0004;
            #1;

            check_outputs(
                16'h000a, 16'h000a,
                16'h0000, 16'hfffc,
                16'hfffe, 16'hfffe,
                16'hfffc, 16'h0000
            );
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pure Imaginary DC Signal", test_num);
            a_real = 16'h0000; a_imag = 16'h0002;
            b_real = 16'h0000; b_imag = 16'h0002;
            c_real = 16'h0000; c_imag = 16'h0002;
            d_real = 16'h0000; d_imag = 16'h0002;
            #1;

            check_outputs(16'h0008, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Rotating Phasor (Bin 1)", test_num);
            a_real = 16'h000a; a_imag = 16'h0000;
            b_real = 16'h0000; b_imag = 16'h000a;
            c_real = 16'hfff6; c_imag = 16'h0000;
            d_real = 16'h0000; d_imag = 16'hfff6;
            #1;

            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0028, 16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fft_4_point Testbench");
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
            #1; // Small delay for combinational logic to settle
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

endmodule
