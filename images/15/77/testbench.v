`timescale 1ns/1ps

module convolution_3x3_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] kernel00;
    reg [7:0] kernel01;
    reg [7:0] kernel02;
    reg [7:0] kernel10;
    reg [7:0] kernel11;
    reg [7:0] kernel12;
    reg [7:0] kernel20;
    reg [7:0] kernel21;
    reg [7:0] kernel22;
    reg [7:0] pixel00;
    reg [7:0] pixel01;
    reg [7:0] pixel02;
    reg [7:0] pixel10;
    reg [7:0] pixel11;
    reg [7:0] pixel12;
    reg [7:0] pixel20;
    reg [7:0] pixel21;
    reg [7:0] pixel22;
    wire [15:0] output_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    convolution_3x3 dut (
        .kernel00(kernel00),
        .kernel01(kernel01),
        .kernel02(kernel02),
        .kernel10(kernel10),
        .kernel11(kernel11),
        .kernel12(kernel12),
        .kernel20(kernel20),
        .kernel21(kernel21),
        .kernel22(kernel22),
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
            test_num = 1;
            $display("Testcase %0d: All Zeros - Output should be 0", test_num);

            kernel00 = 8'd0; kernel01 = 8'd0; kernel02 = 8'd0;
            kernel10 = 8'd0; kernel11 = 8'd0; kernel12 = 8'd0;
            kernel20 = 8'd0; kernel21 = 8'd0; kernel22 = 8'd0;
            pixel00  = 8'd0; pixel01  = 8'd0; pixel02  = 8'd0;
            pixel10  = 8'd0; pixel11  = 8'd0; pixel12  = 8'd0;
            pixel20  = 8'd0; pixel21  = 8'd0; pixel22  = 8'd0;

            #1;


            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Identity Kernel - Output should match center pixel (pixel11)", test_num);

            kernel00 = 8'd0; kernel01 = 8'd0; kernel02 = 8'd0;
            kernel10 = 8'd0; kernel11 = 8'd1; kernel12 = 8'd0;
            kernel20 = 8'd0; kernel21 = 8'd0; kernel22 = 8'd0;

            pixel00 = 8'hAA; pixel01 = 8'hBB; pixel02 = 8'hCC;
            pixel10 = 8'hDD; pixel11 = 8'h55; pixel12 = 8'hEE;
            pixel20 = 8'hFF; pixel21 = 8'h11; pixel22 = 8'h22;

            #1;


            check_outputs(16'h0055);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Box Filter (All 1s) - Output should be sum of pixels", test_num);

            kernel00 = 8'd1; kernel01 = 8'd1; kernel02 = 8'd1;
            kernel10 = 8'd1; kernel11 = 8'd1; kernel12 = 8'd1;
            kernel20 = 8'd1; kernel21 = 8'd1; kernel22 = 8'd1;

            pixel00 = 8'd1; pixel01 = 8'd2; pixel02 = 8'd3;
            pixel10 = 8'd4; pixel11 = 8'd5; pixel12 = 8'd6;
            pixel20 = 8'd7; pixel21 = 8'd8; pixel22 = 8'd9;


            #1;



            check_outputs(16'd45);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Weighted Sum - Each element multiplication", test_num);

            kernel00 = 8'd2; kernel01 = 8'd2; kernel02 = 8'd2;
            kernel10 = 8'd2; kernel11 = 8'd2; kernel12 = 8'd2;
            kernel20 = 8'd2; kernel21 = 8'd2; kernel22 = 8'd2;

            pixel00 = 8'd10; pixel01 = 8'd10; pixel02 = 8'd10;
            pixel10 = 8'd10; pixel11 = 8'd10; pixel12 = 8'd10;
            pixel20 = 8'd10; pixel21 = 8'd10; pixel22 = 8'd10;


            #1;



            check_outputs(16'd180);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Diagonal Convolution", test_num);

            kernel00 = 8'd10; kernel01 = 8'd0;  kernel02 = 8'd0;
            kernel10 = 8'd0;  kernel11 = 8'd10; kernel12 = 8'd0;
            kernel20 = 8'd0;  kernel21 = 8'd0;  kernel22 = 8'd10;

            pixel00 = 8'd5;  pixel01 = 8'd100; pixel02 = 8'd100;
            pixel10 = 8'd100; pixel11 = 8'd6;  pixel12 = 8'd100;
            pixel20 = 8'd100; pixel21 = 8'd100; pixel22 = 8'd7;


            #1;



            check_outputs(16'd180);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Large Values (Within 16-bit range)", test_num);

            kernel00 = 8'd100; kernel01 = 8'd100; kernel02 = 8'd100;
            kernel10 = 8'd100; kernel11 = 8'd100; kernel12 = 8'd100;
            kernel20 = 8'd100; kernel21 = 8'd100; kernel22 = 8'd100;

            pixel00 = 8'd50; pixel01 = 8'd50; pixel02 = 8'd50;
            pixel10 = 8'd50; pixel11 = 8'd50; pixel12 = 8'd50;
            pixel20 = 8'd50; pixel21 = 8'd50; pixel22 = 8'd50;

            #1;


            check_outputs(16'hAFC8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("convolution_3x3 Testbench");
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
