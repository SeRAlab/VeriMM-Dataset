`timescale 1ns/1ps

module fft_4point_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x0_imag;
    reg [7:0] x0_real;
    reg [7:0] x1_imag;
    reg [7:0] x1_real;
    reg [7:0] x2_imag;
    reg [7:0] x2_real;
    reg [7:0] x3_imag;
    reg [7:0] x3_real;
    wire [7:0] y0_imag;
    wire [7:0] y0_real;
    wire [7:0] y1_imag;
    wire [7:0] y1_real;
    wire [7:0] y2_imag;
    wire [7:0] y2_real;
    wire [7:0] y3_imag;
    wire [7:0] y3_real;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_4point dut (
        .x0_imag(x0_imag),
        .x0_real(x0_real),
        .x1_imag(x1_imag),
        .x1_real(x1_real),
        .x2_imag(x2_imag),
        .x2_real(x2_real),
        .x3_imag(x3_imag),
        .x3_real(x3_real),
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
            $display("\nTest Case %0d: Impulse signal at x0", test_num);
            x0_real = 8'h01; x0_imag = 8'h00;
            x1_real = 8'h00; x1_imag = 8'h00;
            x2_real = 8'h00; x2_imag = 8'h00;
            x3_real = 8'h00; x3_imag = 8'h00;

            #1;


            check_outputs(8'h00, 8'h01, 8'h00, 8'h01, 8'h00, 8'h01, 8'h00, 8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: DC Signal (Real)", test_num);
            x0_real = 8'h02; x0_imag = 8'h00;
            x1_real = 8'h02; x1_imag = 8'h00;
            x2_real = 8'h02; x2_imag = 8'h00;
            x3_real = 8'h02; x3_imag = 8'h00;

            #1;


            check_outputs(8'h00, 8'h08, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: DC Signal (Complex)", test_num);
            x0_real = 8'h01; x0_imag = 8'h01;
            x1_real = 8'h01; x1_imag = 8'h01;
            x2_real = 8'h01; x2_imag = 8'h01;
            x3_real = 8'h01; x3_imag = 8'h01;

            #1;


            check_outputs(8'h04, 8'h04, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Nyquist Frequency Signal", test_num);
            x0_real = 8'h01; x0_imag = 8'h00;
            x1_real = 8'hFF; x1_imag = 8'h00;
            x2_real = 8'h01; x2_imag = 8'h00;
            x3_real = 8'hFF; x3_imag = 8'h00;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h04, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pure Imaginary Frequency Component", test_num);
            x0_real = 8'h00; x0_imag = 8'h00;
            x1_real = 8'h01; x1_imag = 8'h00;
            x2_real = 8'h00; x2_imag = 8'h00;
            x3_real = 8'hFF; x3_imag = 8'h00;

            #1;


            check_outputs(8'h00, 8'h00, 8'hFE, 8'h00, 8'h00, 8'h00, 8'h02, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Input", test_num);
            x0_real = 8'h00; x0_imag = 8'h00;
            x1_real = 8'h00; x1_imag = 8'h00;
            x2_real = 8'h00; x2_imag = 8'h00;
            x3_real = 8'h00; x3_imag = 8'h00;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative DC Signal", test_num);
            x0_real = 8'hFF; x0_imag = 8'h00;
            x1_real = 8'hFF; x1_imag = 8'h00;
            x2_real = 8'hFF; x2_imag = 8'h00;
            x3_real = 8'hFF; x3_imag = 8'h00;
            #1;

            check_outputs(8'h00, 8'hFC, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Arbitrary Complex Values", test_num);
            x0_real = 8'h01; x0_imag = 8'h02;
            x1_real = 8'h03; x1_imag = 8'h04;
            x2_real = 8'h05; x2_imag = 8'h06;
            x3_real = 8'h07; x3_imag = 8'h08;

            #1;


            check_outputs(8'h14, 8'h10, 8'h00, 8'hF8, 8'hFC, 8'hFC, 8'hF8, 8'h00);
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
        input [7:0] expected_y0_imag;
        input [7:0] expected_y0_real;
        input [7:0] expected_y1_imag;
        input [7:0] expected_y1_real;
        input [7:0] expected_y2_imag;
        input [7:0] expected_y2_real;
        input [7:0] expected_y3_imag;
        input [7:0] expected_y3_real;
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
