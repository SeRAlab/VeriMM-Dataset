`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg fifo_empty;
    reg rst;
    wire blank;
    wire comp_sync;
    wire hsync;
    wire vsync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .fifo_empty(fifo_empty),
        .rst(rst),
        .blank(blank),
        .comp_sync(comp_sync),
        .hsync(hsync),
        .vsync(vsync)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        fifo_empty = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Active Region (Pixel 100, 0)", test_num);
        reset_dut();
        repeat(100) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Horizontal Blanking Start (Pixel 640, 0)", test_num);
        reset_dut();
        repeat(640) @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Horizontal Sync Pulse (Pixel 700, 0)", test_num);
        reset_dut();
        repeat(700) @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Vertical Line Wrap (Pixel 10, 1)", test_num);
        reset_dut();
        repeat(810) @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: FIFO Empty Reset", test_num);
        reset_dut();
        repeat(50) @(posedge clk);
        fifo_empty = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b1, 1'b1);
        fifo_empty = 0;
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Vertical Sync Region (Line 490)", test_num);
        reset_dut();

        repeat(392010) @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
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
        input expected_blank;
        input expected_comp_sync;
        input expected_hsync;
        input expected_vsync;
        begin
            if (expected_blank === (expected_blank ^ blank ^ expected_blank) &&
                expected_comp_sync === (expected_comp_sync ^ comp_sync ^ expected_comp_sync) &&
                expected_hsync === (expected_hsync ^ hsync ^ expected_hsync) &&
                expected_vsync === (expected_vsync ^ vsync ^ expected_vsync)) begin
                $display("PASS");
                $display("  Outputs: blank=%b, comp_sync=%b, hsync=%b, vsync=%b",
                         blank, comp_sync, hsync, vsync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: blank=%b, comp_sync=%b, hsync=%b, vsync=%b",
                         expected_blank, expected_comp_sync, expected_hsync, expected_vsync);
                $display("  Got:      blank=%b, comp_sync=%b, hsync=%b, vsync=%b",
                         blank, comp_sync, hsync, vsync);
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
        $dumpvars(0,clk, fifo_empty, rst, blank, comp_sync, hsync, vsync);
    end

endmodule
