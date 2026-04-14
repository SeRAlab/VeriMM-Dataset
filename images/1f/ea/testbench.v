`timescale 1ns/1ps

module png_filter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] left_pixel;
    reg [7:0] pixel;
    wire [7:0] filtered_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    png_filter dut (
        .left_pixel(left_pixel),
        .pixel(pixel),
        .filtered_pixel(filtered_pixel)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            pixel = 8'd50;
            left_pixel = 8'd20;
            $display("Test %0d: Basic Subtraction - Pixel: %d, Left: %d", test_num, pixel, left_pixel);
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            pixel = 8'd255;
            left_pixel = 8'd0;
            $display("Test %0d: Maximum Pixel, Minimum Left - Pixel: %d, Left: %d", test_num, pixel, left_pixel);
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            pixel = 8'd100;
            left_pixel = 8'd100;
            $display("Test %0d: Identical Pixels (Result 0) - Pixel: %d, Left: %d", test_num, pixel, left_pixel);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            pixel = 8'd0;
            left_pixel = 8'd0;
            $display("Test %0d: Zero Boundary - Pixel: %d, Left: %d", test_num, pixel, left_pixel);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            pixel = 8'd10;
            left_pixel = 8'd20;
            $display("Test %0d: Underflow Wrap-around (Negative Result) - Pixel: %d, Left: %d", test_num, pixel, left_pixel);

            #1;


            check_outputs(8'd246);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            pixel = 8'd0;
            left_pixel = 8'd255;
            $display("Test %0d: Maximum Underflow - Pixel: %d, Left: %d", test_num, pixel, left_pixel);

            #1;


            check_outputs(8'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            pixel = 8'hAA;
            left_pixel = 8'h55;
            $display("Test %0d: Hex Pattern A - Pixel: %h, Left: %h", test_num, pixel, left_pixel);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            pixel = 8'd128;
            left_pixel = 8'd129;
            $display("Test %0d: Near Boundary Underflow - Pixel: %d, Left: %d", test_num, pixel, left_pixel);
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            pixel = 8'hFF;
            left_pixel = 8'hFF;
            $display("Test %0d: Max Value Subtraction - Pixel: %h, Left: %h", test_num, pixel, left_pixel);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            pixel = 8'd200;
            left_pixel = 8'd50;
            $display("Test %0d: Large Positive Result - Pixel: %d, Left: %d", test_num, pixel, left_pixel);
            #1;

            check_outputs(8'd150);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("png_filter Testbench");
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
        input [7:0] expected_filtered_pixel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_filtered_pixel === (expected_filtered_pixel ^ filtered_pixel ^ expected_filtered_pixel)) begin
                $display("PASS");
                $display("  Outputs: filtered_pixel=%h",
                         filtered_pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: filtered_pixel=%h",
                         expected_filtered_pixel);
                $display("  Got:      filtered_pixel=%h",
                         filtered_pixel);
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
