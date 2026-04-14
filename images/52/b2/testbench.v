`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] bg;
    reg clk;
    reg [15:0] data_in;
    reg [10:0] vga_h;
    reg [10:0] vga_v;
    wire display_on;
    wire [2:0] pixel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bg(bg),
        .clk(clk),
        .data_in(data_in),
        .vga_h(vga_h),
        .vga_v(vga_v),
        .display_on(display_on),
        .pixel_out(pixel_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 16'h0000;
            vga_h = 11'd100;
            vga_v = 11'd100;
            bg = 3'b000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: Outside Grid Bounds", test_num);
            data_in = 16'hFFFF;
            vga_v = 11'd10;
            vga_h = 11'd10;
            bg = 3'b010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 3'b000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Top-left Corner (0,0) - Bit 1", test_num);
            data_in = 16'h0001;
            vga_v = 11'd0;
            vga_h = 11'd0;
            bg = 3'b001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 3'b111);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Top-left Corner (0,0) - Bit 0 (Background)", test_num);
            data_in = 16'hFFFE;
            vga_v = 11'd0;
            vga_h = 11'd0;
            bg = 3'b101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 3'b101);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Bottom-right Corner (3,3) - Bit 15", test_num);
            data_in = 16'h8000;
            vga_v = 11'd3;
            vga_h = 11'd3;
            bg = 3'b000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 3'b111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Grid Coord (1,1) - Bit 5", test_num);
            data_in = 16'h0020;
            vga_v = 11'd1;
            vga_h = 11'd1;
            bg = 3'b000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 3'b111);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: Boundary Check (4,0)", test_num);
            data_in = 16'hFFFF;
            vga_v = 11'd4;
            vga_h = 11'd0;
            bg = 3'b111;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 3'b000);
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
        input expected_display_on;
        input [2:0] expected_pixel_out;
        begin
            if (expected_display_on === (expected_display_on ^ display_on ^ expected_display_on) &&
                expected_pixel_out === (expected_pixel_out ^ pixel_out ^ expected_pixel_out)) begin
                $display("PASS");
                $display("  Outputs: display_on=%b, pixel_out=%h",
                         display_on, pixel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: display_on=%b, pixel_out=%h",
                         expected_display_on, expected_pixel_out);
                $display("  Got:      display_on=%b, pixel_out=%h",
                         display_on, pixel_out);
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
        $dumpvars(0,bg, clk, data_in, vga_h, vga_v, display_on, pixel_out);
    end

endmodule
