`timescale 1ns/1ps

module image_convolution_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] kernel_00;
    reg [7:0] kernel_01;
    reg [7:0] kernel_02;
    reg [7:0] kernel_10;
    reg [7:0] kernel_11;
    reg [7:0] kernel_12;
    reg [7:0] kernel_20;
    reg [7:0] kernel_21;
    reg [7:0] kernel_22;
    reg [7:0] pixel_00;
    reg [7:0] pixel_01;
    reg [7:0] pixel_02;
    reg [7:0] pixel_10;
    reg [7:0] pixel_11;
    reg [7:0] pixel_12;
    reg [7:0] pixel_20;
    reg [7:0] pixel_21;
    reg [7:0] pixel_22;
    wire [15:0] conv_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    image_convolution dut (
        .kernel_00(kernel_00),
        .kernel_01(kernel_01),
        .kernel_02(kernel_02),
        .kernel_10(kernel_10),
        .kernel_11(kernel_11),
        .kernel_12(kernel_12),
        .kernel_20(kernel_20),
        .kernel_21(kernel_21),
        .kernel_22(kernel_22),
        .pixel_00(pixel_00),
        .pixel_01(pixel_01),
        .pixel_02(pixel_02),
        .pixel_10(pixel_10),
        .pixel_11(pixel_11),
        .pixel_12(pixel_12),
        .pixel_20(pixel_20),
        .pixel_21(pixel_21),
        .pixel_22(pixel_22),
        .conv_output(conv_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            kernel_00 = 8'h00; kernel_01 = 8'h00; kernel_02 = 8'h00;
            kernel_10 = 8'h00; kernel_11 = 8'h00; kernel_12 = 8'h00;
            kernel_20 = 8'h00; kernel_21 = 8'h00; kernel_22 = 8'h00;
            pixel_00  = 8'h00; pixel_01  = 8'h00; pixel_02  = 8'h00;
            pixel_10  = 8'h00; pixel_11  = 8'h00; pixel_12  = 8'h00;
            pixel_20  = 8'h00; pixel_21  = 8'h00; pixel_22  = 8'h00;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Identity Kernel", test_num);
            kernel_00 = 8'd0; kernel_01 = 8'd0; kernel_02 = 8'd0;
            kernel_10 = 8'd0; kernel_11 = 8'd1; kernel_12 = 8'd0;
            kernel_20 = 8'd0; kernel_21 = 8'd0; kernel_22 = 8'd0;
            pixel_00  = 8'hAA; pixel_01  = 8'hBB; pixel_02  = 8'hCC;
            pixel_10  = 8'h11; pixel_11  = 8'h55; pixel_12  = 8'h22;
            pixel_20  = 8'h33; pixel_21  = 8'h44; pixel_22  = 8'h66;
            #1;

            check_outputs(16'h0055);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Box Blur Logic", test_num);
            kernel_00 = 8'd1; kernel_01 = 8'd1; kernel_02 = 8'd1;
            kernel_10 = 8'd1; kernel_11 = 8'd1; kernel_12 = 8'd1;
            kernel_20 = 8'd1; kernel_21 = 8'd1; kernel_22 = 8'd1;
            pixel_00  = 8'd10; pixel_01  = 8'd10; pixel_02  = 8'd10;
            pixel_10  = 8'd10; pixel_11  = 8'd10; pixel_12  = 8'd10;
            pixel_20  = 8'd10; pixel_21  = 8'd10; pixel_22  = 8'd10;
            #1;

            check_outputs(16'd90);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Max Input Values", test_num);
            kernel_00 = 8'd1; kernel_01 = 8'd1; kernel_02 = 8'd1;
            kernel_10 = 8'd1; kernel_11 = 8'd1; kernel_12 = 8'd1;
            kernel_20 = 8'd1; kernel_21 = 8'd1; kernel_22 = 8'd1;
            pixel_00  = 8'hFF; pixel_01  = 8'hFF; pixel_02  = 8'hFF;
            pixel_10  = 8'hFF; pixel_11  = 8'hFF; pixel_12  = 8'hFF;
            pixel_20  = 8'hFF; pixel_21  = 8'hFF; pixel_22  = 8'hFF;
            #1;

            check_outputs(16'h08F7);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero-Padding Boundary Condition", test_num);

            kernel_00 = 8'd1; kernel_01 = 8'd1; kernel_02 = 8'd1;
            kernel_10 = 8'd1; kernel_11 = 8'd1; kernel_12 = 8'd1;
            kernel_20 = 8'd1; kernel_21 = 8'd1; kernel_22 = 8'd1;

            pixel_00  = 8'h00; pixel_01  = 8'h00; pixel_02  = 8'h00;
            pixel_10  = 8'h00; pixel_11  = 8'd50; pixel_12  = 8'd50;
            pixel_20  = 8'h00; pixel_21  = 8'd50; pixel_22  = 8'd50;

            #1;


            check_outputs(16'h00C8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Weighted Coefficients", test_num);

            kernel_00 = 8'd1; kernel_01 = 8'd2; kernel_02 = 8'd3;
            kernel_10 = 8'd4; kernel_11 = 8'd5; kernel_12 = 8'd6;
            kernel_20 = 8'd7; kernel_21 = 8'd8; kernel_22 = 8'd9;

            pixel_00  = 8'd2; pixel_01  = 8'd2; pixel_02  = 8'd2;
            pixel_10  = 8'd2; pixel_11  = 8'd2; pixel_12  = 8'd2;
            pixel_20  = 8'd2; pixel_21  = 8'd2; pixel_22  = 8'd2;

            #1;


            check_outputs(16'h005A);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("image_convolution Testbench");
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
        input [15:0] expected_conv_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_conv_output === (expected_conv_output ^ conv_output ^ expected_conv_output)) begin
                $display("PASS");
                $display("  Outputs: conv_output=%h",
                         conv_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: conv_output=%h",
                         expected_conv_output);
                $display("  Got:      conv_output=%h",
                         conv_output);
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
