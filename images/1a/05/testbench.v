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
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All pixels 0", test_num);
            pixel00 = 8'd0; pixel01 = 8'd0; pixel02 = 8'd0;
            pixel10 = 8'd0; pixel11 = 8'd0; pixel12 = 8'd0;
            pixel20 = 8'd0; pixel21 = 8'd0; pixel22 = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Uniform background (all 200)", test_num);
            pixel00 = 8'd200; pixel01 = 8'd200; pixel02 = 8'd200;
            pixel10 = 8'd200; pixel11 = 8'd200; pixel12 = 8'd200;
            pixel20 = 8'd200; pixel21 = 8'd200; pixel22 = 8'd200;

            #1;


            check_outputs(8'd200);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Center impulse (pixel11 = 200)", test_num);
            pixel00 = 8'd0;   pixel01 = 8'd0;   pixel02 = 8'd0;
            pixel10 = 8'd0;   pixel11 = 8'd200; pixel12 = 8'd0;
            pixel20 = 8'd0;   pixel21 = 8'd0;   pixel22 = 8'd0;

            #1;


            check_outputs(8'd40);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Corner impulse (pixel00 = 200)", test_num);
            pixel00 = 8'd200; pixel01 = 8'd0;   pixel02 = 8'd0;
            pixel10 = 8'd0;   pixel11 = 8'd0;   pixel12 = 8'd0;
            pixel20 = 8'd0;   pixel21 = 8'd0;   pixel22 = 8'd0;

            #1;


            check_outputs(8'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Edge impulse (pixel01 = 200)", test_num);
            pixel00 = 8'd0;   pixel01 = 8'd200; pixel02 = 8'd0;
            pixel10 = 8'd0;   pixel11 = 8'd0;   pixel12 = 8'd0;
            pixel20 = 8'd0;   pixel21 = 8'd0;   pixel22 = 8'd0;

            #1;


            check_outputs(8'd25);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Maximum values (all 255)", test_num);
            pixel00 = 8'd255; pixel01 = 8'd255; pixel02 = 8'd255;
            pixel10 = 8'd255; pixel11 = 8'd255; pixel12 = 8'd255;
            pixel20 = 8'd255; pixel21 = 8'd255; pixel22 = 8'd255;

            #1;


            check_outputs(8'd255);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Vertical line (left column 40)", test_num);
            pixel00 = 8'd40;  pixel01 = 8'd0;   pixel02 = 8'd0;
            pixel10 = 8'd40;  pixel11 = 8'd0;   pixel12 = 8'd0;
            pixel20 = 8'd40;  pixel21 = 8'd0;   pixel22 = 8'd0;

            #1;


            check_outputs(8'd11);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Checkerboard pattern", test_num);
            pixel00 = 8'd40; pixel01 = 8'd0;  pixel02 = 8'd40;
            pixel10 = 8'd0;  pixel11 = 8'd40; pixel12 = 8'd0;
            pixel20 = 8'd40; pixel21 = 8'd0;  pixel22 = 8'd40;


            #1;



            check_outputs(8'd20);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Gradient pattern", test_num);
            pixel00 = 8'd20; pixel01 = 8'd40;  pixel02 = 8'd60;
            pixel10 = 8'd80; pixel11 = 8'd100; pixel12 = 8'd120;
            pixel20 = 8'd140; pixel21 = 8'd160; pixel22 = 8'd180;


            #1;



            check_outputs(8'd100);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Symmetry check (Top vs Bottom edges)", test_num);
            pixel00 = 8'd0;   pixel01 = 8'd120; pixel02 = 8'd0;
            pixel10 = 8'd0;   pixel11 = 8'd0;   pixel12 = 8'd0;
            pixel20 = 8'd0;   pixel21 = 8'd120; pixel22 = 8'd0;

            #1;


            check_outputs(8'd30);
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
