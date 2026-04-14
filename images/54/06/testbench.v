`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg in_latch;
    reg in_pix_clk;
    reg [9:0] in_pix_x;
    reg [9:0] in_pix_y;
    reg [7:0] in_pixel_b;
    reg [7:0] in_pixel_g;
    reg [7:0] in_pixel_r;
    wire [7:0] out_pixel_b;
    wire [7:0] out_pixel_g;
    wire [7:0] out_pixel_r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_latch(in_latch),
        .in_pix_clk(in_pix_clk),
        .in_pix_x(in_pix_x),
        .in_pix_y(in_pix_y),
        .in_pixel_b(in_pixel_b),
        .in_pixel_g(in_pixel_g),
        .in_pixel_r(in_pixel_r),
        .out_pixel_b(out_pixel_b),
        .out_pixel_g(out_pixel_g),
        .out_pixel_r(out_pixel_r)
    );

    // Clock generation (10ns period)
    initial begin
        in_pix_clk = 0;
        forever #5 in_pix_clk = ~in_pix_clk;
    end

        task reset_dut;

        begin
            in_latch   = 0;
            in_pix_x   = 0;
            in_pix_y   = 0;
            in_pixel_r = 0;
            in_pixel_g = 0;
            in_pixel_b = 0;
            @(posedge in_pix_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Left edge (X=0)", test_num);
            in_latch   = 1;
            in_pix_x   = 10'd0;
            in_pix_y   = 10'd500;
            in_pixel_r = 8'hAA;
            in_pixel_g = 8'hBB;
            in_pixel_b = 8'hCC;
            @(posedge in_pix_clk);
            #2;

            #1;


            check_outputs(8'hFF, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Right edge (X=1023)", test_num);
            in_latch   = 1;
            in_pix_x   = 10'd1023;
            in_pix_y   = 10'd500;
            in_pixel_r = 8'h11;
            in_pixel_g = 8'h22;
            in_pixel_b = 8'h33;
            @(posedge in_pix_clk);
            #2;
            #1;

            check_outputs(8'hFF, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Top edge (Y=0)", test_num);
            in_latch   = 1;
            in_pix_x   = 10'd400;
            in_pix_y   = 10'd0;
            in_pixel_r = 8'h55;
            in_pixel_g = 8'h66;
            in_pixel_b = 8'h77;
            @(posedge in_pix_clk);
            #2;
            #1;

            check_outputs(8'hFF, 8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Bottom edge (Y=1023)", test_num);
            in_latch   = 1;
            in_pix_x   = 10'd400;
            in_pix_y   = 10'd1023;
            in_pixel_r = 8'h88;
            in_pixel_g = 8'h99;
            in_pixel_b = 8'hAA;
            @(posedge in_pix_clk);
            #2;
            #1;

            check_outputs(8'hFF, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Internal pixel (X=500, Y=500)", test_num);
            in_latch   = 1;
            in_pix_x   = 10'd500;
            in_pix_y   = 10'd500;
            in_pixel_r = 8'h12;
            in_pixel_g = 8'h34;
            in_pixel_b = 8'h56;
            @(posedge in_pix_clk);
            #2;

            #1;


            check_outputs(8'h56, 8'h34, 8'h12);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %0d: Top-Left corner (0,0)", test_num);
            in_latch   = 1;
            in_pix_x   = 10'd0;
            in_pix_y   = 10'd0;
            in_pixel_r = 8'hFF;
            in_pixel_g = 8'hFF;
            in_pixel_b = 8'hFF;
            @(posedge in_pix_clk);
            #2;
            #1;

            check_outputs(8'hFF, 8'h00, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Testcase %0d: Slightly off-edge (X=1, Y=1022)", test_num);
            in_latch   = 1;
            in_pix_x   = 10'd1;
            in_pix_y   = 10'd1022;
            in_pixel_r = 8'hDE;
            in_pixel_g = 8'hAD;
            in_pixel_b = 8'hBE;
            @(posedge in_pix_clk);
            #2;
            #1;

            check_outputs(8'hBE, 8'hAD, 8'hDE);
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
        input [7:0] expected_out_pixel_b;
        input [7:0] expected_out_pixel_g;
        input [7:0] expected_out_pixel_r;
        begin
            if (expected_out_pixel_b === (expected_out_pixel_b ^ out_pixel_b ^ expected_out_pixel_b) &&
                expected_out_pixel_g === (expected_out_pixel_g ^ out_pixel_g ^ expected_out_pixel_g) &&
                expected_out_pixel_r === (expected_out_pixel_r ^ out_pixel_r ^ expected_out_pixel_r)) begin
                $display("PASS");
                $display("  Outputs: out_pixel_b=%h, out_pixel_g=%h, out_pixel_r=%h",
                         out_pixel_b, out_pixel_g, out_pixel_r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_pixel_b=%h, out_pixel_g=%h, out_pixel_r=%h",
                         expected_out_pixel_b, expected_out_pixel_g, expected_out_pixel_r);
                $display("  Got:      out_pixel_b=%h, out_pixel_g=%h, out_pixel_r=%h",
                         out_pixel_b, out_pixel_g, out_pixel_r);
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
        $dumpvars(0,in_latch, in_pix_clk, in_pix_x, in_pix_y, in_pixel_b, in_pixel_g, in_pixel_r, out_pixel_b, out_pixel_g, out_pixel_r);
    end

endmodule
