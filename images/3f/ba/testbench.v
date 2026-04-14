`timescale 1ns/1ps

module gaussian_blur_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] p00;
    reg [7:0] p01;
    reg [7:0] p02;
    reg [7:0] p10;
    reg [7:0] p11;
    reg [7:0] p12;
    reg [7:0] p20;
    reg [7:0] p21;
    reg [7:0] p22;
    wire [7:0] blurred_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gaussian_blur dut (
        .p00(p00),
        .p01(p01),
        .p02(p02),
        .p10(p10),
        .p11(p11),
        .p12(p12),
        .p20(p20),
        .p21(p21),
        .p22(p22),
        .blurred_pixel(blurred_pixel)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (Black Image)", test_num);
            p00 = 8'd0; p01 = 8'd0; p02 = 8'd0;
            p10 = 8'd0; p11 = 8'd0; p12 = 8'd0;
            p20 = 8'd0; p21 = 8'd0; p22 = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All 255 (White Image)", test_num);
            p00 = 8'd255; p01 = 8'd255; p02 = 8'd255;
            p10 = 8'd255; p11 = 8'd255; p12 = 8'd255;
            p20 = 8'd255; p21 = 8'd255; p22 = 8'd255;

            #1;


            check_outputs(8'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Uniform Mid-Gray (128)", test_num);
            p00 = 8'd128; p01 = 8'd128; p02 = 8'd128;
            p10 = 8'd128; p11 = 8'd128; p12 = 8'd128;
            p20 = 8'd128; p21 = 8'd128; p22 = 8'd128;

            #1;


            check_outputs(8'd128);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Impulse at Center (p11 = 255)", test_num);
            p00 = 8'd0; p01 = 8'd0;   p02 = 8'd0;
            p10 = 8'd0; p11 = 8'd255; p12 = 8'd0;
            p20 = 8'd0; p21 = 8'd0;   p22 = 8'd0;

            #1;


            check_outputs(8'd63);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Impulse at Corner (p00 = 255)", test_num);
            p00 = 8'd255; p01 = 8'd0; p02 = 8'd0;
            p10 = 8'd0;   p11 = 8'd0; p12 = 8'd0;
            p20 = 8'd0;   p21 = 8'd0; p22 = 8'd0;

            #1;


            check_outputs(8'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Vertical Line at Center", test_num);
            p00 = 8'd0; p01 = 8'd255; p02 = 8'd0;
            p10 = 8'd0; p11 = 8'd255; p12 = 8'd0;
            p20 = 8'd0; p21 = 8'd255; p22 = 8'd0;


            #1;



            check_outputs(8'd127);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Gradient Pattern", test_num);
            p00 = 8'd10; p01 = 8'd20; p02 = 8'd30;
            p10 = 8'd40; p11 = 8'd50; p12 = 8'd60;
            p20 = 8'd70; p21 = 8'd80; p22 = 8'd90;



            #1;




            check_outputs(8'd50);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small Values (Truncation Check)", test_num);
            p00 = 8'd5; p01 = 8'd5; p02 = 8'd5;
            p10 = 8'd5; p11 = 8'd5; p12 = 8'd5;
            p20 = 8'd5; p21 = 8'd5; p22 = 8'd5;

            #1;


            check_outputs(8'd5);
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
