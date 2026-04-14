`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] PxData;
    reg clk100;
    wire [1:0] B;
    wire [2:0] G;
    wire [9:0] Line;
    wire [9:0] Pixel;
    wire [10:0] PxAddr;
    wire [2:0] R;
    wire hsync;
    wire vsync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PxData(PxData),
        .clk100(clk100),
        .B(B),
        .G(G),
        .Line(Line),
        .Pixel(Pixel),
        .PxAddr(PxAddr),
        .R(R),
        .hsync(hsync),
        .vsync(vsync)
    );

    // Clock generation (10ns period)
    initial begin
        clk100 = 0;
        forever #5 clk100 = ~clk100;
    end

        task reset_dut;

        begin
            PxData = 0;


            repeat(5) @(posedge clk100);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            PxData = 8'b111_010_11;
            @(posedge clk100);
            #1;
            $display("Testcase %0d: Pixel(0,0) - Start of Active Display", test_num);

            #1;


            check_outputs(2'b11, 3'b010, 10'd0, 10'd0, 11'd0, 3'b111, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            PxData = 8'b101_110_01;
            repeat(639) @(posedge clk100);
            @(posedge clk100);
            #1;
            $display("Testcase %0d: Pixel(639,0) - End of Active Line", test_num);

            #1;


            check_outputs(2'b01, 3'b110, 10'd0, 10'd639, 11'd639, 3'b101, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            PxData = 8'b111_111_11;
            repeat(641) @(posedge clk100);
            #1;
            $display("Testcase %0d: Pixel(640,0) - Horizontal Blanking Start", test_num);

            #1;


            check_outputs(2'b00, 3'b000, 10'd0, 10'd640, 11'hXXX, 3'b000, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            repeat(701) @(posedge clk100);
            #1;
            $display("Testcase %0d: Pixel(700,0) - Horizontal Sync Active", test_num);

            if (hsync === 1'b0) pass_count = pass_count + 1;
            else begin
                $display("FAIL: hsync expected 0, got %b", hsync);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            PxData = 8'hAA;

            repeat(801) @(posedge clk100);
            #1;
            $display("Testcase %0d: Pixel(0,1) - Second Line Start", test_num);

            #1;


            check_outputs(2'b10, 3'b010, 10'd1, 10'd0, 11'd0, 3'b101, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();


            repeat(384001) @(posedge clk100);
            #1;
            $display("Testcase %0d: Pixel(0,480) - Vertical Blanking Start", test_num);

            if (R === 3'b000 && G === 3'b000 && B === 2'b00 && Line === 10'd480) begin
                $display("PASS");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Expected RGB=0 at Line 480. Got Line=%d, R=%h", Line, R);
                fail_count = fail_count + 1;
            end
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
        input [1:0] expected_B;
        input [2:0] expected_G;
        input [9:0] expected_Line;
        input [9:0] expected_Pixel;
        input [10:0] expected_PxAddr;
        input [2:0] expected_R;
        input expected_hsync;
        input expected_vsync;
        begin
            if (expected_B === (expected_B ^ B ^ expected_B) &&
                expected_G === (expected_G ^ G ^ expected_G) &&
                expected_Line === (expected_Line ^ Line ^ expected_Line) &&
                expected_Pixel === (expected_Pixel ^ Pixel ^ expected_Pixel) &&
                expected_PxAddr === (expected_PxAddr ^ PxAddr ^ expected_PxAddr) &&
                expected_R === (expected_R ^ R ^ expected_R) &&
                expected_hsync === (expected_hsync ^ hsync ^ expected_hsync) &&
                expected_vsync === (expected_vsync ^ vsync ^ expected_vsync)) begin
                $display("PASS");
                $display("  Outputs: B=%h, G=%h, Line=%h, Pixel=%h, PxAddr=%h, R=%h, hsync=%b, vsync=%b",
                         B, G, Line, Pixel, PxAddr, R, hsync, vsync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B=%h, G=%h, Line=%h, Pixel=%h, PxAddr=%h, R=%h, hsync=%b, vsync=%b",
                         expected_B, expected_G, expected_Line, expected_Pixel, expected_PxAddr, expected_R, expected_hsync, expected_vsync);
                $display("  Got:      B=%h, G=%h, Line=%h, Pixel=%h, PxAddr=%h, R=%h, hsync=%b, vsync=%b",
                         B, G, Line, Pixel, PxAddr, R, hsync, vsync);
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
        $dumpvars(0,PxData, clk100, B, G, Line, Pixel, PxAddr, R, hsync, vsync);
    end

endmodule
