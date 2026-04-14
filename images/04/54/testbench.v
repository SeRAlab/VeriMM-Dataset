`timescale 1ns/1ps

module canny_edge_detection_tb;

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
    wire edge_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    canny_edge_detection dut (
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
        .edge_detected(edge_detected)
    );
    task set_all_pixels;

        input [7:0] val;
        begin
            pixel_00 = val; pixel_01 = val; pixel_02 = val;
            pixel_10 = val; pixel_11 = val; pixel_12 = val;
            pixel_20 = val; pixel_21 = val; pixel_22 = val;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: All Zeros (No Edge)", test_num);
            set_all_pixels(8'h00);
            threshold = 8'd50;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Uniform Brightness (No Edge)", test_num);
            set_all_pixels(8'hFF);
            threshold = 8'd50;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Strong Vertical Edge", test_num);
            pixel_00 = 0;   pixel_01 = 128; pixel_02 = 255;
            pixel_10 = 0;   pixel_11 = 128; pixel_12 = 255;
            pixel_20 = 0;   pixel_21 = 128; pixel_22 = 255;


            threshold = 8'd100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Strong Horizontal Edge", test_num);
            pixel_00 = 200; pixel_01 = 200; pixel_02 = 200;
            pixel_10 = 100; pixel_11 = 100; pixel_12 = 100;
            pixel_20 = 0;   pixel_21 = 0;   pixel_22 = 0;


            threshold = 8'd100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Weak Edge (Below Threshold)", test_num);
            pixel_00 = 10; pixel_01 = 10; pixel_02 = 12;
            pixel_10 = 10; pixel_11 = 10; pixel_12 = 12;
            pixel_20 = 10; pixel_21 = 10; pixel_22 = 12;


            threshold = 8'd20;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Diagonal Edge", test_num);
            pixel_00 = 200; pixel_01 = 200; pixel_02 = 0;
            pixel_10 = 200; pixel_11 = 0;   pixel_12 = 0;
            pixel_20 = 0;   pixel_21 = 0;   pixel_22 = 0;



            threshold = 8'd255;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Threshold Boundary (Just Above)", test_num);

            pixel_00 = 0; pixel_01 = 0; pixel_02 = 12;
            pixel_10 = 0; pixel_11 = 0; pixel_12 = 13;
            pixel_20 = 0; pixel_21 = 0; pixel_22 = 12;
            threshold = 8'd40;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Noisy Region (No Edge)", test_num);
            pixel_00 = 50; pixel_01 = 52; pixel_02 = 49;
            pixel_10 = 51; pixel_11 = 50; pixel_12 = 52;
            pixel_20 = 48; pixel_21 = 50; pixel_22 = 51;

            threshold = 8'd100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("canny_edge_detection Testbench");
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
        input expected_edge_detected;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_edge_detected === (expected_edge_detected ^ edge_detected ^ expected_edge_detected)) begin
                $display("PASS");
                $display("  Outputs: edge_detected=%b",
                         edge_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: edge_detected=%b",
                         expected_edge_detected);
                $display("  Got:      edge_detected=%b",
                         edge_detected);
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
