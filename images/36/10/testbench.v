`timescale 1ns/1ps

module jpeg_quantization_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_value;
    reg [3:0] quant_value;
    wire [7:0] quantized_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    jpeg_quantization dut (
        .pixel_value(pixel_value),
        .quant_value(quant_value),
        .quantized_value(quantized_value)
    );
    task testcase001;

    begin
        test_num = 1;
        pixel_value = 8'd100;
        quant_value = 4'd10;
        $display("Running testcase001: Pixel=100, Quant=10 (Expected=10)");
        #1;

        check_outputs(8'd10);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        pixel_value = 8'd10;
        quant_value = 4'd3;
        $display("Running testcase002: Pixel=10, Quant=3 (Expected=3)");
        #1;

        check_outputs(8'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        pixel_value = 8'd11;
        quant_value = 4'd3;
        $display("Running testcase003: Pixel=11, Quant=3 (Expected=4)");
        #1;

        check_outputs(8'd4);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        pixel_value = 8'd5;
        quant_value = 4'd2;
        $display("Running testcase004: Pixel=5, Quant=2 (Expected=3)");
        #1;

        check_outputs(8'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        pixel_value = 8'd255;
        quant_value = 4'd1;
        $display("Running testcase005: Pixel=255, Quant=1 (Expected=255)");
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        pixel_value = 8'd255;
        quant_value = 4'd15;
        $display("Running testcase006: Pixel=255, Quant=15 (Expected=17)");
        #1;

        check_outputs(8'd17);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        pixel_value = 8'd0;
        quant_value = 4'd7;
        $display("Running testcase007: Pixel=0, Quant=7 (Expected=0)");
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        pixel_value = 8'd1;
        quant_value = 4'd2;
        $display("Running testcase008: Pixel=1, Quant=2 (Expected=1)");
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        pixel_value = 8'd1;
        quant_value = 4'd4;
        $display("Running testcase009: Pixel=1, Quant=4 (Expected=0)");
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        pixel_value = 8'd200;
        quant_value = 4'd6;
        $display("Running testcase010: Pixel=200, Quant=6 (Expected=33)");
        #1;

        check_outputs(8'd33);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("jpeg_quantization Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [7:0] expected_quantized_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_quantized_value === (expected_quantized_value ^ quantized_value ^ expected_quantized_value)) begin
                $display("PASS");
                $display("  Outputs: quantized_value=%h",
                         quantized_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quantized_value=%h",
                         expected_quantized_value);
                $display("  Got:      quantized_value=%h",
                         quantized_value);
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
