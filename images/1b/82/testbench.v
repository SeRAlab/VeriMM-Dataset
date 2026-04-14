`timescale 1ns/1ps

module gaussian_blur_tb;

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
    gaussian_blur dut (
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
    task set_all_pixels;

        input [7:0] val;
        begin
            pixel00 = val; pixel01 = val; pixel02 = val;
            pixel10 = val; pixel11 = val; pixel12 = val;
            pixel20 = val; pixel21 = val; pixel22 = val;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            set_all_pixels(8'h00);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Max (White)", test_num);
            set_all_pixels(8'hFF);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Center Impulse", test_num);
            set_all_pixels(8'h00);
            pixel11 = 8'hFF;
            #1;

            check_outputs(8'h3F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Gradient Values", test_num);
            pixel00 = 8'd10; pixel01 = 8'd20; pixel02 = 8'd30;
            pixel10 = 8'd40; pixel11 = 8'd50; pixel12 = 8'd60;
            pixel20 = 8'd70; pixel21 = 8'd80; pixel22 = 8'd90;
            #1;

            check_outputs(8'h32);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Corner Impulse", test_num);
            set_all_pixels(8'h00);
            pixel00 = 8'hFF;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checkerboard Pattern", test_num);
            pixel00 = 8'hFF; pixel01 = 8'h00; pixel02 = 8'hFF;
            pixel10 = 8'h00; pixel11 = 8'hFF; pixel12 = 8'h00;
            pixel20 = 8'hFF; pixel21 = 8'h00; pixel22 = 8'hFF;
            #1;

            check_outputs(8'h7F);
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
