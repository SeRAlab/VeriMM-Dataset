`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg border;
    reg clk;
    reg [14:0] pixel;
    reg sync;
    wire [9:0] next_pixel_x;
    wire [3:0] vga_b;
    wire [3:0] vga_g;
    wire vga_h;
    wire [9:0] vga_hcounter;
    wire [3:0] vga_r;
    wire vga_v;
    wire [9:0] vga_vcounter;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .border(border),
        .clk(clk),
        .pixel(pixel),
        .sync(sync),
        .next_pixel_x(next_pixel_x),
        .vga_b(vga_b),
        .vga_g(vga_g),
        .vga_h(vga_h),
        .vga_hcounter(vga_hcounter),
        .vga_r(vga_r),
        .vga_v(vga_v),
        .vga_vcounter(vga_vcounter)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sync = 1;
            border = 0;
            pixel = 15'h0000;
            @(posedge clk);
            #1;
            sync = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(10'd1, 4'h0, 4'h0, 1'b1, 10'd0, 4'h0, 1'b1, 10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            repeat(50) @(posedge clk);
            #1;

            #1;


            check_outputs(10'd51, 4'h0, 4'h0, 1'b1, 10'd50, 4'h0, 1'b1, 10'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            pixel = 15'b11111_10101_01100;
            repeat(10) @(posedge clk);
            #1;


            #1;



            check_outputs(10'd11, 4'h6, 4'hA, 1'b1, 10'd10, 4'hF, 1'b1, 10'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            pixel = 15'h7FFF;
            repeat(H_ACTIVE + 5) @(posedge clk);
            #1;

            #1;


            check_outputs(10'd0, 4'h0, 4'h0, 1'b1, 10'd645, 4'h0, 1'b1, 10'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            repeat(H_ACTIVE + H_FRONT + 10) @(posedge clk);
            #1;

            #1;


            check_outputs(10'd0, 4'h0, 4'h0, 1'b0, 10'd666, 4'h0, 1'b1, 10'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            repeat(H_TOTAL + 10) @(posedge clk);
            #1;

            #1;


            check_outputs(10'd11, 4'h0, 4'h0, 1'b1, 10'd10, 4'h0, 1'b1, 10'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            repeat(H_TOTAL * (V_ACTIVE + V_FRONT + 1)) @(posedge clk);
            #1;

            #1;


            check_outputs(10'd1, 4'h0, 4'h0, 1'b1, 10'd0, 4'h0, 1'b0, 10'd491);
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
        input [9:0] expected_next_pixel_x;
        input [3:0] expected_vga_b;
        input [3:0] expected_vga_g;
        input expected_vga_h;
        input [9:0] expected_vga_hcounter;
        input [3:0] expected_vga_r;
        input expected_vga_v;
        input [9:0] expected_vga_vcounter;
        begin
            if (expected_next_pixel_x === (expected_next_pixel_x ^ next_pixel_x ^ expected_next_pixel_x) &&
                expected_vga_b === (expected_vga_b ^ vga_b ^ expected_vga_b) &&
                expected_vga_g === (expected_vga_g ^ vga_g ^ expected_vga_g) &&
                expected_vga_h === (expected_vga_h ^ vga_h ^ expected_vga_h) &&
                expected_vga_hcounter === (expected_vga_hcounter ^ vga_hcounter ^ expected_vga_hcounter) &&
                expected_vga_r === (expected_vga_r ^ vga_r ^ expected_vga_r) &&
                expected_vga_v === (expected_vga_v ^ vga_v ^ expected_vga_v) &&
                expected_vga_vcounter === (expected_vga_vcounter ^ vga_vcounter ^ expected_vga_vcounter)) begin
                $display("PASS");
                $display("  Outputs: next_pixel_x=%h, vga_b=%h, vga_g=%h, vga_h=%b, vga_hcounter=%h, vga_r=%h, vga_v=%b, vga_vcounter=%h",
                         next_pixel_x, vga_b, vga_g, vga_h, vga_hcounter, vga_r, vga_v, vga_vcounter);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_pixel_x=%h, vga_b=%h, vga_g=%h, vga_h=%b, vga_hcounter=%h, vga_r=%h, vga_v=%b, vga_vcounter=%h",
                         expected_next_pixel_x, expected_vga_b, expected_vga_g, expected_vga_h, expected_vga_hcounter, expected_vga_r, expected_vga_v, expected_vga_vcounter);
                $display("  Got:      next_pixel_x=%h, vga_b=%h, vga_g=%h, vga_h=%b, vga_hcounter=%h, vga_r=%h, vga_v=%b, vga_vcounter=%h",
                         next_pixel_x, vga_b, vga_g, vga_h, vga_hcounter, vga_r, vga_v, vga_vcounter);
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
        $dumpvars(0,border, clk, pixel, sync, next_pixel_x, vga_b, vga_g, vga_h, vga_hcounter, vga_r, vga_v, vga_vcounter);
    end

endmodule
