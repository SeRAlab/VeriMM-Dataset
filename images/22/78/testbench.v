`timescale 1ns/1ps

module image_convolution_tb;

    // Testbench signals (combinational circuit)
    reg [71:0] kernel;
    reg [71:0] pixel_matrix;
    wire [15:0] output_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    image_convolution dut (
        .kernel(kernel),
        .pixel_matrix(pixel_matrix),
        .output_pixel(output_pixel)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All Zeros", test_num);
            kernel = 72'h0;
            pixel_matrix = 72'h0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Identity Kernel (Pass-through center pixel)", test_num);

            kernel = 72'h00_00_00_00_01_00_00_00_00;

            pixel_matrix = 72'h11_22_33_44_A5_66_77_88_99;
            #1;

            check_outputs(16'h00A5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: All Units (Sum of 1s)", test_num);

            kernel = 72'h01_01_01_01_01_01_01_01_01;

            pixel_matrix = 72'h01_01_01_01_01_01_01_01_01;

            #1;


            check_outputs(16'h0009);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Uniform Pixels with Box Blur-style Sum", test_num);

            kernel = 72'h02_02_02_02_02_02_02_02_02;

            pixel_matrix = 72'h0A_0A_0A_0A_0A_0A_0A_0A_0A;

            #1;


            check_outputs(16'h00B4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Diagonal Kernel", test_num);

            kernel = 72'h01_00_00_00_01_00_00_00_01;

            pixel_matrix = 72'h10_FF_FF_FF_10_FF_FF_FF_10;

            #1;


            check_outputs(16'h0030);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Large Value Accumulation", test_num);

            kernel = 72'h10_10_10_10_10_10_10_10_10;

            pixel_matrix = 72'h80_80_80_80_80_80_80_80_80;

            #1;


            check_outputs(16'h4800);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Maximum Input Handling (Overflow Wrap)", test_num);

            kernel = 72'hFF_FF_FF_FF_FF_FF_FF_FF_FF;

            pixel_matrix = 72'hFF_FF_FF_FF_FF_FF_FF_FF_FF;


            #1;



            check_outputs(16'hEE09);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Single Pixel Contribution", test_num);

            kernel = 72'h00_00_00_00_00_00_00_00_01;

            pixel_matrix = 72'h00_00_00_00_00_00_00_00_7F;
            #1;

            check_outputs(16'h007F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("image_convolution Testbench");
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
        input [15:0] expected_output_pixel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_pixel === (expected_output_pixel ^ output_pixel ^ expected_output_pixel)) begin
                $display("PASS");
                $display("  Outputs: output_pixel=%h",
                         output_pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_pixel=%h",
                         expected_output_pixel);
                $display("  Got:      output_pixel=%h",
                         output_pixel);
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
