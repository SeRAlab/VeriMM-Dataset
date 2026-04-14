`timescale 1ns/1ps

module gaussian_blur_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] pixel_00;
    reg [8:0] pixel_01;
    reg [8:0] pixel_02;
    reg [8:0] pixel_10;
    reg [8:0] pixel_11;
    reg [8:0] pixel_12;
    reg [8:0] pixel_20;
    reg [8:0] pixel_21;
    reg [8:0] pixel_22;
    wire [8:0] blurred_pixel;

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
        .blurred_pixel(blurred_pixel)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros (Black Image)", test_num);
            pixel_00 = 9'd0; pixel_01 = 9'd0; pixel_02 = 9'd0;
            pixel_10 = 9'd0; pixel_11 = 9'd0; pixel_12 = 9'd0;
            pixel_20 = 9'd0; pixel_21 = 9'd0; pixel_22 = 9'd0;
            #1;

            check_outputs(9'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All 255 (White Image)", test_num);
            pixel_00 = 9'd255; pixel_01 = 9'd255; pixel_02 = 9'd255;
            pixel_10 = 9'd255; pixel_11 = 9'd255; pixel_12 = 9'd255;
            pixel_20 = 9'd255; pixel_21 = 9'd255; pixel_22 = 9'd255;

            #1;


            check_outputs(9'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Center Impulse", test_num);
            pixel_00 = 9'd0;   pixel_01 = 9'd0;   pixel_02 = 9'd0;
            pixel_10 = 9'd0;   pixel_11 = 9'd160; pixel_12 = 9'd0;
            pixel_20 = 9'd0;   pixel_21 = 9'd0;   pixel_22 = 9'd0;

            #1;


            check_outputs(9'd40);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Corners Only", test_num);
            pixel_00 = 9'd64;  pixel_01 = 9'd0;   pixel_02 = 9'd64;
            pixel_10 = 9'd0;   pixel_11 = 9'd0;   pixel_12 = 9'd0;
            pixel_20 = 9'd64;  pixel_21 = 9'd0;   pixel_22 = 9'd64;

            #1;


            check_outputs(9'd16);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Vertical Edge", test_num);
            pixel_00 = 9'd0;   pixel_01 = 9'd120; pixel_02 = 9'd0;
            pixel_10 = 9'd0;   pixel_11 = 9'd120; pixel_12 = 9'd0;
            pixel_20 = 9'd0;   pixel_21 = 9'd120; pixel_22 = 9'd0;

            #1;


            check_outputs(9'd60);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Gradient Values", test_num);
            pixel_00 = 9'd10; pixel_01 = 9'd20; pixel_02 = 9'd30;
            pixel_10 = 9'd40; pixel_11 = 9'd50; pixel_12 = 9'd60;
            pixel_20 = 9'd70; pixel_21 = 9'd80; pixel_22 = 9'd90;

            #1;


            check_outputs(9'd50);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Truncation Check", test_num);
            pixel_00 = 9'd31;  pixel_01 = 9'd0; pixel_02 = 9'd0;
            pixel_10 = 9'd0;   pixel_11 = 9'd0; pixel_12 = 9'd0;
            pixel_20 = 9'd0;   pixel_21 = 9'd0; pixel_22 = 9'd0;

            #1;


            check_outputs(9'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Side Pixel Weights", test_num);
            pixel_00 = 9'd0;  pixel_01 = 9'd80; pixel_02 = 9'd0;
            pixel_10 = 9'd80; pixel_11 = 9'd0;  pixel_12 = 9'd80;
            pixel_20 = 9'd0;  pixel_21 = 9'd80; pixel_22 = 9'd0;

            #1;


            check_outputs(9'd40);
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
        input [8:0] expected_blurred_pixel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_blurred_pixel === (expected_blurred_pixel ^ blurred_pixel ^ expected_blurred_pixel)) begin
                $display("PASS");
                $display("  Outputs: blurred_pixel=%h",
                         blurred_pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: blurred_pixel=%h",
                         expected_blurred_pixel);
                $display("  Got:      blurred_pixel=%h",
                         blurred_pixel);
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
