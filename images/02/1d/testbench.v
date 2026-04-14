`timescale 1ns/1ps

module gaussian_blur_3x3_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel00;
    reg [7:0] pixel01;
    reg [7:0] pixel02;
    reg [7:0] pixel10;
    reg [7:0] pixel11;
    reg [7:0] pixel12;
    reg [7:0] pixel20;
    reg [7:0] pixel21;
    reg [7:0] pixel22;
    wire [7:0] blurred_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gaussian_blur_3x3 dut (
        .pixel00(pixel00),
        .pixel01(pixel01),
        .pixel02(pixel02),
        .pixel10(pixel10),
        .pixel11(pixel11),
        .pixel12(pixel12),
        .pixel20(pixel20),
        .pixel21(pixel21),
        .pixel22(pixel22),
        .blurred_pixel(blurred_pixel)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (Black Image)", test_num);
            pixel00 = 8'd0; pixel01 = 8'd0; pixel02 = 8'd0;
            pixel10 = 8'd0; pixel11 = 8'd0; pixel12 = 8'd0;
            pixel20 = 8'd0; pixel21 = 8'd0; pixel22 = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All 255 (White Image)", test_num);
            pixel00 = 8'd255; pixel01 = 8'd255; pixel02 = 8'd255;
            pixel10 = 8'd255; pixel11 = 8'd255; pixel12 = 8'd255;
            pixel20 = 8'd255; pixel21 = 8'd255; pixel22 = 8'd255;

            #1;


            check_outputs(8'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Impulse Response (Center Pixel Only)", test_num);
            pixel00 = 8'd0;   pixel01 = 8'd0;   pixel02 = 8'd0;
            pixel10 = 8'd0;   pixel11 = 8'd128; pixel12 = 8'd0;
            pixel20 = 8'd0;   pixel21 = 8'd0;   pixel22 = 8'd0;

            #1;


            check_outputs(8'd32);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Corner Weight Check", test_num);
            pixel00 = 8'd160; pixel01 = 8'd0; pixel02 = 8'd0;
            pixel10 = 8'd0;   pixel11 = 8'd0; pixel12 = 8'd0;
            pixel20 = 8'd0;   pixel21 = 8'd0; pixel22 = 8'd0;

            #1;


            check_outputs(8'd10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gradient Values", test_num);
            pixel00 = 8'd10; pixel01 = 8'd20; pixel02 = 8'd30;
            pixel10 = 8'd40; pixel11 = 8'd50; pixel12 = 8'd60;
            pixel20 = 8'd70; pixel21 = 8'd80; pixel22 = 8'd90;



            #1;




            check_outputs(8'd50);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Truncation Check", test_num);
            pixel00 = 8'd25; pixel01 = 8'd0; pixel02 = 8'd0;
            pixel10 = 8'd0;  pixel11 = 8'd0; pixel12 = 8'd0;
            pixel20 = 8'd0;  pixel21 = 8'd0; pixel22 = 8'd0;

            #1;


            check_outputs(8'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Intensity Pattern", test_num);
            pixel00 = 8'd200; pixel01 = 8'd100; pixel02 = 8'd200;
            pixel10 = 8'd100; pixel11 = 8'd255; pixel12 = 8'd100;
            pixel20 = 8'd200; pixel21 = 8'd100; pixel22 = 8'd200;



            #1;




            check_outputs(8'd163);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gaussian_blur_3x3 Testbench");
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
