`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [9:0] CounterX;
    wire [9:0] CounterY;
    wire inDisplayArea;
    wire vga_h_sync;
    wire vga_v_sync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .CounterX(CounterX),
        .CounterY(CounterY),
        .inDisplayArea(inDisplayArea),
        .vga_h_sync(vga_h_sync),
        .vga_v_sync(vga_v_sync)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            #20;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(10'd0, 10'd0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            repeat(100) @(posedge clk);
            #1;
            #1;

            check_outputs(10'd100, 10'd0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            repeat(640) @(posedge clk);
            #1;

            #1;


            check_outputs(10'd640, 10'd0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            repeat(656) @(posedge clk);
            #1;
            #1;

            check_outputs(10'd656, 10'd0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            repeat(752) @(posedge clk);
            #1;
            #1;

            check_outputs(10'd752, 10'd0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            repeat(800) @(posedge clk);
            #1;
            #1;

            check_outputs(10'd0, 10'd1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            repeat(480 * 800) @(posedge clk);
            #1;
            #1;

            check_outputs(10'd0, 10'd480, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            repeat(490 * 800) @(posedge clk);
            #1;
            #1;

            check_outputs(10'd0, 10'd490, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            repeat(492 * 800) @(posedge clk);
            #1;
            #1;

            check_outputs(10'd0, 10'd492, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            repeat(525 * 800) @(posedge clk);
            #1;
            #1;

            check_outputs(10'd0, 10'd0, 1'b1, 1'b1, 1'b1);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [9:0] expected_CounterX;
        input [9:0] expected_CounterY;
        input expected_inDisplayArea;
        input expected_vga_h_sync;
        input expected_vga_v_sync;
        begin
            if (expected_CounterX === (expected_CounterX ^ CounterX ^ expected_CounterX) &&
                expected_CounterY === (expected_CounterY ^ CounterY ^ expected_CounterY) &&
                expected_inDisplayArea === (expected_inDisplayArea ^ inDisplayArea ^ expected_inDisplayArea) &&
                expected_vga_h_sync === (expected_vga_h_sync ^ vga_h_sync ^ expected_vga_h_sync) &&
                expected_vga_v_sync === (expected_vga_v_sync ^ vga_v_sync ^ expected_vga_v_sync)) begin
                $display("PASS");
                $display("  Outputs: CounterX=%h, CounterY=%h, inDisplayArea=%b, vga_h_sync=%b, vga_v_sync=%b",
                         CounterX, CounterY, inDisplayArea, vga_h_sync, vga_v_sync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CounterX=%h, CounterY=%h, inDisplayArea=%b, vga_h_sync=%b, vga_v_sync=%b",
                         expected_CounterX, expected_CounterY, expected_inDisplayArea, expected_vga_h_sync, expected_vga_v_sync);
                $display("  Got:      CounterX=%h, CounterY=%h, inDisplayArea=%b, vga_h_sync=%b, vga_v_sync=%b",
                         CounterX, CounterY, inDisplayArea, vga_h_sync, vga_v_sync);
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
        $dumpvars(0,clk, reset, CounterX, CounterY, inDisplayArea, vga_h_sync, vga_v_sync);
    end

endmodule
