`timescale 1ns/1ps

module image_convolution_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_00;
    reg [7:0] pixel_01;
    reg [7:0] pixel_02;
    reg [7:0] pixel_10;
    reg [7:0] pixel_11;
    reg [7:0] pixel_12;
    reg [7:0] pixel_20;
    reg [7:0] pixel_21;
    reg [7:0] pixel_22;
    wire [15:0] conv_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    image_convolution dut (
        .pixel_00(pixel_00),
        .pixel_01(pixel_01),
        .pixel_02(pixel_02),
        .pixel_10(pixel_10),
        .pixel_11(pixel_11),
        .pixel_12(pixel_12),
        .pixel_20(pixel_20),
        .pixel_21(pixel_21),
        .pixel_22(pixel_22),
        .conv_result(conv_result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            pixel_00 = 8'd0; pixel_01 = 8'd0; pixel_02 = 8'd0;
            pixel_10 = 8'd0; pixel_11 = 8'd0; pixel_12 = 8'd0;
            pixel_20 = 8'd0; pixel_21 = 8'd0; pixel_22 = 8'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            pixel_00 = 8'd1; pixel_01 = 8'd1; pixel_02 = 8'd1;
            pixel_10 = 8'd1; pixel_11 = 8'd1; pixel_12 = 8'd1;
            pixel_20 = 8'd1; pixel_21 = 8'd1; pixel_22 = 8'd1;

            #1;


            check_outputs(16'd9);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Center Pixel Only", test_num);
            pixel_00 = 8'd0;   pixel_01 = 8'd0;   pixel_02 = 8'd0;
            pixel_10 = 8'd0;   pixel_11 = 8'd255; pixel_12 = 8'd0;
            pixel_20 = 8'd0;   pixel_21 = 8'd0;   pixel_22 = 8'd0;

            #1;


            check_outputs(16'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Values", test_num);
            pixel_00 = 8'hFF; pixel_01 = 8'hFF; pixel_02 = 8'hFF;
            pixel_10 = 8'hFF; pixel_11 = 8'hFF; pixel_12 = 8'hFF;
            pixel_20 = 8'hFF; pixel_21 = 8'hFF; pixel_22 = 8'hFF;

            #1;


            check_outputs(16'd2295);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Diagonal Pattern", test_num);
            pixel_00 = 8'd10; pixel_01 = 8'd0;  pixel_02 = 8'd0;
            pixel_10 = 8'd0;  pixel_11 = 8'd20; pixel_12 = 8'd0;
            pixel_20 = 8'd0;  pixel_21 = 8'd0;  pixel_22 = 8'd30;

            #1;


            check_outputs(16'd60);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checkerboard Pattern", test_num);
            pixel_00 = 8'd100; pixel_01 = 8'd0;   pixel_02 = 8'd100;
            pixel_10 = 8'd0;   pixel_11 = 8'd100; pixel_12 = 8'd0;
            pixel_20 = 8'd100; pixel_21 = 8'd0;   pixel_22 = 8'd100;

            #1;


            check_outputs(16'd500);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Values", test_num);
            pixel_00 = 8'd1; pixel_01 = 8'd2; pixel_02 = 8'd3;
            pixel_10 = 8'd4; pixel_11 = 8'd5; pixel_12 = 8'd6;
            pixel_20 = 8'd7; pixel_21 = 8'd8; pixel_22 = 8'd9;

            #1;


            check_outputs(16'd45);
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
        input [15:0] expected_conv_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_conv_result === (expected_conv_result ^ conv_result ^ expected_conv_result)) begin
                $display("PASS");
                $display("  Outputs: conv_result=%h",
                         conv_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: conv_result=%h",
                         expected_conv_result);
                $display("  Got:      conv_result=%h",
                         conv_result);
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
