`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire hsync;
    wire [9:0] pixh;
    wire [9:0] pixv;
    wire vsync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .hsync(hsync),
        .pixh(pixh),
        .pixv(pixv),
        .vsync(vsync)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin


            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Testcase 001: Start of Frame (0,0)");
            reset_dut();

            #1;


            check_outputs(1'b1, 10'd0, 10'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase 002: End of Active Line 0 (639,0)");
            reset_dut();
            repeat(638) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 10'd639, 10'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Testcase 003: Horizontal Front Porch (Line 0)");
            reset_dut();
            repeat(9) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 10'd0, 10'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Testcase 004: Horizontal Sync Pulse Active");
            reset_dut();

            repeat(49) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 10'd0, 10'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nRunning Testcase 005: Start of Line 1 (0,1)");
            reset_dut();

            repeat(100) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 10'd0, 10'd1, 1'b1);
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
        input expected_hsync;
        input [9:0] expected_pixh;
        input [9:0] expected_pixv;
        input expected_vsync;
        begin
            if (expected_hsync === (expected_hsync ^ hsync ^ expected_hsync) &&
                expected_pixh === (expected_pixh ^ pixh ^ expected_pixh) &&
                expected_pixv === (expected_pixv ^ pixv ^ expected_pixv) &&
                expected_vsync === (expected_vsync ^ vsync ^ expected_vsync)) begin
                $display("PASS");
                $display("  Outputs: hsync=%b, pixh=%h, pixv=%h, vsync=%b",
                         hsync, pixh, pixv, vsync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hsync=%b, pixh=%h, pixv=%h, vsync=%b",
                         expected_hsync, expected_pixh, expected_pixv, expected_vsync);
                $display("  Got:      hsync=%b, pixh=%h, pixv=%h, vsync=%b",
                         hsync, pixh, pixv, vsync);
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
        $dumpvars(0,clk, hsync, pixh, pixv, vsync);
    end

endmodule
