`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg gfx_clk;
    reg rst;
    wire blank;
    wire h_sync;
    wire v_sync;
    wire [9:0] x;
    wire [9:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .gfx_clk(gfx_clk),
        .rst(rst),
        .blank(blank),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .x(x),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        gfx_clk = 0;
        forever #5 gfx_clk = ~gfx_clk;
    end

        task reset_dut;

        begin
            rst = 1;
            repeat(5) @(posedge gfx_clk);
            #1;
            rst = 0;
            repeat(2) @(posedge gfx_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking Reset State", test_num);
            reset_dut();



            #1;




            check_outputs(0, 1, 1, 10'd0, 10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Checking Horizontal Increment", test_num);
            reset_dut();
            repeat(10) @(posedge gfx_clk);
            #1;

            #1;


            check_outputs(0, 1, 1, 10'd10, 10'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Checking Horizontal Blanking Start", test_num);
            reset_dut();
            repeat(H_VISIBLE) @(posedge gfx_clk);
            #1;

            #1;


            check_outputs(1, 1, 1, 10'd640, 10'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Checking Line Wrap and Y increment", test_num);
            reset_dut();
            repeat(H_TOTAL) @(posedge gfx_clk);
            #1;

            #1;


            check_outputs(0, 1, 1, 10'd0, 10'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Checking H-Sync Pulse", test_num);
            reset_dut();
            repeat(H_VISIBLE + H_FRONT) @(posedge gfx_clk);
            #1;

            #1;


            check_outputs(1, 0, 1, 10'd656, 10'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Checking Vertical Blanking Start", test_num);
            reset_dut();
            repeat(H_TOTAL * V_VISIBLE) @(posedge gfx_clk);
            #1;

            #1;


            check_outputs(1, 1, 1, 10'd0, 10'd480);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Checking Full Frame Wrap", test_num);
            reset_dut();
            repeat(H_TOTAL * V_TOTAL) @(posedge gfx_clk);
            #1;

            #1;


            check_outputs(0, 1, 1, 10'd0, 10'd0);
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
        input expected_h_sync;
        input expected_v_sync;
        input [9:0] expected_x;
        input [9:0] expected_y;
        begin
            if (expected_blank === (expected_blank ^ blank ^ expected_blank) &&
                expected_h_sync === (expected_h_sync ^ h_sync ^ expected_h_sync) &&
                expected_v_sync === (expected_v_sync ^ v_sync ^ expected_v_sync) &&
                expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: blank=%b, h_sync=%b, v_sync=%b, x=%h, y=%h",
                         blank, h_sync, v_sync, x, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: blank=%b, h_sync=%b, v_sync=%b, x=%h, y=%h",
                         expected_blank, expected_h_sync, expected_v_sync, expected_x, expected_y);
                $display("  Got:      blank=%b, h_sync=%b, v_sync=%b, x=%h, y=%h",
                         blank, h_sync, v_sync, x, y);
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
        $dumpvars(0,clk, gfx_clk, rst, blank, h_sync, v_sync, x, y);
    end

endmodule
