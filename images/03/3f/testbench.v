`timescale 1ns/1ps

module non_max_suppression_tb;

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
    wire [7:0] output_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    non_max_suppression dut (
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
            $display("Testcase %0d: Center pixel is strictly the maximum", test_num);
            pixel00 = 8'd10; pixel01 = 8'd20; pixel02 = 8'd30;
            pixel10 = 8'd40; pixel11 = 8'd200; pixel12 = 8'd50;
            pixel20 = 8'd60; pixel21 = 8'd70; pixel22 = 8'd80;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Neighbor (pixel00) is the maximum", test_num);
            pixel00 = 8'd255; pixel01 = 8'd100; pixel02 = 8'd100;
            pixel10 = 8'd100; pixel11 = 8'd200; pixel12 = 8'd100;
            pixel20 = 8'd100; pixel21 = 8'd100; pixel22 = 8'd100;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All pixels are equal (All 0)", test_num);
            pixel00 = 8'd0; pixel01 = 8'd0; pixel02 = 8'd0;
            pixel10 = 8'd0; pixel11 = 8'd0; pixel12 = 8'd0;
            pixel20 = 8'd0; pixel21 = 8'd0; pixel22 = 8'd0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All pixels are equal (All 255)", test_num);
            pixel00 = 8'd255; pixel01 = 8'd255; pixel02 = 8'd255;
            pixel10 = 8'd255; pixel11 = 8'd255; pixel12 = 8'd255;
            pixel20 = 8'd255; pixel21 = 8'd255; pixel22 = 8'd255;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Center tied with one neighbor for maximum", test_num);
            pixel00 = 8'd50;  pixel01 = 8'd50;  pixel02 = 8'd50;
            pixel10 = 8'd50;  pixel11 = 8'd150; pixel12 = 8'd150;
            pixel20 = 8'd50;  pixel21 = 8'd50;  pixel22 = 8'd50;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Center is just below maximum", test_num);
            pixel00 = 8'd127; pixel01 = 8'd127; pixel02 = 8'd127;
            pixel10 = 8'd127; pixel11 = 8'd127; pixel12 = 8'd128;
            pixel20 = 8'd127; pixel21 = 8'd127; pixel22 = 8'd127;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Neighbor (pixel22) is the maximum", test_num);
            pixel00 = 8'h01; pixel01 = 8'h02; pixel02 = 8'h03;
            pixel10 = 8'h04; pixel11 = 8'h05; pixel12 = 8'h06;
            pixel20 = 8'h07; pixel21 = 8'h08; pixel22 = 8'hFF;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Center is maximum, others are near-zero", test_num);
            pixel00 = 8'h01; pixel01 = 8'h01; pixel02 = 8'h01;
            pixel10 = 8'h01; pixel11 = 8'h02; pixel12 = 8'h01;
            pixel20 = 8'h01; pixel21 = 8'h01; pixel22 = 8'h01;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("non_max_suppression Testbench");
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
