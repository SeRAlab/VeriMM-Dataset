`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg pclk;
    reg reset;
    wire [9:0] h_cnt;
    wire hsync;
    wire [9:0] v_cnt;
    wire valid;
    wire vsync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pclk(pclk),
        .reset(reset),
        .h_cnt(h_cnt),
        .hsync(hsync),
        .v_cnt(v_cnt),
        .valid(valid),
        .vsync(vsync)
    );

    // Clock generation (10ns period)
    initial begin
        pclk = 0;
        forever #5 pclk = ~pclk;
    end

        task reset_dut;

        begin
            reset = 1;
            repeat(5) @(posedge pclk);
            #2 reset = 0;
            @(posedge pclk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(10'd0, 1'b1, 10'd0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: End of visible area (pixel 639)", test_num);
            reset_dut();
            repeat(639) @(posedge pclk);
            #2;
            #1;

            check_outputs(10'd639, 1'b1, 10'd0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Horizontal Front Porch start (pixel 640)", test_num);
            reset_dut();
            repeat(640) @(posedge pclk);
            #2;

            #1;


            check_outputs(10'd640, 1'b1, 10'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Horizontal Sync start (pixel 656)", test_num);
            reset_dut();
            repeat(656) @(posedge pclk);
            #2;

            #1;


            check_outputs(10'd656, 1'b0, 10'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Horizontal Sync end (pixel 752)", test_num);
            reset_dut();
            repeat(752) @(posedge pclk);
            #2;

            #1;


            check_outputs(10'd752, 1'b1, 10'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Second line start (h=0, v=1)", test_num);
            reset_dut();
            repeat(800) @(posedge pclk);
            #2;

            #1;


            check_outputs(10'd0, 1'b1, 10'd1, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Check state at Row 10", test_num);
            reset_dut();
            repeat(800 * 10) @(posedge pclk);
            #2;
            #1;

            check_outputs(10'd0, 1'b1, 10'd10, 1'b1, 1'b1);
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
        input [9:0] expected_h_cnt;
        input expected_hsync;
        input [9:0] expected_v_cnt;
        input expected_valid;
        input expected_vsync;
        begin
            if (expected_h_cnt === (expected_h_cnt ^ h_cnt ^ expected_h_cnt) &&
                expected_hsync === (expected_hsync ^ hsync ^ expected_hsync) &&
                expected_v_cnt === (expected_v_cnt ^ v_cnt ^ expected_v_cnt) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid) &&
                expected_vsync === (expected_vsync ^ vsync ^ expected_vsync)) begin
                $display("PASS");
                $display("  Outputs: h_cnt=%h, hsync=%b, v_cnt=%h, valid=%b, vsync=%b",
                         h_cnt, hsync, v_cnt, valid, vsync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h_cnt=%h, hsync=%b, v_cnt=%h, valid=%b, vsync=%b",
                         expected_h_cnt, expected_hsync, expected_v_cnt, expected_valid, expected_vsync);
                $display("  Got:      h_cnt=%h, hsync=%b, v_cnt=%h, valid=%b, vsync=%b",
                         h_cnt, hsync, v_cnt, valid, vsync);
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
        $dumpvars(0,pclk, reset, h_cnt, hsync, v_cnt, valid, vsync);
    end

endmodule
