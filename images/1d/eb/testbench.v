`timescale 1ns/1ps

module bilinear_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Q11;
    reg [7:0] Q12;
    reg [7:0] Q21;
    reg [7:0] Q22;
    reg [7:0] x_frac;
    reg [7:0] y_frac;
    wire [7:0] interpolated_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bilinear_interpolation dut (
        .Q11(Q11),
        .Q12(Q12),
        .Q21(Q21),
        .Q22(Q22),
        .x_frac(x_frac),
        .y_frac(y_frac),
        .interpolated_pixel(interpolated_pixel)
    );
    task testcase001;

        begin
            test_num = 1;
            Q11 = 8'd100; Q12 = 8'd100; Q21 = 8'd100; Q22 = 8'd100;
            x_frac = 8'd50; y_frac = 8'd50;
            $display("Test %0d: Flat field - Expected: 100", test_num);
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            Q11 = 8'd255; Q12 = 8'd0; Q21 = 8'd0; Q22 = 8'd0;
            x_frac = 8'd0; y_frac = 8'd0;
            $display("Test %0d: Top-left corner - Expected: 255", test_num);
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            Q11 = 8'd0; Q12 = 8'd200; Q21 = 8'd0; Q22 = 8'd0;
            x_frac = 8'd255; y_frac = 8'd0;
            $display("Test %0d: Near Top-right edge - Expected: 199", test_num);
            #1;

            check_outputs(8'd199);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            Q11 = 8'd0; Q12 = 8'd255; Q21 = 8'd255; Q22 = 8'd0;
            x_frac = 8'd128; y_frac = 8'd128;
            $display("Test %0d: Exact Center - Expected: 128", test_num);
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            Q11 = 8'd50; Q12 = 8'd100; Q21 = 8'd150; Q22 = 8'd200;
            x_frac = 8'd64; y_frac = 8'd128;
            $display("Test %0d: Random Distribution - Expected: 113", test_num);
            #1;

            check_outputs(8'd113);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            Q11 = 8'd0; Q12 = 8'd0; Q21 = 8'd0; Q22 = 8'd255;
            x_frac = 8'd255; y_frac = 8'd255;
            $display("Test %0d: Near Bottom-right corner - Expected: 253", test_num);


            #1;



            check_outputs(8'd253);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            Q11 = 8'd100; Q12 = 8'd200; Q21 = 8'd0; Q22 = 8'd0;
            x_frac = 8'd128; y_frac = 8'd0;
            $display("Test %0d: Horizontal Midpoint - Expected: 150", test_num);
            #1;

            check_outputs(8'd150);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            Q11 = 8'd100; Q12 = 8'd0; Q21 = 8'd200; Q22 = 8'd0;
            x_frac = 8'd0; y_frac = 8'd128;
            $display("Test %0d: Vertical Midpoint - Expected: 150", test_num);
            #1;

            check_outputs(8'd150);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            Q11 = 8'd0; Q12 = 8'd1; Q21 = 8'd0; Q22 = 8'd0;
            x_frac = 8'd128; y_frac = 8'd0;
            $display("Test %0d: Rounding 0.5 up - Expected: 1", test_num);
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            Q11 = 8'd0; Q12 = 8'd1; Q21 = 8'd0; Q22 = 8'd0;
            x_frac = 8'd127; y_frac = 8'd0;
            $display("Test %0d: Rounding < 0.5 down - Expected: 0", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bilinear_interpolation Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [7:0] expected_interpolated_pixel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_interpolated_pixel === (expected_interpolated_pixel ^ interpolated_pixel ^ expected_interpolated_pixel)) begin
                $display("PASS");
                $display("  Outputs: interpolated_pixel=%h",
                         interpolated_pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: interpolated_pixel=%h",
                         expected_interpolated_pixel);
                $display("  Got:      interpolated_pixel=%h",
                         interpolated_pixel);
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
