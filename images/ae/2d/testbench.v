`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] lcd_readdata;
    reg reset;
    wire [7:0] B;
    wire [7:0] G;
    wire HSYNC;
    wire LCD_CLK;
    wire [7:0] R;
    wire VSYNC;
    wire lcd_read;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .lcd_readdata(lcd_readdata),
        .reset(reset),
        .B(B),
        .G(G),
        .HSYNC(HSYNC),
        .LCD_CLK(LCD_CLK),
        .R(R),
        .VSYNC(VSYNC),
        .lcd_read(lcd_read)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            lcd_readdata = 16'h0000;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            #1;



            check_outputs(8'h00, 8'h00, 1'b1, 1'b0, 8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            lcd_readdata = 16'hF800;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00, 8'h00, 1'b1, 1'b1, 8'hF8, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            lcd_readdata = 16'h07E0;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00, 8'hFC, 1'b1, 1'b1, 8'h00, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            lcd_readdata = 16'h001F;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(8'hF8, 8'h00, 1'b1, 1'b1, 8'h00, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            lcd_readdata = 16'hFFFF;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(8'hF8, 8'hFC, 1'b1, 1'b1, 8'hF8, 1'b1, 1'b1);
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
        input [7:0] expected_B;
        input [7:0] expected_G;
        input expected_HSYNC;
        input expected_LCD_CLK;
        input [7:0] expected_R;
        input expected_VSYNC;
        input expected_lcd_read;
        begin
            if (expected_B === (expected_B ^ B ^ expected_B) &&
                expected_G === (expected_G ^ G ^ expected_G) &&
                expected_HSYNC === (expected_HSYNC ^ HSYNC ^ expected_HSYNC) &&
                expected_LCD_CLK === (expected_LCD_CLK ^ LCD_CLK ^ expected_LCD_CLK) &&
                expected_R === (expected_R ^ R ^ expected_R) &&
                expected_VSYNC === (expected_VSYNC ^ VSYNC ^ expected_VSYNC) &&
                expected_lcd_read === (expected_lcd_read ^ lcd_read ^ expected_lcd_read)) begin
                $display("PASS");
                $display("  Outputs: B=%h, G=%h, HSYNC=%b, LCD_CLK=%b, R=%h, VSYNC=%b, lcd_read=%b",
                         B, G, HSYNC, LCD_CLK, R, VSYNC, lcd_read);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B=%h, G=%h, HSYNC=%b, LCD_CLK=%b, R=%h, VSYNC=%b, lcd_read=%b",
                         expected_B, expected_G, expected_HSYNC, expected_LCD_CLK, expected_R, expected_VSYNC, expected_lcd_read);
                $display("  Got:      B=%h, G=%h, HSYNC=%b, LCD_CLK=%b, R=%h, VSYNC=%b, lcd_read=%b",
                         B, G, HSYNC, LCD_CLK, R, VSYNC, lcd_read);
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
        $dumpvars(0,clk, lcd_readdata, reset, B, G, HSYNC, LCD_CLK, R, VSYNC, lcd_read);
    end

endmodule
