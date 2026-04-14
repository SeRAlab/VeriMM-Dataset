`timescale 1ns/1ps

module sobel_edge_detector_tb;

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
    wire [10:0] gradient_magnitude;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sobel_edge_detector dut (
        .pixel00(pixel00),
        .pixel01(pixel01),
        .pixel02(pixel02),
        .pixel10(pixel10),
        .pixel11(pixel11),
        .pixel12(pixel12),
        .pixel20(pixel20),
        .pixel21(pixel21),
        .pixel22(pixel22),
        .gradient_magnitude(gradient_magnitude)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros (Flat Black)", test_num);
            pixel00 = 8'd0; pixel01 = 8'd0; pixel02 = 8'd0;
            pixel10 = 8'd0; pixel11 = 8'd0; pixel12 = 8'd0;
            pixel20 = 8'd0; pixel21 = 8'd0; pixel22 = 8'd0;
            #1;

            check_outputs(11'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All White (Flat White)", test_num);
            pixel00 = 8'd255; pixel01 = 8'd255; pixel02 = 8'd255;
            pixel10 = 8'd255; pixel11 = 8'd255; pixel12 = 8'd255;
            pixel20 = 8'd255; pixel21 = 8'd255; pixel22 = 8'd255;
            #1;

            check_outputs(11'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Perfect Vertical Edge", test_num);


            pixel00 = 8'd0;   pixel01 = 8'd0; pixel02 = 8'd255;
            pixel10 = 8'd0;   pixel11 = 8'd0; pixel12 = 8'd255;
            pixel20 = 8'd0;   pixel21 = 8'd0; pixel22 = 8'd255;
            #1;

            check_outputs(11'd1020);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Perfect Horizontal Edge", test_num);


            pixel00 = 8'd0;   pixel01 = 8'd0;   pixel02 = 8'd0;
            pixel10 = 8'd0;   pixel11 = 8'd0;   pixel12 = 8'd0;
            pixel20 = 8'd255; pixel21 = 8'd255; pixel22 = 8'd255;
            #1;

            check_outputs(11'd1020);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Diagonal Gradient", test_num);



            pixel00 = 8'd0;   pixel01 = 8'd0;   pixel02 = 8'd255;
            pixel10 = 8'd0;   pixel11 = 8'd0;   pixel12 = 8'd255;
            pixel20 = 8'd255; pixel21 = 8'd255; pixel22 = 8'd255;
            #1;

            check_outputs(11'd1530);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Pixel Noise (Center)", test_num);


            pixel00 = 8'd0; pixel01 = 8'd0;   pixel02 = 8'd0;
            pixel10 = 8'd0; pixel11 = 8'd255; pixel12 = 8'd0;
            pixel20 = 8'd0; pixel21 = 8'd0;   pixel22 = 8'd0;
            #1;

            check_outputs(11'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Possible Gradient Combination", test_num);








            pixel00 = 8'd0;   pixel01 = 8'd0;   pixel02 = 8'd0;
            pixel10 = 8'd0;   pixel11 = 8'd0;   pixel12 = 8'd255;
            pixel20 = 8'd255; pixel21 = 8'd255; pixel22 = 8'd255;
            #1;

            check_outputs(11'd1530);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sobel_edge_detector Testbench");
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
        input [10:0] expected_gradient_magnitude;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gradient_magnitude === (expected_gradient_magnitude ^ gradient_magnitude ^ expected_gradient_magnitude)) begin
                $display("PASS");
                $display("  Outputs: gradient_magnitude=%h",
                         gradient_magnitude);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gradient_magnitude=%h",
                         expected_gradient_magnitude);
                $display("  Got:      gradient_magnitude=%h",
                         gradient_magnitude);
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
