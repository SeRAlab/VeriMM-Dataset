`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [23:0] lcd_data_i;
    reg lcd_de_i;
    reg lcd_hsync_i;
    reg lcd_pclk_i;
    reg lcd_vsync_i;
    reg rst;
    wire lcd_clk_o;
    wire [23:0] lcd_data_o;
    wire lcd_data_valid_o;
    wire [11:0] lcd_x_o;
    wire [11:0] lcd_y_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .lcd_data_i(lcd_data_i),
        .lcd_de_i(lcd_de_i),
        .lcd_hsync_i(lcd_hsync_i),
        .lcd_pclk_i(lcd_pclk_i),
        .lcd_vsync_i(lcd_vsync_i),
        .rst(rst),
        .lcd_clk_o(lcd_clk_o),
        .lcd_data_o(lcd_data_o),
        .lcd_data_valid_o(lcd_data_valid_o),
        .lcd_x_o(lcd_x_o),
        .lcd_y_o(lcd_y_o)
    );

    // Clock generation (10ns period)
    initial begin
        lcd_pclk_i = 0;
        forever #5 lcd_pclk_i = ~lcd_pclk_i;
    end

        task reset_dut;

        begin
            rst = 1;
            lcd_data_i = 24'h0;
            lcd_de_i = 0;
            lcd_hsync_i = 0;
            lcd_vsync_i = 0;
            repeat(5) @(posedge lcd_pclk_i);
            #1 rst = 0;
            repeat(2) @(posedge lcd_pclk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %03d: Basic Data Transmission", test_num);
            reset_dut();

            @(posedge lcd_pclk_i);
            #1;
            lcd_de_i = 1;
            lcd_data_i = 24'hABCDEF;

            @(posedge lcd_pclk_i);
            #1;


            #1;



            check_outputs(lcd_pclk_i, 24'hABCDEF, 1'b1, 12'd0, 12'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %03d: Horizontal Pixel Counter Increment", test_num);
            reset_dut();

            @(posedge lcd_pclk_i);
            #1;
            lcd_de_i = 1;
            lcd_data_i = 24'h112233;

            repeat(5) @(posedge lcd_pclk_i);
            #1;


            #1;



            check_outputs(lcd_pclk_i, 24'h112233, 1'b1, 12'd5, 12'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %03d: Horizontal Sync Reset", test_num);
            reset_dut();


            @(posedge lcd_pclk_i);
            #1;
            lcd_de_i = 1;
            repeat(10) @(posedge lcd_pclk_i);


            #1;
            lcd_de_i = 0;
            lcd_hsync_i = 1;
            @(posedge lcd_pclk_i);
            #1;
            lcd_hsync_i = 0;


            #1;



            check_outputs(lcd_pclk_i, 24'h0, 1'b0, 12'd0, 12'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %03d: Vertical Sync Reset", test_num);
            reset_dut();


            repeat(5) begin
                @(posedge lcd_pclk_i);
                #1 lcd_hsync_i = 1;
                @(posedge lcd_pclk_i);
                #1 lcd_hsync_i = 0;
            end


            @(posedge lcd_pclk_i);
            #1;
            lcd_vsync_i = 1;
            @(posedge lcd_pclk_i);
            #1;
            lcd_vsync_i = 0;


            #1;



            check_outputs(lcd_pclk_i, 24'h0, 1'b0, 12'd0, 12'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %03d: Data Enable Gating", test_num);
            reset_dut();

            @(posedge lcd_pclk_i);
            #1;
            lcd_de_i = 1;
            lcd_data_i = 24'hFFFFFF;
            @(posedge lcd_pclk_i);
            #1;
            lcd_de_i = 0;
            lcd_data_i = 24'h000000;
            @(posedge lcd_pclk_i);
            #1;


            #1;



            check_outputs(lcd_pclk_i, 24'h0, 1'b0, 12'd1, 12'd0);
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
        input expected_lcd_clk_o;
        input [23:0] expected_lcd_data_o;
        input expected_lcd_data_valid_o;
        input [11:0] expected_lcd_x_o;
        input [11:0] expected_lcd_y_o;
        begin
            if (expected_lcd_clk_o === (expected_lcd_clk_o ^ lcd_clk_o ^ expected_lcd_clk_o) &&
                expected_lcd_data_o === (expected_lcd_data_o ^ lcd_data_o ^ expected_lcd_data_o) &&
                expected_lcd_data_valid_o === (expected_lcd_data_valid_o ^ lcd_data_valid_o ^ expected_lcd_data_valid_o) &&
                expected_lcd_x_o === (expected_lcd_x_o ^ lcd_x_o ^ expected_lcd_x_o) &&
                expected_lcd_y_o === (expected_lcd_y_o ^ lcd_y_o ^ expected_lcd_y_o)) begin
                $display("PASS");
                $display("  Outputs: lcd_clk_o=%b, lcd_data_o=%h, lcd_data_valid_o=%b, lcd_x_o=%h, lcd_y_o=%h",
                         lcd_clk_o, lcd_data_o, lcd_data_valid_o, lcd_x_o, lcd_y_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lcd_clk_o=%b, lcd_data_o=%h, lcd_data_valid_o=%b, lcd_x_o=%h, lcd_y_o=%h",
                         expected_lcd_clk_o, expected_lcd_data_o, expected_lcd_data_valid_o, expected_lcd_x_o, expected_lcd_y_o);
                $display("  Got:      lcd_clk_o=%b, lcd_data_o=%h, lcd_data_valid_o=%b, lcd_x_o=%h, lcd_y_o=%h",
                         lcd_clk_o, lcd_data_o, lcd_data_valid_o, lcd_x_o, lcd_y_o);
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
        $dumpvars(0,lcd_data_i, lcd_de_i, lcd_hsync_i, lcd_pclk_i, lcd_vsync_i, rst, lcd_clk_o, lcd_data_o, lcd_data_valid_o, lcd_x_o, lcd_y_o);
    end

endmodule
