`timescale 1ns/1ps

module image_convolution_tb;

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
    image_convolution dut (
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
            test_num = test_num + 1;
            $display("\nTestcase %0d: All inputs zero", test_num);
            kernel00 = 8'd0; kernel01 = 8'd0; kernel02 = 8'd0;
            kernel10 = 8'd0; kernel11 = 8'd0; kernel12 = 8'd0;
            kernel20 = 8'd0; kernel21 = 8'd0; kernel22 = 8'd0;
            pixel00 = 8'd0;  pixel01 = 8'd0;  pixel02 = 8'd0;
            pixel10 = 8'd0;  pixel11 = 8'd0;  pixel12 = 8'd0;
            pixel20 = 8'd0;  pixel21 = 8'd0;  pixel22 = 8'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Identity Kernel", test_num);

            kernel00 = 8'd0; kernel01 = 8'd0; kernel02 = 8'd0;
            kernel10 = 8'd0; kernel11 = 8'd1; kernel12 = 8'd0;
            kernel20 = 8'd0; kernel21 = 8'd0; kernel22 = 8'd0;

            pixel00 = 8'd10; pixel01 = 8'd20; pixel02 = 8'd30;
            pixel10 = 8'd40; pixel11 = 8'd127; pixel12 = 8'd60;
            pixel20 = 8'd70; pixel21 = 8'd80; pixel22 = 8'd90;

            #1;


            check_outputs(16'd127);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All ones kernel, uniform pixels", test_num);
            kernel00 = 8'd1; kernel01 = 8'd1; kernel02 = 8'd1;
            kernel10 = 8'd1; kernel11 = 8'd1; kernel12 = 8'd1;
            kernel20 = 8'd1; kernel21 = 8'd1; kernel22 = 8'd1;
            pixel00 = 8'd5;  pixel01 = 8'd5;  pixel02 = 8'd5;
            pixel10 = 8'd5;  pixel11 = 8'd5;  pixel12 = 8'd5;
            pixel20 = 8'd5;  pixel21 = 8'd5;  pixel22 = 8'd5;

            #1;


            check_outputs(16'd45);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative kernel coefficients (High-pass/Edge)", test_num);


            kernel00 = 8'hFF; kernel01 = 8'hFF; kernel02 = 8'hFF;
            kernel10 = 8'hFF; kernel11 = 8'd8;  kernel12 = 8'hFF;
            kernel20 = 8'hFF; kernel21 = 8'hFF; kernel22 = 8'hFF;

            pixel00 = 8'd50;  pixel01 = 8'd50;  pixel02 = 8'd50;
            pixel10 = 8'd50;  pixel11 = 8'd50;  pixel12 = 8'd50;
            pixel20 = 8'd50;  pixel21 = 8'd50;  pixel22 = 8'd50;


            #1;



            check_outputs(16'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Resulting in negative signed output", test_num);

            kernel00 = 8'hFF; kernel01 = 8'hFF; kernel02 = 8'hFF;
            kernel10 = 8'hFF; kernel11 = 8'hFF; kernel12 = 8'hFF;
            kernel20 = 8'hFF; kernel21 = 8'hFF; kernel22 = 8'hFF;

            pixel00 = 8'd10;  pixel01 = 8'd10;  pixel02 = 8'd10;
            pixel10 = 8'd10;  pixel11 = 8'd10;  pixel12 = 8'd10;
            pixel20 = 8'd10;  pixel21 = 8'd10;  pixel22 = 8'd10;



            #1;




            check_outputs(16'hFFA6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Larger values check", test_num);

            kernel00 = 8'd10; kernel01 = 8'd10; kernel02 = 8'd10;
            kernel10 = 8'd10; kernel11 = 8'd10; kernel12 = 8'd10;
            kernel20 = 8'd10; kernel21 = 8'd10; kernel22 = 8'd10;

            pixel00 = 8'd200; pixel01 = 8'd200; pixel02 = 8'd200;
            pixel10 = 8'd200; pixel11 = 8'd200; pixel12 = 8'd200;
            pixel20 = 8'd200; pixel21 = 8'd200; pixel22 = 8'd200;



            #1;




            check_outputs(16'h4650);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mixed coefficients", test_num);

            kernel00 = 8'h00; kernel01 = 8'hFF; kernel02 = 8'h00;
            kernel10 = 8'hFF; kernel11 = 8'd5;  kernel12 = 8'hFF;
            kernel20 = 8'h00; kernel21 = 8'hFF; kernel22 = 8'h00;

            pixel00 = 8'd10; pixel01 = 8'd20; pixel02 = 8'd30;
            pixel10 = 8'd40; pixel11 = 8'd50; pixel12 = 8'd60;
            pixel20 = 8'd70; pixel21 = 8'd80; pixel22 = 8'd90;




            #1;





            check_outputs(16'd50);
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
