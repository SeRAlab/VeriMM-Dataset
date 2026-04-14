`timescale 1ns/1ps

module fft_4_point_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x0_imag;
    reg [7:0] x0_real;
    reg [7:0] x1_imag;
    reg [7:0] x1_real;
    reg [7:0] x2_imag;
    reg [7:0] x2_real;
    reg [7:0] x3_imag;
    reg [7:0] x3_real;
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
            $display("\nTest Case %0d: Unit Impulse x[0]=1", test_num);

            x0_real = 8'sd1;   x0_imag = 8'sd0;
            x1_real = 8'sd0;   x1_imag = 8'sd0;
            x2_real = 8'sd0;   x2_imag = 8'sd0;
            x3_real = 8'sd0;   x3_imag = 8'sd0;

            #1;


            check_outputs(16'h0000, 16'h0001, 16'h0000, 16'h0001, 16'h0000, 16'h0001, 16'h0000, 16'h0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Constant DC Signal x[n]=1", test_num);

            x0_real = 8'sd1;   x0_imag = 8'sd0;
            x1_real = 8'sd1;   x1_imag = 8'sd0;
            x2_real = 8'sd1;   x2_imag = 8'sd0;
            x3_real = 8'sd1;   x3_imag = 8'sd0;

            #1;


            check_outputs(16'h0000, 16'h0004, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Complex Sinusoid k=1", test_num);

            x0_real = 8'sd1;   x0_imag = 8'sd0;
            x1_real = 8'sd0;   x1_imag = 8'sd1;
            x2_real = -8'sd1;  x2_imag = 8'sd0;
            x3_real = 8'sd0;   x3_imag = -8'sd1;

            #1;


            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0004, 16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Real Ramp x = [10, 20, 30, 40]", test_num);
            x0_real = 8'sd10;  x0_imag = 8'sd0;
            x1_real = 8'sd20;  x1_imag = 8'sd0;
            x2_real = 8'sd30;  x2_imag = 8'sd0;
            x3_real = 8'sd40;  x3_imag = 8'sd0;





            #1;






            check_outputs(16'h0000, 16'h0064, 16'h0014, 16'hFFEC, 16'h0000, 16'hFFEC, 16'hFFEC, 16'hFFEC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Arbitrary Complex Inputs", test_num);

            x0_real = 8'sd10;  x0_imag = 8'sd5;
            x1_real = -8'sd5;  x1_imag = 8'sd10;
            x2_real = 8'sd2;   x2_imag = -8'sd8;
            x3_real = -8'sd4;  x3_imag = -8'sd2;





            #1;






            check_outputs(16'h0005, 16'h0003, 16'h000E, 16'h0014, 16'hFFF5, 16'h0015, 16'h000C, 16'hFFFC);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Positive Range", test_num);
            x0_real = 8'sd127; x0_imag = 8'sd0;
            x1_real = 8'sd127; x1_imag = 8'sd0;
            x2_real = 8'sd127; x2_imag = 8'sd0;
            x3_real = 8'sd127; x3_imag = 8'sd0;

            #1;


            check_outputs(16'h0000, 16'h01FC, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Negative Range", test_num);
            x0_real = -8'sd128; x0_imag = 8'sd0;
            x1_real = -8'sd128; x1_imag = 8'sd0;
            x2_real = -8'sd128; x2_imag = 8'sd0;
            x3_real = -8'sd128; x3_imag = 8'sd0;

            #1;


            check_outputs(16'h0000, 16'hFE00, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000);
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
        testcase006();
        testcase007();
        
        
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
