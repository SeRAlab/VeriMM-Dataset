`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] attcode;
    reg blank;
    reg blink;
    reg clk;
    reg hsync_in;
    reg pixclk;
    reg pixel;
    reg vsync_in;
    wire [2:0] b;
    wire [2:0] g;
    wire hsync;
    wire [2:0] r;
    wire vsync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .attcode(attcode),
        .blank(blank),
        .blink(blink),
        .clk(clk),
        .hsync_in(hsync_in),
        .pixclk(pixclk),
        .pixel(pixel),
        .vsync_in(vsync_in),
        .b(b),
        .g(g),
        .hsync(hsync),
        .r(r),
        .vsync(vsync)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        attcode = 8'h00;
        blank = 0;
        blink = 0;
        hsync_in = 0;
        pixclk = 0;
        pixel = 0;
        vsync_in = 0;
        repeat(5) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        attcode = 8'h01;
        pixel = 1;
        hsync_in = 1;
        vsync_in = 1;
        repeat(2) @(posedge clk);
        pixclk = 1; @(posedge clk); pixclk = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(3'd0, 3'd0, 1'b1, 3'd4, 1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        attcode = 8'h09;
        pixel = 1;
        hsync_in = 1;
        vsync_in = 1;
        repeat(2) @(posedge clk);
        pixclk = 1; @(posedge clk); pixclk = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(3'd0, 3'd0, 1'b1, 3'd7, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        attcode = 8'h20;
        pixel = 0;
        hsync_in = 0;
        vsync_in = 1;
        repeat(2) @(posedge clk);
        pixclk = 1; @(posedge clk); pixclk = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(3'd0, 3'd4, 1'b0, 3'd0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        attcode = 8'h0F;
        pixel = 1;
        blank = 1;
        hsync_in = 1;
        vsync_in = 1;
        repeat(2) @(posedge clk);
        pixclk = 1; @(posedge clk); pixclk = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(3'd0, 3'd0, 1'b1, 3'd0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        attcode = 8'h81;
        pixel = 1;
        blink = 1;
        repeat(2) @(posedge clk);
        pixclk = 1; @(posedge clk); pixclk = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(3'd0, 3'd0, 1'b0, 3'd0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        attcode = 8'h81;
        pixel = 1;
        blink = 0;
        repeat(2) @(posedge clk);
        pixclk = 1; @(posedge clk); pixclk = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(3'd0, 3'd0, 1'b0, 3'd4, 1'b0);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        attcode = 8'h50;
        pixel = 0;
        repeat(2) @(posedge clk);
        pixclk = 1; @(posedge clk); pixclk = 0;
        repeat(2) @(posedge clk);

        #1;


        check_outputs(3'd4, 3'd0, 1'b0, 3'd4, 1'b0);
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
        input [2:0] expected_b;
        input [2:0] expected_g;
        input expected_hsync;
        input [2:0] expected_r;
        input expected_vsync;
        begin
            if (expected_b === (expected_b ^ b ^ expected_b) &&
                expected_g === (expected_g ^ g ^ expected_g) &&
                expected_hsync === (expected_hsync ^ hsync ^ expected_hsync) &&
                expected_r === (expected_r ^ r ^ expected_r) &&
                expected_vsync === (expected_vsync ^ vsync ^ expected_vsync)) begin
                $display("PASS");
                $display("  Outputs: b=%h, g=%h, hsync=%b, r=%h, vsync=%b",
                         b, g, hsync, r, vsync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b=%h, g=%h, hsync=%b, r=%h, vsync=%b",
                         expected_b, expected_g, expected_hsync, expected_r, expected_vsync);
                $display("  Got:      b=%h, g=%h, hsync=%b, r=%h, vsync=%b",
                         b, g, hsync, r, vsync);
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
        $dumpvars(0,attcode, blank, blink, clk, hsync_in, pixclk, pixel, vsync_in, b, g, hsync, r, vsync);
    end

endmodule
