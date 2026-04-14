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
            $display("Test %0d: All Zeros", test_num);
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
            $display("Test %0d: Center only (Weight 1)", test_num);
            p00 = 8'd0; p01 = 8'd0; p02 = 8'd0;
            p10 = 8'd0; p11 = 8'd16; p12 = 8'd0;
            p20 = 8'd0; p21 = 8'd0; p22 = 8'd0;

            #1;


            check_outputs(8'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Edge only (Weight 2)", test_num);
            p00 = 8'd0; p01 = 8'd16; p02 = 8'd0;
            p10 = 8'd0; p11 = 8'd0; p12 = 8'd0;
            p20 = 8'd0; p21 = 8'd0; p22 = 8'd0;

            #1;


            check_outputs(8'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Corner only (Weight 4)", test_num);
            p00 = 8'd16; p01 = 8'd0; p02 = 8'd0;
            p10 = 8'd0; p11 = 8'd0; p12 = 8'd0;
            p20 = 8'd0; p21 = 8'd0; p22 = 8'd0;

            #1;


            check_outputs(8'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Uniform Low Values (Rounding Down)", test_num);
            p00 = 8'd10; p01 = 8'd10; p02 = 8'd10;
            p10 = 8'd10; p11 = 8'd10; p12 = 8'd10;
            p20 = 8'd10; p21 = 8'd10; p22 = 8'd10;

            #1;


            check_outputs(8'd16);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Uniform Values (Rounding Up)", test_num);
            p00 = 8'd40; p01 = 8'd40; p02 = 8'd40;
            p10 = 8'd40; p11 = 8'd40; p12 = 8'd40;
            p20 = 8'd40; p21 = 8'd40; p22 = 8'd40;

            #1;


            check_outputs(8'd63);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Rounding Threshold Down (0.4375)", test_num);
            p00 = 8'd0; p01 = 8'd0; p02 = 8'd0;
            p10 = 8'd0; p11 = 8'd7; p12 = 8'd0;
            p20 = 8'd0; p21 = 8'd0; p22 = 8'd0;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Rounding Threshold Up (0.5)", test_num);
            p00 = 8'd0; p01 = 8'd0; p02 = 8'd0;
            p10 = 8'd0; p11 = 8'd8; p12 = 8'd0;
            p20 = 8'd0; p21 = 8'd0; p22 = 8'd0;

            #1;


            check_outputs(8'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High Values (Below 256 output)", test_num);
            p00 = 8'd100; p01 = 8'd100; p02 = 8'd100;
            p10 = 8'd100; p11 = 8'd100; p12 = 8'd100;
            p20 = 8'd100; p21 = 8'd100; p22 = 8'd100;

            #1;


            check_outputs(8'd156);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checkerboard Pattern", test_num);
            p00 = 8'd10; p01 = 8'd0;  p02 = 8'd10;
            p10 = 8'd0;  p11 = 8'd10; p12 = 8'd0;
            p20 = 8'd10; p21 = 8'd0;  p22 = 8'd10;


            #1;



            check_outputs(8'd11);
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
