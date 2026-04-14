`timescale 1ns/1ps

module image_convolution_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] kernel;
    reg [7:0] pixel00;
    reg [7:0] pixel01;
    reg [7:0] pixel02;
    reg [7:0] pixel10;
    reg [7:0] pixel11;
    reg [7:0] pixel12;
    reg [7:0] pixel20;
    reg [7:0] pixel21;
    reg [7:0] pixel22;
    wire [7:0] output_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    image_convolution dut (
        .kernel(kernel),
        .pixel00(pixel00),
        .pixel01(pixel01),
        .pixel02(pixel02),
        .pixel10(pixel10),
        .pixel11(pixel11),
        .pixel12(pixel12),
        .pixel20(pixel20),
        .pixel21(pixel21),
        .pixel22(pixel22),
        .output_pixel(output_pixel)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity Filter (Center Weight Only)", test_num);
            kernel = 9'b000_010_000;
            pixel00 = 8'd10;  pixel01 = 8'd20;  pixel02 = 8'd30;
            pixel10 = 8'd40;  pixel11 = 8'd128; pixel12 = 8'd60;
            pixel20 = 8'd70;  pixel21 = 8'd80;  pixel22 = 8'd90;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Weights Zero", test_num);
            kernel = 9'b000_000_000;
            pixel00 = 8'hFF; pixel01 = 8'hFF; pixel02 = 8'hFF;
            pixel10 = 8'hFF; pixel11 = 8'hFF; pixel12 = 8'hFF;
            pixel20 = 8'hFF; pixel21 = 8'hFF; pixel22 = 8'hFF;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Sum (No Overflow)", test_num);
            kernel = 9'b000_000_111;
            pixel00 = 8'd10;  pixel01 = 8'd25;  pixel02 = 8'd15;
            pixel10 = 8'd0;   pixel11 = 8'd0;   pixel12 = 8'd0;
            pixel20 = 8'd0;   pixel21 = 8'd0;   pixel22 = 8'd0;
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sum with Clamping (Overflow)", test_num);
            kernel = 9'b000_000_011;
            pixel00 = 8'd200; pixel01 = 8'd100; pixel02 = 8'd0;
            pixel10 = 8'd0;   pixel11 = 8'd0;   pixel12 = 8'd0;
            pixel20 = 8'd0;   pixel21 = 8'd0;   pixel22 = 8'd0;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Saturation", test_num);
            kernel = 9'b111_111_111;
            pixel00 = 8'd255; pixel01 = 8'd255; pixel02 = 8'd255;
            pixel10 = 8'd255; pixel11 = 8'd255; pixel12 = 8'd255;
            pixel20 = 8'd255; pixel21 = 8'd255; pixel22 = 8'd255;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sparse Kernel Test", test_num);
            kernel = 9'b100_000_001;
            pixel00 = 8'd45;  pixel01 = 8'd255; pixel02 = 8'd255;
            pixel10 = 8'd255; pixel11 = 8'd255; pixel12 = 8'd255;
            pixel20 = 8'd255; pixel21 = 8'd255; pixel22 = 8'd55;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checkerboard Weights", test_num);
            kernel = 9'b101_010_101;
            pixel00 = 8'd10; pixel01 = 8'd0; pixel02 = 8'd10;
            pixel10 = 8'd0;  pixel11 = 8'd10; pixel12 = 8'd0;
            pixel20 = 8'd10; pixel21 = 8'd0; pixel22 = 8'd10;
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Clamping (Exact 255)", test_num);
            kernel = 9'b000_000_011;
            pixel00 = 8'd127; pixel01 = 8'd128; pixel02 = 8'd0;
            pixel10 = 8'd0;   pixel11 = 8'd0;   pixel12 = 8'd0;
            pixel20 = 8'd0;   pixel21 = 8'd0;   pixel22 = 8'd0;
            #1;

            check_outputs(8'd255);
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
        input [7:0] expected_output_pixel;
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
