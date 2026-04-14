`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [1:0] VGA_B;
    wire [2:0] VGA_G;
    wire [2:0] VGA_R;
    wire hsync;
    wire vsync;
    wire [9:0] x_ptr;
    wire [9:0] y_ptr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .VGA_B(VGA_B),
        .VGA_G(VGA_G),
        .VGA_R(VGA_R),
        .hsync(hsync),
        .vsync(vsync),
        .x_ptr(x_ptr),
        .y_ptr(y_ptr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            #20;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial state (0,0) after reset", test_num);
            reset_dut();



            #1;




            check_outputs(2'h3, 3'h7, 3'h7, 1'b1, 1'b1, 10'd0, 10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: End of visible line (639,0)", test_num);
            reset_dut();
            repeat(639) @(posedge clk);
            #1;
            #1;

            check_outputs(2'h3, 3'h7, 3'h7, 1'b1, 1'b1, 10'd639, 10'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Horizontal Front Porch (640,0) - Blanking", test_num);
            reset_dut();
            repeat(640) @(posedge clk);
            #1;

            #1;


            check_outputs(2'h0, 3'h0, 3'h0, 1'b1, 1'b1, 10'd640, 10'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: H-Sync Pulse Active (700,0)", test_num);
            reset_dut();
            repeat(700) @(posedge clk);
            #1;

            #1;


            check_outputs(2'h0, 3'h0, 3'h0, 1'b0, 1'b1, 10'd700, 10'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Start of second line (0,1)", test_num);
            reset_dut();
            repeat(800) @(posedge clk);
            #1;
            #1;

            check_outputs(2'h3, 3'h7, 3'h7, 1'b1, 1'b1, 10'd0, 10'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Mid-frame pixel (100,50)", test_num);
            reset_dut();
            repeat(50 * 800 + 100) @(posedge clk);
            #1;

            #1;


            check_outputs(2'h3, 3'h7, 3'h7, 1'b1, 1'b1, 10'd100, 10'd50);
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
        input [1:0] expected_VGA_B;
        input [2:0] expected_VGA_G;
        input [2:0] expected_VGA_R;
        input expected_hsync;
        input expected_vsync;
        input [9:0] expected_x_ptr;
        input [9:0] expected_y_ptr;
        begin
            if (expected_VGA_B === (expected_VGA_B ^ VGA_B ^ expected_VGA_B) &&
                expected_VGA_G === (expected_VGA_G ^ VGA_G ^ expected_VGA_G) &&
                expected_VGA_R === (expected_VGA_R ^ VGA_R ^ expected_VGA_R) &&
                expected_hsync === (expected_hsync ^ hsync ^ expected_hsync) &&
                expected_vsync === (expected_vsync ^ vsync ^ expected_vsync) &&
                expected_x_ptr === (expected_x_ptr ^ x_ptr ^ expected_x_ptr) &&
                expected_y_ptr === (expected_y_ptr ^ y_ptr ^ expected_y_ptr)) begin
                $display("PASS");
                $display("  Outputs: VGA_B=%h, VGA_G=%h, VGA_R=%h, hsync=%b, vsync=%b, x_ptr=%h, y_ptr=%h",
                         VGA_B, VGA_G, VGA_R, hsync, vsync, x_ptr, y_ptr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: VGA_B=%h, VGA_G=%h, VGA_R=%h, hsync=%b, vsync=%b, x_ptr=%h, y_ptr=%h",
                         expected_VGA_B, expected_VGA_G, expected_VGA_R, expected_hsync, expected_vsync, expected_x_ptr, expected_y_ptr);
                $display("  Got:      VGA_B=%h, VGA_G=%h, VGA_R=%h, hsync=%b, vsync=%b, x_ptr=%h, y_ptr=%h",
                         VGA_B, VGA_G, VGA_R, hsync, vsync, x_ptr, y_ptr);
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
        $dumpvars(0,clk, reset, VGA_B, VGA_G, VGA_R, hsync, vsync, x_ptr, y_ptr);
    end

endmodule
