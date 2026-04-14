`timescale 1ns/1ps

module edge_detection_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] pixel_00;
    reg [8:0] pixel_01;
    reg [8:0] pixel_02;
    reg [8:0] pixel_10;
    reg [8:0] pixel_11;
    reg [8:0] pixel_12;
    reg [8:0] pixel_20;
    reg [8:0] pixel_21;
    reg [8:0] pixel_22;
    reg [7:0] threshold;
    wire edge_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    edge_detection dut (
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
        test_num = 1;
        $display("Test Case 001: Uniform dark image (all 0s)");
        pixel_00 = 9'd0; pixel_01 = 9'd0; pixel_02 = 9'd0;
        pixel_10 = 9'd0; pixel_11 = 9'd0; pixel_12 = 9'd0;
        pixel_20 = 9'd0; pixel_21 = 9'd0; pixel_22 = 9'd0;
        threshold = 8'd50;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Uniform bright image (all 200s)");
        pixel_00 = 9'd200; pixel_01 = 9'd200; pixel_02 = 9'd200;
        pixel_10 = 9'd200; pixel_11 = 9'd200; pixel_12 = 9'd200;
        pixel_20 = 9'd200; pixel_21 = 9'd200; pixel_22 = 9'd200;
        threshold = 8'd50;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Strong Vertical Edge");

        pixel_00 = 9'd10;  pixel_01 = 9'd128; pixel_02 = 9'd250;
        pixel_10 = 9'd10;  pixel_11 = 9'd128; pixel_12 = 9'd250;
        pixel_20 = 9'd10;  pixel_21 = 9'd128; pixel_22 = 9'd250;
        threshold = 8'd40;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Strong Horizontal Edge");

        pixel_00 = 9'd5;   pixel_01 = 9'd5;   pixel_02 = 9'd5;
        pixel_10 = 9'd120; pixel_11 = 9'd120; pixel_12 = 9'd120;
        pixel_20 = 9'd240; pixel_21 = 9'd240; pixel_22 = 9'd240;
        threshold = 8'd40;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Low contrast noise below threshold");

        pixel_00 = 9'd100; pixel_01 = 9'd102; pixel_02 = 9'd101;
        pixel_10 = 9'd101; pixel_11 = 9'd100; pixel_12 = 9'd103;
        pixel_20 = 9'd102; pixel_21 = 9'd101; pixel_22 = 9'd100;
        threshold = 8'd80;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Diagonal Edge Contrast");
        pixel_00 = 9'd255; pixel_01 = 9'd255; pixel_02 = 9'd10;
        pixel_10 = 9'd255; pixel_11 = 9'd10;  pixel_12 = 9'd10;
        pixel_20 = 9'd10;  pixel_21 = 9'd10;  pixel_22 = 9'd10;
        threshold = 8'd50;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: High Contrast with very high Threshold");

        pixel_00 = 9'd0;   pixel_01 = 9'd0;   pixel_02 = 9'd0;
        pixel_10 = 9'd100; pixel_11 = 9'd100; pixel_12 = 9'd100;
        pixel_20 = 9'd0;   pixel_21 = 9'd0;   pixel_22 = 9'd0;
        threshold = 8'd255;



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
        $display("edge_detection Testbench");
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
