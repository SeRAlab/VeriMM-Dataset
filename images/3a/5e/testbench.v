`timescale 1ns/1ps

module gaussian_blur_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_00;
    reg [7:0] pixel_01;
    reg [7:0] pixel_02;
    reg [7:0] pixel_10;
    reg [7:0] pixel_11;
    reg [7:0] pixel_12;
    reg [7:0] pixel_20;
    reg [7:0] pixel_21;
    reg [7:0] pixel_22;
    wire [7:0] output_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gaussian_blur dut (
        .pixel_00(pixel_00),
        .pixel_01(pixel_01),
        .pixel_02(pixel_02),
        .pixel_10(pixel_10),
        .pixel_11(pixel_11),
        .pixel_12(pixel_12),
        .pixel_20(pixel_20),
        .pixel_21(pixel_21),
        .pixel_22(pixel_22),
        .output_pixel(output_pixel)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            pixel_00 = 8'd0; pixel_01 = 8'd0; pixel_02 = 8'd0;
            pixel_10 = 8'd0; pixel_11 = 8'd0; pixel_12 = 8'd0;
            pixel_20 = 8'd0; pixel_21 = 8'd0; pixel_22 = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All White (255)", test_num);
            pixel_00 = 8'd255; pixel_01 = 8'd255; pixel_02 = 8'd255;
            pixel_10 = 8'd255; pixel_11 = 8'd255; pixel_12 = 8'd255;
            pixel_20 = 8'd255; pixel_21 = 8'd255; pixel_22 = 8'd255;

            #1;


            check_outputs(8'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-gray (128)", test_num);
            pixel_00 = 8'd128; pixel_01 = 8'd128; pixel_02 = 8'd128;
            pixel_10 = 8'd128; pixel_11 = 8'd128; pixel_12 = 8'd128;
            pixel_20 = 8'd128; pixel_21 = 8'd128; pixel_22 = 8'd128;

            #1;


            check_outputs(8'd128);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Impulse at Center", test_num);
            pixel_00 = 8'd0;   pixel_01 = 8'd0;   pixel_02 = 8'd0;
            pixel_10 = 8'd0;   pixel_11 = 8'd255; pixel_12 = 8'd0;
            pixel_20 = 8'd0;   pixel_21 = 8'd0;   pixel_22 = 8'd0;

            #1;


            check_outputs(8'd63);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Impulse at Corner", test_num);
            pixel_00 = 8'd255; pixel_01 = 8'd0;   pixel_02 = 8'd0;
            pixel_10 = 8'd0;   pixel_11 = 8'd0;   pixel_12 = 8'd0;
            pixel_20 = 8'd0;   pixel_21 = 8'd0;   pixel_22 = 8'd0;

            #1;


            check_outputs(8'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Impulse at Edge", test_num);
            pixel_00 = 8'd0;   pixel_01 = 8'd255; pixel_02 = 8'd0;
            pixel_10 = 8'd0;   pixel_11 = 8'd0;   pixel_12 = 8'd0;
            pixel_20 = 8'd0;   pixel_21 = 8'd0;   pixel_22 = 8'd0;

            #1;


            check_outputs(8'd31);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gradient Pattern", test_num);
            pixel_00 = 8'd10; pixel_01 = 8'd20; pixel_02 = 8'd30;
            pixel_10 = 8'd40; pixel_11 = 8'd50; pixel_12 = 8'd60;
            pixel_20 = 8'd70; pixel_21 = 8'd80; pixel_22 = 8'd90;



            #1;




            check_outputs(8'd50);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checkerboard Pattern", test_num);
            pixel_00 = 8'hFF; pixel_01 = 8'h00; pixel_02 = 8'hFF;
            pixel_10 = 8'h00; pixel_11 = 8'hFF; pixel_12 = 8'h00;
            pixel_20 = 8'hFF; pixel_21 = 8'h00; pixel_22 = 8'hFF;



            #1;




            check_outputs(8'd127);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gaussian_blur Testbench");
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
        input [7:0] expected_output_pixel;
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
