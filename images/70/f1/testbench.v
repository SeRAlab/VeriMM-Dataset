`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire [4:0] vga_b;
    wire [5:0] vga_g;
    wire vga_hs;
    wire [4:0] vga_r;
    wire vga_vs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .vga_b(vga_b),
        .vga_g(vga_g),
        .vga_hs(vga_hs),
        .vga_r(vga_r),
        .vga_vs(vga_vs)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin

            #0;
        end
        endtask
    task wait_to_pixel;

        input integer target_pixel;
        begin
            if (target_pixel > current_pixel_count) begin
                repeat(target_pixel - current_pixel_count) @(posedge clk);
                current_pixel_count = target_pixel;
            end
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Visible Display Area (Pixel 10, Line 0)", test_num);
            wait_to_pixel(10);
            #1;

            #1;


            check_outputs(5'h00, 6'h3f, 1'b1, 5'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Horizontal Front Porch (Pixel 645, Line 0)", test_num);
            wait_to_pixel(645);
            #1;

            #1;


            check_outputs(5'h00, 6'h00, 1'b1, 5'h00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Horizontal Sync Active (Pixel 700, Line 0)", test_num);
            wait_to_pixel(700);
            #1;

            #1;


            check_outputs(5'h00, 6'h00, 1'b0, 5'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Horizontal Back Porch (Pixel 780, Line 0)", test_num);
            wait_to_pixel(780);
            #1;

            #1;


            check_outputs(5'h00, 6'h00, 1'b1, 5'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Second Line Visible Area (Pixel 810 total)", test_num);
            wait_to_pixel(810);
            #1;

            #1;


            check_outputs(5'h00, 6'h3f, 1'b1, 5'h00, 1'b1);
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
        input [4:0] expected_vga_b;
        input [5:0] expected_vga_g;
        input expected_vga_hs;
        input [4:0] expected_vga_r;
        input expected_vga_vs;
        begin
            if (expected_vga_b === (expected_vga_b ^ vga_b ^ expected_vga_b) &&
                expected_vga_g === (expected_vga_g ^ vga_g ^ expected_vga_g) &&
                expected_vga_hs === (expected_vga_hs ^ vga_hs ^ expected_vga_hs) &&
                expected_vga_r === (expected_vga_r ^ vga_r ^ expected_vga_r) &&
                expected_vga_vs === (expected_vga_vs ^ vga_vs ^ expected_vga_vs)) begin
                $display("PASS");
                $display("  Outputs: vga_b=%h, vga_g=%h, vga_hs=%b, vga_r=%h, vga_vs=%b",
                         vga_b, vga_g, vga_hs, vga_r, vga_vs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vga_b=%h, vga_g=%h, vga_hs=%b, vga_r=%h, vga_vs=%b",
                         expected_vga_b, expected_vga_g, expected_vga_hs, expected_vga_r, expected_vga_vs);
                $display("  Got:      vga_b=%h, vga_g=%h, vga_hs=%b, vga_r=%h, vga_vs=%b",
                         vga_b, vga_g, vga_hs, vga_r, vga_vs);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, vga_b, vga_g, vga_hs, vga_r, vga_vs);
    end

endmodule
