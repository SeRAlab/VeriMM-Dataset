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
    wire [7:0] conv_result;

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
        .conv_result(conv_result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            kernel00 = 0; kernel01 = 0; kernel02 = 0;
            kernel10 = 0; kernel11 = 0; kernel12 = 0;
            kernel20 = 0; kernel21 = 0; kernel22 = 0;
            pixel00  = 0; pixel01  = 0; pixel02  = 0;
            pixel10  = 0; pixel11  = 0; pixel12  = 0;
            pixel20  = 0; pixel21  = 0; pixel22  = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identity Kernel", test_num);

            kernel00 = 0; kernel01 = 0; kernel02 = 0;
            kernel10 = 0; kernel11 = 1; kernel12 = 0;
            kernel20 = 0; kernel21 = 0; kernel22 = 0;

            pixel00 = 8'hAA; pixel01 = 8'hBB; pixel02 = 8'hCC;
            pixel10 = 8'hDD; pixel11 = 8'h42; pixel12 = 8'hEE;
            pixel20 = 8'h11; pixel21 = 8'h22; pixel22 = 8'h33;
            #1;

            check_outputs(8'h42);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Summation of small values", test_num);

            kernel00 = 1; kernel01 = 1; kernel02 = 1;
            kernel10 = 1; kernel11 = 1; kernel12 = 1;
            kernel20 = 1; kernel21 = 1; kernel22 = 1;

            pixel00 = 5; pixel01 = 5; pixel02 = 5;
            pixel10 = 5; pixel11 = 5; pixel12 = 5;
            pixel20 = 5; pixel21 = 5; pixel22 = 5;

            #1;


            check_outputs(8'h2D);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Specific Weights", test_num);

            kernel00 = 1; kernel01 = 0; kernel02 = 0;
            kernel10 = 0; kernel11 = 2; kernel12 = 0;
            kernel20 = 0; kernel21 = 0; kernel22 = 3;

            pixel00 = 10; pixel01 = 50; pixel02 = 50;
            pixel10 = 50; pixel11 = 20; pixel12 = 50;
            pixel20 = 50; pixel21 = 50; pixel22 = 30;

            #1;


            check_outputs(8'h8C);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Single Pixel", test_num);
            kernel00 = 1; kernel01 = 0; kernel02 = 0;
            kernel10 = 0; kernel11 = 0; kernel12 = 0;
            kernel20 = 0; kernel21 = 0; kernel22 = 0;
            pixel00  = 255; pixel01  = 0; pixel02  = 0;
            pixel10  = 0;   pixel11  = 0; pixel12  = 0;
            pixel20  = 0;   pixel21  = 0; pixel22  = 0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow Truncation", test_num);

            kernel00 = 1; kernel01 = 1; kernel02 = 1;
            kernel10 = 1; kernel11 = 1; kernel12 = 1;
            kernel20 = 1; kernel21 = 1; kernel22 = 1;

            pixel00 = 30; pixel01 = 30; pixel02 = 30;
            pixel10 = 30; pixel11 = 30; pixel12 = 30;
            pixel20 = 30; pixel21 = 30; pixel22 = 30;


            #1;



            check_outputs(8'h0E);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Edge Pattern Weights", test_num);

            kernel00 = 1; kernel01 = 2; kernel02 = 1;
            kernel10 = 0; kernel11 = 0; kernel12 = 0;
            kernel20 = 0; kernel21 = 0; kernel22 = 0;

            pixel00 = 10; pixel01 = 10; pixel02 = 10;
            pixel10 = 100;pixel11 = 100;pixel12 = 100;
            pixel20 = 200;pixel21 = 200;pixel22 = 200;

            #1;


            check_outputs(8'h28);
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
        input [7:0] expected_conv_result;
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
