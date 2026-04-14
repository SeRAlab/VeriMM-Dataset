`timescale 1ns/1ps

module nearest_neighbor_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_00;
    reg [7:0] pixel_01;
    reg [7:0] pixel_10;
    reg [7:0] pixel_11;
    wire [7:0] pixel_00_out;
    wire [7:0] pixel_01_out;
    wire [7:0] pixel_10_out;
    wire [7:0] pixel_11_out;
    wire [7:0] pixel_20_out;
    wire [7:0] pixel_21_out;
    wire [7:0] pixel_30_out;
    wire [7:0] pixel_31_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nearest_neighbor_interpolation dut (
        .pixel_00(pixel_00),
        .pixel_01(pixel_01),
        .pixel_10(pixel_10),
        .pixel_11(pixel_11),
        .pixel_00_out(pixel_00_out),
        .pixel_01_out(pixel_01_out),
        .pixel_10_out(pixel_10_out),
        .pixel_11_out(pixel_11_out),
        .pixel_20_out(pixel_20_out),
        .pixel_21_out(pixel_21_out),
        .pixel_30_out(pixel_30_out),
        .pixel_31_out(pixel_31_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            pixel_00 = 8'h00;
            pixel_01 = 8'h00;
            pixel_10 = 8'h00;
            pixel_11 = 8'h00;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: All Max (0xFF)", test_num);
            pixel_00 = 8'hFF;
            pixel_01 = 8'hFF;
            pixel_10 = 8'hFF;
            pixel_11 = 8'hFF;

            #1;


            check_outputs(8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Discrete Input Values", test_num);
            pixel_00 = 8'hA1;
            pixel_01 = 8'hB2;
            pixel_10 = 8'hC3;
            pixel_11 = 8'hD4;



            #1;




            check_outputs(8'hA1, 8'hA1, 8'hA1, 8'hA1, 8'hC3, 8'hC3, 8'hC3, 8'hC3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Checkerboard Pattern", test_num);
            pixel_00 = 8'h55;
            pixel_01 = 8'hAA;
            pixel_10 = 8'hAA;
            pixel_11 = 8'h55;

            #1;


            check_outputs(8'h55, 8'h55, 8'h55, 8'h55, 8'hAA, 8'hAA, 8'hAA, 8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Grayscale Gradient", test_num);
            pixel_00 = 8'h10;
            pixel_01 = 8'h40;
            pixel_10 = 8'h80;
            pixel_11 = 8'hC0;

            #1;


            check_outputs(8'h10, 8'h10, 8'h10, 8'h10, 8'h80, 8'h80, 8'h80, 8'h80);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Bit Pattern 0xOF/0xF0", test_num);
            pixel_00 = 8'h0F;
            pixel_01 = 8'hF0;
            pixel_10 = 8'hF0;
            pixel_11 = 8'h0F;
            #1;

            check_outputs(8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'hF0, 8'hF0, 8'hF0, 8'hF0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nearest_neighbor_interpolation Testbench");
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
        input [7:0] expected_pixel_00_out;
        input [7:0] expected_pixel_01_out;
        input [7:0] expected_pixel_10_out;
        input [7:0] expected_pixel_11_out;
        input [7:0] expected_pixel_20_out;
        input [7:0] expected_pixel_21_out;
        input [7:0] expected_pixel_30_out;
        input [7:0] expected_pixel_31_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pixel_00_out === (expected_pixel_00_out ^ pixel_00_out ^ expected_pixel_00_out) &&
                expected_pixel_01_out === (expected_pixel_01_out ^ pixel_01_out ^ expected_pixel_01_out) &&
                expected_pixel_10_out === (expected_pixel_10_out ^ pixel_10_out ^ expected_pixel_10_out) &&
                expected_pixel_11_out === (expected_pixel_11_out ^ pixel_11_out ^ expected_pixel_11_out) &&
                expected_pixel_20_out === (expected_pixel_20_out ^ pixel_20_out ^ expected_pixel_20_out) &&
                expected_pixel_21_out === (expected_pixel_21_out ^ pixel_21_out ^ expected_pixel_21_out) &&
                expected_pixel_30_out === (expected_pixel_30_out ^ pixel_30_out ^ expected_pixel_30_out) &&
                expected_pixel_31_out === (expected_pixel_31_out ^ pixel_31_out ^ expected_pixel_31_out)) begin
                $display("PASS");
                $display("  Outputs: pixel_00_out=%h, pixel_01_out=%h, pixel_10_out=%h, pixel_11_out=%h, pixel_20_out=%h, pixel_21_out=%h, pixel_30_out=%h, pixel_31_out=%h",
                         pixel_00_out, pixel_01_out, pixel_10_out, pixel_11_out, pixel_20_out, pixel_21_out, pixel_30_out, pixel_31_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pixel_00_out=%h, pixel_01_out=%h, pixel_10_out=%h, pixel_11_out=%h, pixel_20_out=%h, pixel_21_out=%h, pixel_30_out=%h, pixel_31_out=%h",
                         expected_pixel_00_out, expected_pixel_01_out, expected_pixel_10_out, expected_pixel_11_out, expected_pixel_20_out, expected_pixel_21_out, expected_pixel_30_out, expected_pixel_31_out);
                $display("  Got:      pixel_00_out=%h, pixel_01_out=%h, pixel_10_out=%h, pixel_11_out=%h, pixel_20_out=%h, pixel_21_out=%h, pixel_30_out=%h, pixel_31_out=%h",
                         pixel_00_out, pixel_01_out, pixel_10_out, pixel_11_out, pixel_20_out, pixel_21_out, pixel_30_out, pixel_31_out);
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
