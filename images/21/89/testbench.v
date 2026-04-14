`timescale 1ns/1ps

module sobel_edge_detection_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_0;
    reg [7:0] pixel_1;
    reg [7:0] pixel_2;
    reg [7:0] pixel_3;
    reg [7:0] pixel_4;
    reg [7:0] pixel_5;
    reg [7:0] pixel_6;
    reg [7:0] pixel_7;
    reg [7:0] pixel_8;
    wire [9:0] gradient_magnitude;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sobel_edge_detection dut (
        .pixel_0(pixel_0),
        .pixel_1(pixel_1),
        .pixel_2(pixel_2),
        .pixel_3(pixel_3),
        .pixel_4(pixel_4),
        .pixel_5(pixel_5),
        .pixel_6(pixel_6),
        .pixel_7(pixel_7),
        .pixel_8(pixel_8),
        .gradient_magnitude(gradient_magnitude)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros", test_num);
            pixel_0 = 8'd0; pixel_1 = 8'd0; pixel_2 = 8'd0;
            pixel_3 = 8'd0; pixel_4 = 8'd0; pixel_5 = 8'd0;
            pixel_6 = 8'd0; pixel_7 = 8'd0; pixel_8 = 8'd0;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All 255s", test_num);
            pixel_0 = 8'd255; pixel_1 = 8'd255; pixel_2 = 8'd255;
            pixel_3 = 8'd255; pixel_4 = 8'd255; pixel_5 = 8'd255;
            pixel_6 = 8'd255; pixel_7 = 8'd255; pixel_8 = 8'd255;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pure Vertical Edge", test_num);
            pixel_0 = 8'd0;   pixel_1 = 8'd128; pixel_2 = 8'd255;
            pixel_3 = 8'd0;   pixel_4 = 8'd128; pixel_5 = 8'd255;
            pixel_6 = 8'd0;   pixel_7 = 8'd128; pixel_8 = 8'd255;
            #1;

            check_outputs(10'h3FC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pure Horizontal Edge", test_num);
            pixel_0 = 8'd0;   pixel_1 = 8'd0;   pixel_2 = 8'd0;
            pixel_3 = 8'd128; pixel_4 = 8'd128; pixel_5 = 8'd128;
            pixel_6 = 8'd255; pixel_7 = 8'd255; pixel_8 = 8'd255;
            #1;

            check_outputs(10'h3FC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Diagonal Edge (Overflow/Saturation)", test_num);
            pixel_0 = 8'd0;   pixel_1 = 8'd0;   pixel_2 = 8'd255;
            pixel_3 = 8'd0;   pixel_4 = 8'd0;   pixel_5 = 8'd255;
            pixel_6 = 8'd255; pixel_7 = 8'd255; pixel_8 = 8'd255;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtle Edge", test_num);
            pixel_0 = 8'd10; pixel_1 = 8'd10; pixel_2 = 8'd12;
            pixel_3 = 8'd10; pixel_4 = 8'd10; pixel_5 = 8'd12;
            pixel_6 = 8'd10; pixel_7 = 8'd10; pixel_8 = 8'd12;
            #1;

            check_outputs(10'h008);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Impulse Noise in Center", test_num);
            pixel_0 = 8'd0; pixel_1 = 8'd0; pixel_2 = 8'd0;
            pixel_3 = 8'd0; pixel_4 = 8'd255; pixel_5 = 8'd0;
            pixel_6 = 8'd0; pixel_7 = 8'd0; pixel_8 = 8'd0;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Specific Gradient Check", test_num);
            pixel_0 = 8'd10; pixel_1 = 8'd20; pixel_2 = 8'd50;
            pixel_3 = 8'd20; pixel_4 = 8'd0;  pixel_5 = 8'd100;
            pixel_6 = 8'd10; pixel_7 = 8'd20; pixel_8 = 8'd50;
            #1;

            check_outputs(10'd240);
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
        testcase008();
        
        
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
        input [9:0] expected_gradient_magnitude;
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
