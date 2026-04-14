`timescale 1ns/1ps

module convolution_2x2_3x3_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] image00;
    reg [7:0] image01;
    reg [7:0] image10;
    reg [7:0] image11;
    reg [7:0] kernel00;
    reg [7:0] kernel01;
    reg [7:0] kernel02;
    reg [7:0] kernel10;
    reg [7:0] kernel11;
    reg [7:0] kernel12;
    reg [7:0] kernel20;
    reg [7:0] kernel21;
    reg [7:0] kernel22;
    wire [15:0] output_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    convolution_2x2_3x3 dut (
        .image00(image00),
        .image01(image01),
        .image10(image10),
        .image11(image11),
        .kernel00(kernel00),
        .kernel01(kernel01),
        .kernel02(kernel02),
        .kernel10(kernel10),
        .kernel11(kernel11),
        .kernel12(kernel12),
        .kernel20(kernel20),
        .kernel21(kernel21),
        .kernel22(kernel22),
        .output_pixel(output_pixel)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            image00 = 8'd0; image01 = 8'd0;
            image10 = 8'd0; image11 = 8'd0;
            kernel00 = 8'd0; kernel01 = 8'd0; kernel02 = 8'd0;
            kernel10 = 8'd0; kernel11 = 8'd0; kernel12 = 8'd0;
            kernel20 = 8'd0; kernel21 = 8'd0; kernel22 = 8'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Kernel Impulse at (0,0)", test_num);

            image00 = 8'd42; image01 = 8'd100;
            image10 = 8'd200; image11 = 8'd50;
            kernel00 = 8'd1; kernel01 = 8'd0; kernel02 = 8'd0;
            kernel10 = 8'd0; kernel11 = 8'd0; kernel12 = 8'd0;
            kernel20 = 8'd0; kernel21 = 8'd0; kernel22 = 8'd0;
            #1;

            check_outputs(16'd42);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sum of 2x2 Matrix (Kernel ones in 2x2 region)", test_num);


            image00 = 8'd1; image01 = 8'd2;
            image10 = 8'd3; image11 = 8'd4;
            kernel00 = 8'd1; kernel01 = 8'd1; kernel02 = 8'd0;
            kernel10 = 8'd1; kernel11 = 8'd1; kernel12 = 8'd0;
            kernel20 = 8'd0; kernel21 = 8'd0; kernel22 = 8'd0;

            #1;


            check_outputs(16'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify Zero Padding (Padded regions don't affect output)", test_num);

            image00 = 8'd10; image01 = 8'd10;
            image10 = 8'd10; image11 = 8'd10;
            kernel00 = 8'd1;   kernel01 = 8'd1;   kernel02 = 8'd255;
            kernel10 = 8'd1;   kernel11 = 8'd1;   kernel12 = 8'd255;
            kernel20 = 8'd255; kernel21 = 8'd255; kernel22 = 8'd255;

            #1;


            check_outputs(16'd40);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large Values Calculation", test_num);
            image00 = 8'd100; image01 = 8'd50;
            image10 = 8'd20;  image11 = 8'd10;
            kernel00 = 8'd50;  kernel01 = 8'd40;  kernel02 = 8'd0;
            kernel10 = 8'd30;  kernel11 = 8'd20;  kernel12 = 8'd0;
            kernel20 = 8'd0;   kernel21 = 8'd0;   kernel22 = 8'd0;


            #1;



            check_outputs(16'h1E78);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Max Input and Overflow Handling", test_num);


            image00 = 8'hFF; image01 = 8'hFF;
            image10 = 8'hFF; image11 = 8'hFF;
            kernel00 = 8'hFF; kernel01 = 8'hFF; kernel02 = 8'd0;
            kernel10 = 8'hFF; kernel11 = 8'hFF; kernel12 = 8'd0;
            kernel20 = 8'd0;  kernel21 = 8'd0;  kernel22 = 8'd0;
            #1;

            check_outputs(16'hF9F4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("convolution_2x2_3x3 Testbench");
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
        input [15:0] expected_output_pixel;
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
