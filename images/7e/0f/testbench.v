`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg pxl_clk;
    reg reset_n;
    wire [9:0] hcount;
    wire hsync;
    wire [9:0] vcount;
    wire vsync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pxl_clk(pxl_clk),
        .reset_n(reset_n),
        .hcount(hcount),
        .hsync(hsync),
        .vcount(vcount),
        .vsync(vsync)
    );

    // Clock generation (10ns period)
    initial begin
        pxl_clk = 0;
        forever #5 pxl_clk = ~pxl_clk;
    end

        task reset_dut;

        begin
            reset_n = 1'b0;
            @(posedge pxl_clk);
            #2;
            reset_n = 1'b1;
            @(posedge pxl_clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State", test_num);
            reset_dut();


            #1;



            check_outputs(10'd0, 1'b1, 10'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Incremental Counting", test_num);
            reset_dut();
            repeat(49) @(posedge pxl_clk);
            #2;

            #1;


            check_outputs(10'd49, 1'b1, 10'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Horizontal Sync Pulse Start", test_num);
            reset_dut();
            repeat(656) @(posedge pxl_clk);
            #2;

            #1;


            check_outputs(10'd656, 1'b0, 10'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Line Wrap and Vertical Increment", test_num);
            reset_dut();
            repeat(800) @(posedge pxl_clk);
            #2;

            #1;


            check_outputs(10'd0, 1'b1, 10'd1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Vertical Sync Pulse Start", test_num);
            reset_dut();

            repeat(490 * 800) @(posedge pxl_clk);
            #2;

            #1;


            check_outputs(10'd0, 1'b1, 10'd490, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Full Frame Wrap-around", test_num);
            reset_dut();

            repeat(525 * 800) @(posedge pxl_clk);
            #2;

            #1;


            check_outputs(10'd0, 1'b1, 10'd0, 1'b1);
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
        input [9:0] expected_hcount;
        input expected_hsync;
        input [9:0] expected_vcount;
        input expected_vsync;
        begin
            if (expected_hcount === (expected_hcount ^ hcount ^ expected_hcount) &&
                expected_hsync === (expected_hsync ^ hsync ^ expected_hsync) &&
                expected_vcount === (expected_vcount ^ vcount ^ expected_vcount) &&
                expected_vsync === (expected_vsync ^ vsync ^ expected_vsync)) begin
                $display("PASS");
                $display("  Outputs: hcount=%h, hsync=%b, vcount=%h, vsync=%b",
                         hcount, hsync, vcount, vsync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hcount=%h, hsync=%b, vcount=%h, vsync=%b",
                         expected_hcount, expected_hsync, expected_vcount, expected_vsync);
                $display("  Got:      hcount=%h, hsync=%b, vcount=%h, vsync=%b",
                         hcount, hsync, vcount, vsync);
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
        $dumpvars(0,pxl_clk, reset_n, hcount, hsync, vcount, vsync);
    end

endmodule
