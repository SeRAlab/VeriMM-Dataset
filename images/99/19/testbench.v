`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg hsync_in;
    reg [23:0] pixel_in;
    reg vde_in;
    reg vsync_in;
    wire hsync_out;
    wire [23:0] pixel_out;
    wire vde_out;
    wire vsync_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hsync_in(hsync_in),
        .pixel_in(pixel_in),
        .vde_in(vde_in),
        .vsync_in(vsync_in),
        .hsync_out(hsync_out),
        .pixel_out(pixel_out),
        .vde_out(vde_out),
        .vsync_out(vsync_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 1: All signals zero");
            hsync_in = 0;
            vsync_in = 0;
            vde_in = 0;
            pixel_in = 24'h000000;
            #1;

            check_outputs(0, 24'h000000, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 2: Control signals passthrough check");
            hsync_in = 1;
            vsync_in = 1;
            vde_in = 1;
            pixel_in = 24'h000000;
            #1;

            check_outputs(1, 24'h000000, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 3: Pure Red channel (should remain in [23:16])");
            hsync_in = 0;
            vsync_in = 0;
            vde_in = 1;
            pixel_in = 24'hFF0000;

            #1;


            check_outputs(0, 24'hFF0000, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 4: Pure Green channel (should move from [15:8] to [7:0])");
            hsync_in = 0;
            vsync_in = 0;
            vde_in = 1;
            pixel_in = 24'h00FF00;

            #1;


            check_outputs(0, 24'h0000FF, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 5: Pure Blue channel (should move from [7:0] to [15:8])");
            hsync_in = 0;
            vsync_in = 0;
            vde_in = 1;
            pixel_in = 24'h0000FF;

            #1;


            check_outputs(0, 24'h00FF00, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 6: Mixed colors (RGB: 12, 34, 56)");
            hsync_in = 1;
            vsync_in = 0;
            vde_in = 1;
            pixel_in = 24'h123456;

            #1;


            check_outputs(1, 24'h125634, 1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 7: Full white pixel");
            hsync_in = 1;
            vsync_in = 1;
            vde_in = 1;
            pixel_in = 24'hFFFFFF;

            #1;


            check_outputs(1, 24'hFFFFFF, 1, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 8: Data transition check");
            hsync_in = 0;
            vsync_in = 0;
            vde_in = 1;
            pixel_in = 24'hAABBCC;

            #1;


            check_outputs(0, 24'hAACCBB, 1, 0);
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
        input expected_hsync_out;
        input [23:0] expected_pixel_out;
        input expected_vde_out;
        input expected_vsync_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hsync_out === (expected_hsync_out ^ hsync_out ^ expected_hsync_out) &&
                expected_pixel_out === (expected_pixel_out ^ pixel_out ^ expected_pixel_out) &&
                expected_vde_out === (expected_vde_out ^ vde_out ^ expected_vde_out) &&
                expected_vsync_out === (expected_vsync_out ^ vsync_out ^ expected_vsync_out)) begin
                $display("PASS");
                $display("  Outputs: hsync_out=%b, pixel_out=%h, vde_out=%b, vsync_out=%b",
                         hsync_out, pixel_out, vde_out, vsync_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hsync_out=%b, pixel_out=%h, vde_out=%b, vsync_out=%b",
                         expected_hsync_out, expected_pixel_out, expected_vde_out, expected_vsync_out);
                $display("  Got:      hsync_out=%b, pixel_out=%h, vde_out=%b, vsync_out=%b",
                         hsync_out, pixel_out, vde_out, vsync_out);
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
