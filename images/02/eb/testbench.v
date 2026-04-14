`timescale 1ns/1ps

module conv_3x3_tb;

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
    wire [7:0] output_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    conv_3x3 dut (
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
        .output_value(output_value)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Identity Kernel (Center pixel pass-through)", test_num);

            kernel_00 = 8'd0; kernel_01 = 8'd0; kernel_02 = 8'd0;
            kernel_10 = 8'd0; kernel_11 = 8'd1; kernel_12 = 8'd0;
            kernel_20 = 8'd0; kernel_21 = 8'd0; kernel_22 = 8'd0;


            pixel_00 = 8'h11; pixel_01 = 8'h22; pixel_02 = 8'h33;
            pixel_10 = 8'h44; pixel_11 = 8'h55; pixel_12 = 8'h66;
            pixel_20 = 8'h77; pixel_21 = 8'h88; pixel_22 = 8'h99;


            #1;



            check_outputs(8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: All Zeros (Kernel is zero)", test_num);

            kernel_00 = 0; kernel_01 = 0; kernel_02 = 0;
            kernel_10 = 0; kernel_11 = 0; kernel_12 = 0;
            kernel_20 = 0; kernel_21 = 0; kernel_22 = 0;


            pixel_00 = 8'hFF; pixel_01 = 8'hFF; pixel_02 = 8'hFF;
            pixel_10 = 8'hFF; pixel_11 = 8'hFF; pixel_12 = 8'hFF;
            pixel_20 = 8'hFF; pixel_21 = 8'hFF; pixel_22 = 8'hFF;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Simple Sum (All 1s)", test_num);

            kernel_00 = 1; kernel_01 = 1; kernel_02 = 1;
            kernel_10 = 1; kernel_11 = 1; kernel_12 = 1;
            kernel_20 = 1; kernel_21 = 1; kernel_22 = 1;


            pixel_00 = 1; pixel_01 = 1; pixel_02 = 1;
            pixel_10 = 1; pixel_11 = 1; pixel_12 = 1;
            pixel_20 = 1; pixel_21 = 1; pixel_22 = 1;


            #1;



            check_outputs(8'd9);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Multiplication with constant", test_num);

            kernel_00 = 2; kernel_01 = 2; kernel_02 = 2;
            kernel_10 = 2; kernel_11 = 2; kernel_12 = 2;
            kernel_20 = 2; kernel_21 = 2; kernel_22 = 2;


            pixel_00 = 10; pixel_01 = 10; pixel_02 = 10;
            pixel_10 = 10; pixel_11 = 10; pixel_12 = 10;
            pixel_20 = 10; pixel_21 = 10; pixel_22 = 10;


            #1;



            check_outputs(8'hB4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Overflow/Truncation check", test_num);



            kernel_00 = 1; kernel_01 = 1; kernel_02 = 1;
            kernel_10 = 1; kernel_11 = 1; kernel_12 = 1;
            kernel_20 = 1; kernel_21 = 1; kernel_22 = 1;

            pixel_00 = 255; pixel_01 = 255; pixel_02 = 255;
            pixel_10 = 255; pixel_11 = 255; pixel_12 = 255;
            pixel_20 = 255; pixel_21 = 255; pixel_22 = 255;

            #1;


            check_outputs(8'hF7);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Specific weights (Diagonal)", test_num);

            kernel_00 = 1; kernel_01 = 0; kernel_02 = 0;
            kernel_10 = 0; kernel_11 = 2; kernel_12 = 0;
            kernel_20 = 0; kernel_21 = 0; kernel_22 = 3;

            pixel_00 = 10; pixel_01 = 50; pixel_02 = 50;
            pixel_10 = 50; pixel_11 = 20; pixel_12 = 50;
            pixel_20 = 50; pixel_21 = 50; pixel_22 = 30;


            #1;



            check_outputs(8'h8C);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("conv_3x3 Testbench");
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
        input [7:0] expected_output_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_value === (expected_output_value ^ output_value ^ expected_output_value)) begin
                $display("PASS");
                $display("  Outputs: output_value=%h",
                         output_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_value=%h",
                         expected_output_value);
                $display("  Got:      output_value=%h",
                         output_value);
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
