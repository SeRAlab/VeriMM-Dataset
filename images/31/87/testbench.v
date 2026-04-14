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
            $display("Testcase 001: All Zeros");
            p00 = 0; p01 = 0; p02 = 0;
            p10 = 0; p11 = 0; p12 = 0;
            p20 = 0; p21 = 0; p22 = 0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Maximum Values (All 255)");
            p00 = 255; p01 = 255; p02 = 255;
            p10 = 255; p11 = 255; p12 = 255;
            p20 = 255; p21 = 255; p22 = 255;

            #1;


            check_outputs(8'd255);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Impulse Response (Center pixel high)");
            p00 = 0;   p01 = 0;   p02 = 0;
            p10 = 0;   p11 = 160; p12 = 0;
            p20 = 0;   p21 = 0;   p22 = 0;

            #1;


            check_outputs(8'd40);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Weighted Edge (Top center)");
            p00 = 0;   p01 = 128; p02 = 0;
            p10 = 0;   p11 = 0;   p12 = 0;
            p20 = 0;   p21 = 0;   p22 = 0;

            #1;


            check_outputs(8'd16);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Corner pixel");
            p00 = 128; p01 = 0; p02 = 0;
            p10 = 0;   p11 = 0; p12 = 0;
            p20 = 0;   p21 = 0; p22 = 0;

            #1;


            check_outputs(8'd8);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Mix of values (Resulting in floor/truncation)");
            p00 = 10; p01 = 20; p02 = 30;
            p10 = 40; p11 = 50; p12 = 60;
            p20 = 70; p21 = 80; p22 = 90;




            #1;





            check_outputs(8'd50);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Truncation check");
            p00 = 15; p01 = 0; p02 = 0;
            p10 = 0;  p11 = 0; p12 = 0;
            p20 = 0;  p21 = 0; p22 = 0;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Gradient values");
            p00 = 16; p01 = 32; p02 = 16;
            p10 = 32; p11 = 64; p12 = 32;
            p20 = 16; p21 = 32; p22 = 16;




            #1;





            check_outputs(8'd36);
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
