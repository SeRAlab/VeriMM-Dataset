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
    wire [7:0] blurred_pixel;

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
            $display("Test Case %0d: All Black (0x00)", test_num);
            pixel_00 = 8'h00; pixel_01 = 8'h00; pixel_02 = 8'h00;
            pixel_10 = 8'h00; pixel_11 = 8'h00; pixel_12 = 8'h00;
            pixel_20 = 8'h00; pixel_21 = 8'h00; pixel_22 = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All White (0xFF)", test_num);
            pixel_00 = 8'hFF; pixel_01 = 8'hFF; pixel_02 = 8'hFF;
            pixel_10 = 8'hFF; pixel_11 = 8'hFF; pixel_12 = 8'hFF;
            pixel_20 = 8'hFF; pixel_21 = 8'hFF; pixel_22 = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Uniform Gray (0x80)", test_num);
            pixel_00 = 8'h80; pixel_01 = 8'h80; pixel_02 = 8'h80;
            pixel_10 = 8'h80; pixel_11 = 8'h80; pixel_12 = 8'h80;
            pixel_20 = 8'h80; pixel_21 = 8'h80; pixel_22 = 8'h80;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Impulse (Center Pixel Only)", test_num);

            pixel_00 = 8'h00; pixel_01 = 8'h00; pixel_02 = 8'h00;
            pixel_10 = 8'h00; pixel_11 = 8'hFF; pixel_12 = 8'h00;
            pixel_20 = 8'h00; pixel_21 = 8'h00; pixel_22 = 8'h00;
            #1;

            check_outputs(8'h3F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Vertical Line", test_num);



            pixel_00 = 8'h00; pixel_01 = 8'h40; pixel_02 = 8'h00;
            pixel_10 = 8'h00; pixel_11 = 8'h40; pixel_12 = 8'h00;
            pixel_20 = 8'h00; pixel_21 = 8'h40; pixel_22 = 8'h00;
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gradient Pattern", test_num);




            pixel_00 = 8'd10; pixel_01 = 8'd20; pixel_02 = 8'd30;
            pixel_10 = 8'd40; pixel_11 = 8'd50; pixel_12 = 8'd60;
            pixel_20 = 8'd70; pixel_21 = 8'd80; pixel_22 = 8'd90;
            #1;

            check_outputs(8'h32);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Corner Pixels Only", test_num);


            pixel_00 = 8'd16; pixel_01 = 8'd00; pixel_02 = 8'd16;
            pixel_10 = 8'd00; pixel_11 = 8'd00; pixel_12 = 8'd00;
            pixel_20 = 8'd16; pixel_21 = 8'd00; pixel_22 = 8'd16;
            #1;

            check_outputs(8'h04);
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
        input [7:0] expected_blurred_pixel;
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
