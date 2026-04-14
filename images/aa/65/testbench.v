`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] b1;
    reg [3:0] b2;
    reg clk25;
    reg [3:0] g1;
    reg [3:0] g2;
    reg h1;
    reg h2;
    reg [3:0] r1;
    reg [3:0] r2;
    reg v1;
    reg v2;
    wire [3:0] vga_blue;
    wire [3:0] vga_green;
    wire vga_hsync;
    wire [3:0] vga_red;
    wire vga_vsync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b1(b1),
        .b2(b2),
        .clk25(clk25),
        .g1(g1),
        .g2(g2),
        .h1(h1),
        .h2(h2),
        .r1(r1),
        .r2(r2),
        .v1(v1),
        .v2(v2),
        .vga_blue(vga_blue),
        .vga_green(vga_green),
        .vga_hsync(vga_hsync),
        .vga_red(vga_red),
        .vga_vsync(vga_vsync)
    );
    task testcase001;

    begin
        test_num = 1;
        r1 = 4'd2; g1 = 4'd2; b1 = 4'd2; h1 = 1'b1; v1 = 1'b1;
        r2 = 4'd5; g2 = 4'd5; b2 = 4'd5; h2 = 1'b0; v2 = 1'b0;
        @(posedge clk25);
        #1;

        check_outputs(4'd5, 4'd5, 1'b0, 4'd5, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        r1 = 4'd10; g1 = 4'd10; b1 = 4'd10; h1 = 1'b1; v1 = 1'b1;
        r2 = 4'd5;  g2 = 4'd5;  b2 = 4'd5;  h2 = 1'b0; v2 = 1'b0;
        @(posedge clk25);
        #1;

        check_outputs(4'd10, 4'd10, 1'b1, 4'd10, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        r1 = 4'hA; g1 = 4'hA; b1 = 4'hA; h1 = 1'b1; v1 = 1'b0;
        r2 = 4'hA; g2 = 4'hA; b2 = 4'hA; h2 = 1'b0; v2 = 1'b1;
        @(posedge clk25);
        #1;

        check_outputs(4'hA, 4'hA, 1'b0, 4'hA, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        r1 = 4'd8; g1 = 4'd8; b1 = 4'd8; h1 = 1'b1; v1 = 1'b1;
        r2 = 4'd7; g2 = 4'd9; b2 = 4'd9; h2 = 1'b0; v2 = 1'b0;
        @(posedge clk25);
        #1;

        check_outputs(4'd8, 4'd8, 1'b1, 4'd8, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        r1 = 4'd8; g1 = 4'd8; b1 = 4'd8; h1 = 1'b1; v1 = 1'b1;
        r2 = 4'd9; g2 = 4'd7; b2 = 4'd9; h2 = 1'b0; v2 = 1'b0;
        @(posedge clk25);
        #1;

        check_outputs(4'd8, 4'd8, 1'b1, 4'd8, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        r1 = 4'd8; g1 = 4'd8; b1 = 4'd8; h1 = 1'b1; v1 = 1'b1;
        r2 = 4'd9; g2 = 4'd9; b2 = 4'd7; h2 = 1'b0; v2 = 1'b0;
        @(posedge clk25);
        #1;

        check_outputs(4'd8, 4'd8, 1'b1, 4'd8, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        r1 = 4'h0; g1 = 4'h0; b1 = 4'h0; h1 = 1'b0; v1 = 1'b0;
        r2 = 4'hF; g2 = 4'hF; b2 = 4'hF; h2 = 1'b1; v2 = 1'b1;
        @(posedge clk25);
        #1;

        check_outputs(4'hF, 4'hF, 1'b1, 4'hF, 1'b1);
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
        input [3:0] expected_vga_blue;
        input [3:0] expected_vga_green;
        input expected_vga_hsync;
        input [3:0] expected_vga_red;
        input expected_vga_vsync;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_vga_blue === (expected_vga_blue ^ vga_blue ^ expected_vga_blue) &&
                expected_vga_green === (expected_vga_green ^ vga_green ^ expected_vga_green) &&
                expected_vga_hsync === (expected_vga_hsync ^ vga_hsync ^ expected_vga_hsync) &&
                expected_vga_red === (expected_vga_red ^ vga_red ^ expected_vga_red) &&
                expected_vga_vsync === (expected_vga_vsync ^ vga_vsync ^ expected_vga_vsync)) begin
                $display("PASS");
                $display("  Outputs: vga_blue=%h, vga_green=%h, vga_hsync=%b, vga_red=%h, vga_vsync=%b",
                         vga_blue, vga_green, vga_hsync, vga_red, vga_vsync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vga_blue=%h, vga_green=%h, vga_hsync=%b, vga_red=%h, vga_vsync=%b",
                         expected_vga_blue, expected_vga_green, expected_vga_hsync, expected_vga_red, expected_vga_vsync);
                $display("  Got:      vga_blue=%h, vga_green=%h, vga_hsync=%b, vga_red=%h, vga_vsync=%b",
                         vga_blue, vga_green, vga_hsync, vga_red, vga_vsync);
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
