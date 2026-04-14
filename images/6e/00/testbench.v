`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg pixel_clk;
    reg rst;
    wire [8:0] cntHS;
    wire [8:0] cntVS;
    wire hsync;
    wire out_sync;
    wire vbl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pixel_clk(pixel_clk),
        .rst(rst),
        .cntHS(cntHS),
        .cntVS(cntVS),
        .hsync(hsync),
        .out_sync(out_sync),
        .vbl(vbl)
    );

    // Clock generation (10ns period)
    initial begin
        pixel_clk = 0;
        forever #5 pixel_clk = ~pixel_clk;
    end

        task reset_dut;

        begin
            rst = 1;
            #20;
            rst = 0;
            @(posedge pixel_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(9'd0, 9'd0, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Horizontal Increment", test_num);
            reset_dut();
            repeat (100) @(posedge pixel_clk);
            #1;

            #1;


            check_outputs(9'd100, 9'd0, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Line Wrap (Horizontal Rollover)", test_num);
            reset_dut();

            repeat (455) @(posedge pixel_clk);
            #1;

            #1;


            check_outputs(9'd0, 9'd1, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: H-Sync Pulse Check", test_num);
            reset_dut();

            repeat (390) @(posedge pixel_clk);
            #1;


            #1;



            check_outputs(9'd390, 9'd0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Vertical Blanking Start", test_num);
            reset_dut();


            repeat (240 * 455) @(posedge pixel_clk);
            #1;

            #1;


            check_outputs(9'd0, 9'd240, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Frame Rollover", test_num);
            reset_dut();

            repeat (262 * 455) @(posedge pixel_clk);
            #1;

            #1;


            check_outputs(9'd0, 9'd0, 1'b1, 1'b1, 1'b0);
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
        input [8:0] expected_cntHS;
        input [8:0] expected_cntVS;
        input expected_hsync;
        input expected_out_sync;
        input expected_vbl;
        begin
            if (expected_cntHS === (expected_cntHS ^ cntHS ^ expected_cntHS) &&
                expected_cntVS === (expected_cntVS ^ cntVS ^ expected_cntVS) &&
                expected_hsync === (expected_hsync ^ hsync ^ expected_hsync) &&
                expected_out_sync === (expected_out_sync ^ out_sync ^ expected_out_sync) &&
                expected_vbl === (expected_vbl ^ vbl ^ expected_vbl)) begin
                $display("PASS");
                $display("  Outputs: cntHS=%h, cntVS=%h, hsync=%b, out_sync=%b, vbl=%b",
                         cntHS, cntVS, hsync, out_sync, vbl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cntHS=%h, cntVS=%h, hsync=%b, out_sync=%b, vbl=%b",
                         expected_cntHS, expected_cntVS, expected_hsync, expected_out_sync, expected_vbl);
                $display("  Got:      cntHS=%h, cntVS=%h, hsync=%b, out_sync=%b, vbl=%b",
                         cntHS, cntVS, hsync, out_sync, vbl);
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
        $dumpvars(0,pixel_clk, rst, cntHS, cntVS, hsync, out_sync, vbl);
    end

endmodule
