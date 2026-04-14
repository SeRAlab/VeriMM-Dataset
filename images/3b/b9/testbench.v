`timescale 1ns/1ps

module gaussian_blur_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] pixel_0;
    reg [8:0] pixel_1;
    reg [8:0] pixel_2;
    reg [8:0] pixel_3;
    reg [8:0] pixel_4;
    reg [8:0] pixel_5;
    reg [8:0] pixel_6;
    reg [8:0] pixel_7;
    reg [8:0] pixel_8;
    wire [8:0] blurred_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gaussian_blur dut (
        .pixel_0(pixel_0),
        .pixel_1(pixel_1),
        .pixel_2(pixel_2),
        .pixel_3(pixel_3),
        .pixel_4(pixel_4),
        .pixel_5(pixel_5),
        .pixel_6(pixel_6),
        .pixel_7(pixel_7),
        .pixel_8(pixel_8),
        .blurred_pixel(blurred_pixel)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Black (Zeros)", test_num);
            pixel_0 = 9'd0; pixel_1 = 9'd0; pixel_2 = 9'd0;
            pixel_3 = 9'd0; pixel_4 = 9'd0; pixel_5 = 9'd0;
            pixel_6 = 9'd0; pixel_7 = 9'd0; pixel_8 = 9'd0;
            #1;

            check_outputs(9'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All White (Max Value 511)", test_num);
            pixel_0 = 9'd511; pixel_1 = 9'd511; pixel_2 = 9'd511;
            pixel_3 = 9'd511; pixel_4 = 9'd511; pixel_5 = 9'd511;
            pixel_6 = 9'd511; pixel_7 = 9'd511; pixel_8 = 9'd511;

            #1;


            check_outputs(9'd511);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Center Impulse", test_num);
            pixel_0 = 9'd0;   pixel_1 = 9'd0;   pixel_2 = 9'd0;
            pixel_3 = 9'd0;   pixel_4 = 9'd400; pixel_5 = 9'd0;
            pixel_6 = 9'd0;   pixel_7 = 9'd0;   pixel_8 = 9'd0;

            #1;


            check_outputs(9'd100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Adjacent (Edge) Impulse", test_num);
            pixel_0 = 9'd0;   pixel_1 = 9'd400; pixel_2 = 9'd0;
            pixel_3 = 9'd0;   pixel_4 = 9'd0;   pixel_5 = 9'd0;
            pixel_6 = 9'd0;   pixel_7 = 9'd0;   pixel_8 = 9'd0;

            #1;


            check_outputs(9'd50);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Corner Impulse", test_num);
            pixel_0 = 9'd400; pixel_1 = 9'd0;   pixel_2 = 9'd0;
            pixel_3 = 9'd0;   pixel_4 = 9'd0;   pixel_5 = 9'd0;
            pixel_6 = 9'd0;   pixel_7 = 9'd0;   pixel_8 = 9'd0;

            #1;


            check_outputs(9'd25);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Uniform Mid-Gray", test_num);
            pixel_0 = 9'd128; pixel_1 = 9'd128; pixel_2 = 9'd128;
            pixel_3 = 9'd128; pixel_4 = 9'd128; pixel_5 = 9'd128;
            pixel_6 = 9'd128; pixel_7 = 9'd128; pixel_8 = 9'd128;

            #1;


            check_outputs(9'd128);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed Values (Truncation Check)", test_num);
            pixel_0 = 9'd10;  pixel_1 = 9'd20;  pixel_2 = 9'd10;
            pixel_3 = 9'd20;  pixel_4 = 9'd30;  pixel_5 = 9'd20;
            pixel_6 = 9'd10;  pixel_7 = 9'd20;  pixel_8 = 9'd10;



            #1;




            check_outputs(9'd20);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gradient Pattern", test_num);
            pixel_0 = 9'd0;   pixel_1 = 9'd100; pixel_2 = 9'd200;
            pixel_3 = 9'd100; pixel_4 = 9'd200; pixel_5 = 9'd300;
            pixel_6 = 9'd200; pixel_7 = 9'd300; pixel_8 = 9'd400;




            #1;





            check_outputs(9'd200);
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
