`timescale 1ns/1ps

module convolution_3x3_tb;

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
    wire [15:0] output_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    convolution_3x3 dut (
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
        .output_pixel(output_pixel)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All Zeros", test_num);
            kernel_00 = 0; kernel_01 = 0; kernel_02 = 0;
            kernel_10 = 0; kernel_11 = 0; kernel_12 = 0;
            kernel_20 = 0; kernel_21 = 0; kernel_22 = 0;
            pixel_00 = 0;  pixel_01 = 0;  pixel_02 = 0;
            pixel_10 = 0;  pixel_11 = 0;  pixel_12 = 0;
            pixel_20 = 0;  pixel_21 = 0;  pixel_22 = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Identity Kernel", test_num);

            kernel_00 = 0; kernel_01 = 0; kernel_02 = 0;
            kernel_10 = 0; kernel_11 = 1; kernel_12 = 0;
            kernel_20 = 0; kernel_21 = 0; kernel_22 = 0;

            pixel_00 = 1;  pixel_01 = 2;  pixel_02 = 3;
            pixel_10 = 4;  pixel_11 = 55; pixel_12 = 6;
            pixel_20 = 7;  pixel_21 = 8;  pixel_22 = 9;

            #1;


            check_outputs(16'h0037);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Simple Box Filter", test_num);
            kernel_00 = 1; kernel_01 = 1; kernel_02 = 1;
            kernel_10 = 1; kernel_11 = 1; kernel_12 = 1;
            kernel_20 = 1; kernel_21 = 1; kernel_22 = 1;

            pixel_00 = 10; pixel_01 = 10; pixel_02 = 10;
            pixel_10 = 10; pixel_11 = 10; pixel_12 = 10;
            pixel_20 = 10; pixel_21 = 10; pixel_22 = 10;

            #1;


            check_outputs(16'h005A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Weighted Sum", test_num);

            kernel_00 = 1; kernel_01 = 2; kernel_02 = 1;
            kernel_10 = 0; kernel_11 = 0; kernel_12 = 0;
            kernel_20 = 1; kernel_21 = 2; kernel_22 = 1;

            pixel_00 = 100; pixel_01 = 100; pixel_02 = 100;
            pixel_10 = 100; pixel_11 = 100; pixel_12 = 100;
            pixel_20 = 100; pixel_21 = 100; pixel_22 = 100;


            #1;



            check_outputs(16'h0320);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Maximum Values", test_num);

            kernel_00 = 255; kernel_01 = 255; kernel_02 = 255;
            kernel_10 = 255; kernel_11 = 255; kernel_12 = 255;
            kernel_20 = 255; kernel_21 = 255; kernel_22 = 255;
            pixel_00 = 255;  pixel_01 = 255;  pixel_02 = 255;
            pixel_10 = 255;  pixel_11 = 255;  pixel_12 = 255;
            pixel_20 = 255;  pixel_21 = 255;  pixel_22 = 255;


            #1;



            check_outputs(16'hED89);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: High Dynamic Range", test_num);
            kernel_00 = 200; kernel_01 = 0; kernel_02 = 200;
            kernel_10 = 0;   kernel_11 = 5; kernel_12 = 0;
            kernel_20 = 200; kernel_21 = 0; kernel_22 = 200;
            pixel_00 = 50;   pixel_01 = 255; pixel_02 = 50;
            pixel_10 = 255;  pixel_11 = 100; pixel_12 = 255;
            pixel_20 = 50;   pixel_21 = 255; pixel_22 = 50;


            #1;



            check_outputs(16'h9E34);
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
