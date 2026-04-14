`timescale 1ns/1ps

module jpeg_quantization_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [7:0] pixel_value;
    wire [7:0] quantized_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    jpeg_quantization dut (
        .enable(enable),
        .pixel_value(pixel_value),
        .quantized_value(quantized_value)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Enable=1, Pixel=0 (Boundary Low)", test_num);
        enable = 1;
        pixel_value = 8'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Enable=1, Pixel=31 (Edge of Floor)", test_num);
        enable = 1;
        pixel_value = 8'd31;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Enable=1, Pixel=32 (Threshold)", test_num);
        enable = 1;
        pixel_value = 8'd32;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Enable=1, Pixel=63", test_num);
        enable = 1;
        pixel_value = 8'd63;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Enable=1, Pixel=64", test_num);
        enable = 1;
        pixel_value = 8'd64;
        #1;

        check_outputs(8'd2);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Enable=1, Pixel=128", test_num);
        enable = 1;
        pixel_value = 8'd128;
        #1;

        check_outputs(8'd4);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Enable=1, Pixel=255 (Boundary High)", test_num);
        enable = 1;
        pixel_value = 8'd255;
        #1;

        check_outputs(8'd7);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Enable=0, Pixel=255 (Disabled Check)", test_num);
        enable = 0;
        pixel_value = 8'd255;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Enable=0, Pixel=32 (Disabled Check)", test_num);
        enable = 0;
        pixel_value = 8'd32;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Enable=1, Pixel=160", test_num);
        enable = 1;
        pixel_value = 8'd160;
        #1;

        check_outputs(8'd5);
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
