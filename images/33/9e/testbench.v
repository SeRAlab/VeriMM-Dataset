`timescale 1ns/1ps

module fft_4point_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x0_im;
    reg [7:0] x0_re;
    reg [7:0] x1_im;
    reg [7:0] x1_re;
    reg [7:0] x2_im;
    reg [7:0] x2_re;
    reg [7:0] x3_im;
    reg [7:0] x3_re;
    wire [7:0] y0_im;
    wire [7:0] y0_re;
    wire [7:0] y1_im;
    wire [7:0] y1_re;
    wire [7:0] y2_im;
    wire [7:0] y2_re;
    wire [7:0] y3_im;
    wire [7:0] y3_re;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_4point dut (
        .x0_im(x0_im),
        .x0_re(x0_re),
        .x1_im(x1_im),
        .x1_re(x1_re),
        .x2_im(x2_im),
        .x2_re(x2_re),
        .x3_im(x3_im),
        .x3_re(x3_re),
        .y0_im(y0_im),
        .y0_re(y0_re),
        .y1_im(y1_im),
        .y1_re(y1_re),
        .y2_im(y2_im),
        .y2_re(y2_re),
        .y3_im(y3_im),
        .y3_re(y3_re)
    );
    task testcase001;

        begin
            test_num = 1;
            x0_re = 8'h00; x0_im = 8'h00;
            x1_re = 8'h00; x1_im = 8'h00;
            x2_re = 8'h00; x2_im = 8'h00;
            x3_re = 8'h00; x3_im = 8'h00;
            $display("Test Case 001: All Zeros");
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            x0_re = 8'h01; x0_im = 8'h00;
            x1_re = 8'h00; x1_im = 8'h00;
            x2_re = 8'h00; x2_im = 8'h00;
            x3_re = 8'h00; x3_im = 8'h00;
            $display("Test Case 002: Unit Impulse at x0");
            #1;

            check_outputs(8'h00, 8'h01, 8'h00, 8'h01, 8'h00, 8'h01, 8'h00, 8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            x0_re = 8'h01; x0_im = 8'h00;
            x1_re = 8'h01; x1_im = 8'h00;
            x2_re = 8'h01; x2_im = 8'h00;
            x3_re = 8'h01; x3_im = 8'h00;
            $display("Test Case 003: DC Signal (1,1,1,1)");
            #1;

            check_outputs(8'h00, 8'h04, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            x0_re = 8'h01; x0_im = 8'h00;
            x1_re = 8'hFF; x1_im = 8'h00;
            x2_re = 8'h01; x2_im = 8'h00;
            x3_re = 8'hFF; x3_im = 8'h00;
            $display("Test Case 004: Alternating Signal (1,-1,1,-1)");
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h04, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            x0_re = 8'h01; x0_im = 8'h00;
            x1_re = 8'h00; x1_im = 8'h01;
            x2_re = 8'hFF; x2_im = 8'h00;
            x3_re = 8'h00; x3_im = 8'hFF;
            $display("Test Case 005: Positive Frequency (1, j, -1, -j)");
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h04, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            x0_re = 8'h01; x0_im = 8'h00;
            x1_re = 8'h00; x1_im = 8'hFF;
            x2_re = 8'hFF; x2_im = 8'h00;
            x3_re = 8'h00; x3_im = 8'h01;
            $display("Test Case 006: Negative Frequency (1, -j, -1, j)");
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h04);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            x0_re = 8'h01; x0_im = 8'h01;
            x1_re = 8'h01; x1_im = 8'h01;
            x2_re = 8'h01; x2_im = 8'h01;
            x3_re = 8'h01; x3_im = 8'h01;
            $display("Test Case 007: Complex DC (1+j, 1+j, 1+j, 1+j)");
            #1;

            check_outputs(8'h04, 8'h04, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            x0_re = 8'h01; x0_im = 8'h00;
            x1_re = 8'h02; x1_im = 8'h00;
            x2_re = 8'h03; x2_im = 8'h00;
            x3_re = 8'h04; x3_im = 8'h00;
            $display("Test Case 008: Real Pattern (1, 2, 3, 4)");
            #1;

            check_outputs(8'h00, 8'h0A, 8'h02, 8'hFE, 8'h00, 8'hFE, 8'hFE, 8'hFE);
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
        input [7:0] expected_y0_im;
        input [7:0] expected_y0_re;
        input [7:0] expected_y1_im;
        input [7:0] expected_y1_re;
        input [7:0] expected_y2_im;
        input [7:0] expected_y2_re;
        input [7:0] expected_y3_im;
        input [7:0] expected_y3_re;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y0_im === (expected_y0_im ^ y0_im ^ expected_y0_im) &&
                expected_y0_re === (expected_y0_re ^ y0_re ^ expected_y0_re) &&
                expected_y1_im === (expected_y1_im ^ y1_im ^ expected_y1_im) &&
                expected_y1_re === (expected_y1_re ^ y1_re ^ expected_y1_re) &&
                expected_y2_im === (expected_y2_im ^ y2_im ^ expected_y2_im) &&
                expected_y2_re === (expected_y2_re ^ y2_re ^ expected_y2_re) &&
                expected_y3_im === (expected_y3_im ^ y3_im ^ expected_y3_im) &&
                expected_y3_re === (expected_y3_re ^ y3_re ^ expected_y3_re)) begin
                $display("PASS");
                $display("  Outputs: y0_im=%h, y0_re=%h, y1_im=%h, y1_re=%h, y2_im=%h, y2_re=%h, y3_im=%h, y3_re=%h",
                         y0_im, y0_re, y1_im, y1_re, y2_im, y2_re, y3_im, y3_re);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y0_im=%h, y0_re=%h, y1_im=%h, y1_re=%h, y2_im=%h, y2_re=%h, y3_im=%h, y3_re=%h",
                         expected_y0_im, expected_y0_re, expected_y1_im, expected_y1_re, expected_y2_im, expected_y2_re, expected_y3_im, expected_y3_re);
                $display("  Got:      y0_im=%h, y0_re=%h, y1_im=%h, y1_re=%h, y2_im=%h, y2_re=%h, y3_im=%h, y3_re=%h",
                         y0_im, y0_re, y1_im, y1_re, y2_im, y2_re, y3_im, y3_re);
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
