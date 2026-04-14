`timescale 1ns/1ps

module sobel_edge_detection_tb;

    // Testbench signals (combinational circuit)
    reg [71:0] pixels;
    wire [7:0] gradient_magnitude;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sobel_edge_detection dut (
        .pixels(pixels),
        .gradient_magnitude(gradient_magnitude)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: All Black Image", test_num);
        pixels = 72'h0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: All White Image", test_num);
        pixels = {9{8'hFF}};
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Strong Vertical Edge", test_num);

        pixels = {8'hFF, 8'h00, 8'h00, 8'hFF, 8'h00, 8'h00, 8'hFF, 8'h00, 8'h00};
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Strong Horizontal Edge", test_num);

        pixels = {8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00};
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Low Contrast Vertical Edge", test_num);

        pixels = {8'd20, 8'd10, 8'd10, 8'd20, 8'd10, 8'd10, 8'd20, 8'd10, 8'd10};
        #1;

        check_outputs(8'd40);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Diagonal Gradient", test_num);
        pixels = {8'd10, 8'd10, 8'd20, 8'd10, 8'd10, 8'd20, 8'd20, 8'd20, 8'd20};
        #1;

        check_outputs(8'd60);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Center Pixel Isolation", test_num);
        pixels = 72'h0;
        pixels[39:32] = 8'hFF;
        #1;

        check_outputs(8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sobel_edge_detection Testbench");
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
        input [7:0] expected_gradient_magnitude;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gradient_magnitude === (expected_gradient_magnitude ^ gradient_magnitude ^ expected_gradient_magnitude)) begin
                $display("PASS");
                $display("  Outputs: gradient_magnitude=%h",
                         gradient_magnitude);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gradient_magnitude=%h",
                         expected_gradient_magnitude);
                $display("  Got:      gradient_magnitude=%h",
                         gradient_magnitude);
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
