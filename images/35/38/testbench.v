`timescale 1ns/1ps

module image_convolution_tb;

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
    wire [15:0] conv_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    image_convolution dut (
        .pixel00(pixel00),
        .pixel01(pixel01),
        .pixel02(pixel02),
        .pixel10(pixel10),
        .pixel11(pixel11),
        .pixel12(pixel12),
        .pixel20(pixel20),
        .pixel21(pixel21),
        .pixel22(pixel22),
        .conv_out(conv_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Pixels Zero", test_num);
        pixel00 = 8'd0; pixel01 = 8'd0; pixel02 = 8'd0;
        pixel10 = 8'd0; pixel11 = 8'd0; pixel12 = 8'd0;
        pixel20 = 8'd0; pixel21 = 8'd0; pixel22 = 8'd0;

        #1;


        check_outputs(16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Impulse at Center (pixel11=1)", test_num);
        pixel00 = 8'd0; pixel01 = 8'd0; pixel02 = 8'd0;
        pixel10 = 8'd0; pixel11 = 8'd1; pixel12 = 8'd0;
        pixel20 = 8'd0; pixel21 = 8'd0; pixel22 = 8'd0;

        #1;


        check_outputs(16'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Impulse at Top-Left (pixel00=1)", test_num);
        pixel00 = 8'd1; pixel01 = 8'd0; pixel02 = 8'd0;
        pixel10 = 8'd0; pixel11 = 8'd0; pixel12 = 8'd0;
        pixel20 = 8'd0; pixel21 = 8'd0; pixel22 = 8'd0;

        #1;


        check_outputs(16'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Pixels Max (255)", test_num);
        pixel00 = 8'd255; pixel01 = 8'd255; pixel02 = 8'd255;
        pixel10 = 8'd255; pixel11 = 8'd255; pixel12 = 8'd255;
        pixel20 = 8'd255; pixel21 = 8'd255; pixel22 = 8'd255;

        #1;


        check_outputs(16'd2295);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Checkerboard Pattern", test_num);
        pixel00 = 8'd10; pixel01 = 8'd0;  pixel02 = 8'd10;
        pixel10 = 8'd0;  pixel11 = 8'd10; pixel12 = 8'd0;
        pixel20 = 8'd10; pixel21 = 8'd0;  pixel22 = 8'd10;

        #1;


        check_outputs(16'd50);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Gradient Pattern (1-9)", test_num);
        pixel00 = 8'd1; pixel01 = 8'd2; pixel02 = 8'd3;
        pixel10 = 8'd4; pixel11 = 8'd5; pixel12 = 8'd6;
        pixel20 = 8'd7; pixel21 = 8'd8; pixel22 = 8'd9;

        #1;


        check_outputs(16'd45);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Uniform Mid-range (128)", test_num);
        pixel00 = 8'd128; pixel01 = 8'd128; pixel02 = 8'd128;
        pixel10 = 8'd128; pixel11 = 8'd128; pixel12 = 8'd128;
        pixel20 = 8'd128; pixel21 = 8'd128; pixel22 = 8'd128;

        #1;


        check_outputs(16'd1152);
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
        input [15:0] expected_conv_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_conv_out === (expected_conv_out ^ conv_out ^ expected_conv_out)) begin
                $display("PASS");
                $display("  Outputs: conv_out=%h",
                         conv_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: conv_out=%h",
                         expected_conv_out);
                $display("  Got:      conv_out=%h",
                         conv_out);
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
