`timescale 1ns/1ps

module canny_edge_detector_tb;

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
    reg [7:0] threshold;
    wire edge_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    canny_edge_detector dut (
        .pixel_00(pixel_00),
        .pixel_01(pixel_01),
        .pixel_02(pixel_02),
        .pixel_10(pixel_10),
        .pixel_11(pixel_11),
        .pixel_12(pixel_12),
        .pixel_20(pixel_20),
        .pixel_21(pixel_21),
        .pixel_22(pixel_22),
        .threshold(threshold),
        .edge_out(edge_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Uniform Image", test_num);
            pixel_00 = 8'd128; pixel_01 = 8'd128; pixel_02 = 8'd128;
            pixel_10 = 8'd128; pixel_11 = 8'd128; pixel_12 = 8'd128;
            pixel_20 = 8'd128; pixel_21 = 8'd128; pixel_22 = 8'd128;
            threshold = 8'd50;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Strong Vertical Edge", test_num);
            pixel_00 = 8'd0;   pixel_01 = 8'd128; pixel_02 = 8'd255;
            pixel_10 = 8'd0;   pixel_11 = 8'd128; pixel_12 = 8'd255;
            pixel_20 = 8'd0;   pixel_21 = 8'd128; pixel_22 = 8'd255;
            threshold = 8'd100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Strong Horizontal Edge", test_num);
            pixel_00 = 8'd0;   pixel_01 = 8'd0;   pixel_02 = 8'd0;
            pixel_10 = 8'd128; pixel_11 = 8'd128; pixel_12 = 8'd128;
            pixel_20 = 8'd255; pixel_21 = 8'd255; pixel_22 = 8'd255;
            threshold = 8'd100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Weak Edge Below Threshold", test_num);
            pixel_00 = 8'd10;  pixel_01 = 8'd11;  pixel_02 = 8'd12;
            pixel_10 = 8'd10;  pixel_11 = 8'd11;  pixel_12 = 8'd12;
            pixel_20 = 8'd10;  pixel_21 = 8'd11;  pixel_22 = 8'd12;
            threshold = 8'd20;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Diagonal Edge", test_num);
            pixel_00 = 8'd255; pixel_01 = 8'd255; pixel_02 = 8'd0;
            pixel_10 = 8'd255; pixel_11 = 8'd0;   pixel_12 = 8'd0;
            pixel_20 = 8'd0;   pixel_21 = 8'd0;   pixel_22 = 8'd0;
            threshold = 8'd128;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High Threshold (Edge detected)", test_num);
            pixel_00 = 8'd0;   pixel_01 = 8'd0;   pixel_02 = 8'd255;
            pixel_10 = 8'd0;   pixel_11 = 8'd0;   pixel_12 = 8'd255;
            pixel_20 = 8'd0;   pixel_21 = 8'd0;   pixel_22 = 8'd255;
            threshold = 8'd255;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("canny_edge_detector Testbench");
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
        input expected_edge_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_edge_out === (expected_edge_out ^ edge_out ^ expected_edge_out)) begin
                $display("PASS");
                $display("  Outputs: edge_out=%b",
                         edge_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: edge_out=%b",
                         expected_edge_out);
                $display("  Got:      edge_out=%b",
                         edge_out);
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
