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
    wire [7:0] result;

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
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Identity Kernel (Center = 1, others = 0)", test_num);

            kernel00 = 8'd0; kernel01 = 8'd0; kernel02 = 8'd0;
            kernel10 = 8'd0; kernel11 = 8'd1; kernel12 = 8'd0;
            kernel20 = 8'd0; kernel21 = 8'd0; kernel22 = 8'd0;

            pixel00 = 8'd10; pixel01 = 8'd20; pixel02 = 8'd30;
            pixel10 = 8'd40; pixel11 = 8'd50; pixel12 = 8'd60;
            pixel20 = 8'd70; pixel21 = 8'd80; pixel22 = 8'd90;

            #1;


            check_outputs(8'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros Kernel", test_num);

            kernel00 = 0; kernel01 = 0; kernel02 = 0;
            kernel10 = 0; kernel11 = 0; kernel12 = 0;
            kernel20 = 0; kernel21 = 0; kernel22 = 0;

            pixel00 = 255; pixel01 = 255; pixel02 = 255;
            pixel10 = 255; pixel11 = 255; pixel12 = 255;
            pixel20 = 255; pixel21 = 255; pixel22 = 255;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Uniform Sum (Kernel=1, Pixel=10)", test_num);

            kernel00 = 1; kernel01 = 1; kernel02 = 1;
            kernel10 = 1; kernel11 = 1; kernel12 = 1;
            kernel20 = 1; kernel21 = 1; kernel22 = 1;

            pixel00 = 10; pixel01 = 10; pixel02 = 10;
            pixel10 = 10; pixel11 = 10; pixel12 = 10;
            pixel20 = 10; pixel21 = 10; pixel22 = 10;

            #1;


            check_outputs(8'd90);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Result Overflow (Sum > 255)", test_num);

            kernel00 = 1; kernel01 = 1; kernel02 = 1;
            kernel10 = 1; kernel11 = 1; kernel12 = 1;
            kernel20 = 1; kernel21 = 1; kernel22 = 1;

            pixel00 = 100; pixel01 = 100; pixel02 = 100;
            pixel10 = 100; pixel11 = 100; pixel12 = 100;
            pixel20 = 100; pixel21 = 100; pixel22 = 100;

            #1;


            check_outputs(8'd132);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum Values and Truncation", test_num);

            kernel00 = 255; kernel01 = 255; kernel02 = 255;
            kernel10 = 255; kernel11 = 255; kernel12 = 255;
            kernel20 = 255; kernel21 = 255; kernel22 = 255;

            pixel00 = 255; pixel01 = 255; pixel02 = 255;
            pixel10 = 255; pixel11 = 255; pixel12 = 255;
            pixel20 = 255; pixel21 = 255; pixel22 = 255;


            #1;



            check_outputs(8'h09);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Weighted Average (Kernel factors)", test_num);

            kernel00 = 1; kernel01 = 2; kernel02 = 1;
            kernel10 = 2; kernel11 = 4; kernel12 = 2;
            kernel20 = 1; kernel21 = 2; kernel22 = 1;

            pixel00 = 5; pixel01 = 5; pixel02 = 5;
            pixel10 = 5; pixel11 = 5; pixel12 = 5;
            pixel20 = 5; pixel21 = 5; pixel22 = 5;


            #1;



            check_outputs(8'd80);
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
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
