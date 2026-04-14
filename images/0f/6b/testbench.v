`timescale 1ns/1ps

module sobel_edge_detection_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_00;
    reg [7:0] pixel_01;
    reg [7:0] pixel_02;
    reg [7:0] pixel_10;
    reg [7:0] pixel_11;
    reg [7:0] pixel_12;
    reg [7:0] pixel_20;
    reg [7:0] pixel_21;
    reg [7:0] pixel_22;
    wire [15:0] edge_magnitude;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sobel_edge_detection dut (
        .pixel_00(pixel_00),
        .pixel_01(pixel_01),
        .pixel_02(pixel_02),
        .pixel_10(pixel_10),
        .pixel_11(pixel_11),
        .pixel_12(pixel_12),
        .pixel_20(pixel_20),
        .pixel_21(pixel_21),
        .pixel_22(pixel_22),
        .edge_magnitude(edge_magnitude)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: All zeros", test_num);
            pixel_00 = 8'd0; pixel_01 = 8'd0; pixel_02 = 8'd0;
            pixel_10 = 8'd0; pixel_11 = 8'd0; pixel_12 = 8'd0;
            pixel_20 = 8'd0; pixel_21 = 8'd0; pixel_22 = 8'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Uniform brightness", test_num);
            pixel_00 = 8'd128; pixel_01 = 8'd128; pixel_02 = 8'd128;
            pixel_10 = 8'd128; pixel_11 = 8'd128; pixel_12 = 8'd128;
            pixel_20 = 8'd128; pixel_21 = 8'd128; pixel_22 = 8'd128;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Strong Vertical Edge", test_num);
            pixel_00 = 8'd0;   pixel_01 = 8'd0; pixel_02 = 8'd255;
            pixel_10 = 8'd0;   pixel_11 = 8'd0; pixel_12 = 8'd255;
            pixel_20 = 8'd0;   pixel_21 = 8'd0; pixel_22 = 8'd255;
            #1;

            check_outputs(16'd1020);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Strong Horizontal Edge", test_num);
            pixel_00 = 8'd0;   pixel_01 = 8'd0;   pixel_02 = 8'd0;
            pixel_10 = 8'd0;   pixel_11 = 8'd0;   pixel_12 = 8'd0;
            pixel_20 = 8'd255; pixel_21 = 8'd255; pixel_22 = 8'd255;
            #1;

            check_outputs(16'd1020);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Inverse Horizontal Edge", test_num);
            pixel_00 = 8'd255; pixel_01 = 8'd255; pixel_02 = 8'd255;
            pixel_10 = 8'd0;   pixel_11 = 8'd0;   pixel_12 = 8'd0;
            pixel_20 = 8'd0;   pixel_21 = 8'd0;   pixel_22 = 8'd0;
            #1;

            check_outputs(16'd1020);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Diagonal Edge", test_num);
            pixel_00 = 8'd255; pixel_01 = 8'd255; pixel_02 = 8'd0;
            pixel_10 = 8'd255; pixel_11 = 8'd0;   pixel_12 = 8'd0;
            pixel_20 = 8'd0;   pixel_21 = 8'd0;   pixel_22 = 8'd0;
            #1;

            check_outputs(16'd1530);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Center pixel noise test", test_num);
            pixel_00 = 8'd100; pixel_01 = 8'd100; pixel_02 = 8'd100;
            pixel_10 = 8'd100; pixel_11 = 8'd255; pixel_12 = 8'd100;
            pixel_20 = 8'd100; pixel_21 = 8'd100; pixel_22 = 8'd100;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Custom Gradient test", test_num);
            pixel_00 = 8'd20;  pixel_01 = 8'd100; pixel_02 = 8'd100;
            pixel_10 = 8'd20;  pixel_11 = 8'd0;   pixel_12 = 8'd200;
            pixel_20 = 8'd20;  pixel_21 = 8'd100; pixel_22 = 8'd100;
            #1;

            check_outputs(16'd520);
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
        input [15:0] expected_edge_magnitude;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_edge_magnitude === (expected_edge_magnitude ^ edge_magnitude ^ expected_edge_magnitude)) begin
                $display("PASS");
                $display("  Outputs: edge_magnitude=%h",
                         edge_magnitude);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: edge_magnitude=%h",
                         expected_edge_magnitude);
                $display("  Got:      edge_magnitude=%h",
                         edge_magnitude);
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
