`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] pixel_x;
    reg [9:0] pixel_y;
    reg video_on;
    wire [7:0] fig_RGB;
    wire graph_on;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .video_on(video_on),
        .fig_RGB(fig_RGB),
        .graph_on(graph_on)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Video Off - Output should be disabled");
        video_on = 1'b0;
        pixel_x = 10'd100;
        pixel_y = 10'd100;


        #1;



        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Origin Coordinate (0,0)");
        video_on = 1'b1;
        pixel_x = 10'd0;
        pixel_y = 10'd0;


        #1;



        check_outputs(fig_RGB, graph_on);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Center of Screen (320, 240)");
        video_on = 1'b1;
        pixel_x = 10'd320;
        pixel_y = 10'd240;

        #1;


        check_outputs(fig_RGB, graph_on);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Standard VGA Boundary (639, 479)");
        video_on = 1'b1;
        pixel_x = 10'd639;
        pixel_y = 10'd479;

        #1;


        check_outputs(fig_RGB, graph_on);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Out of Range Coordinate");
        video_on = 1'b1;
        pixel_x = 10'd800;
        pixel_y = 10'd600;

        #1;


        check_outputs(8'h00, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Figure Edge Check - Horizontal");
        video_on = 1'b1;

        pixel_x = 10'd10;
        pixel_y = 10'd10;
        #1;
        #1;

        check_outputs(fig_RGB, graph_on);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Maximum Possible Input Values");
        video_on = 1'b1;
        pixel_x = 10'h3FF;
        pixel_y = 10'h3FF;

        #1;


        check_outputs(8'h00, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [7:0] expected_fig_RGB;
        input expected_graph_on;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_fig_RGB === (expected_fig_RGB ^ fig_RGB ^ expected_fig_RGB) &&
                expected_graph_on === (expected_graph_on ^ graph_on ^ expected_graph_on)) begin
                $display("PASS");
                $display("  Outputs: fig_RGB=%h, graph_on=%b",
                         fig_RGB, graph_on);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fig_RGB=%h, graph_on=%b",
                         expected_fig_RGB, expected_graph_on);
                $display("  Got:      fig_RGB=%h, graph_on=%b",
                         fig_RGB, graph_on);
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
